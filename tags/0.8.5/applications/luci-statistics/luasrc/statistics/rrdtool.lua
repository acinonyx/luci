--[[

Luci statistics - rrdtool interface library / diagram model interpreter
(c) 2008 Freifunk Leipzig / Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

$Id$

]]--

module("luci.statistics.rrdtool", package.seeall)

require("luci.statistics.datatree")
require("luci.statistics.rrdtool.colors")
require("luci.statistics.rrdtool.definitions")
require("luci.statistics.i18n")
require("luci.model.uci")
require("luci.util")
require("luci.sys")
require("luci.fs")


Graph = luci.util.class()

function Graph.__init__( self, timespan, opts )

	opts = opts or { }

	local uci = luci.model.uci.cursor()
	local sections = uci:get_all( "luci_statistics" )

	-- helper classes
	self.colors = luci.statistics.rrdtool.colors.Instance()
	self.defs   = luci.statistics.rrdtool.definitions.Instance()
	self.tree   = luci.statistics.datatree.Instance()
	self.i18n   = luci.statistics.i18n.Instance( self )

	-- options
	opts.timespan  = timespan       or sections.rrdtool.default_timespan or 900
	opts.rrasingle = opts.rrasingle or ( sections.collectd_rrdtool.RRASingle == "1" )
	opts.host      = opts.host      or sections.collectd.Hostname        or luci.sys.hostname()
	opts.width     = opts.width     or sections.rrdtool.image_width      or 400
	opts.rrdpath   = opts.rrdpath   or sections.collectd_rrdtool.DataDir or "/tmp/rrd"
	opts.imgpath   = opts.imgpath   or sections.rrdtool.image_path       or "/tmp/rrdimg"
	opts.rrdpath   = opts.rrdpath:gsub("/$","")
	opts.imgpath   = opts.imgpath:gsub("/$","")

	-- rrdtool default args
	self.args = {
		"-a", "PNG",
		"-s", "NOW-" .. opts.timespan,
		"-w", opts.width
	}

	-- store options
	self.opts = opts
end

function Graph._mkpath( self, plugin, plugin_instance, dtype, dtype_instance )
	local t = self.opts.host .. "/" .. plugin
	if type(plugin_instance) == "string" and plugin_instance:len() > 0 then
		t = t .. "-" .. plugin_instance
	end
	t = t .. "/" .. dtype
	if type(dtype_instance) == "string" and dtype_instance:len() > 0 then
		t = t .. "-" .. dtype_instance
	end
	return t
end

function Graph.mkrrdpath( self, ... )
	return string.format( "%s/%s.rrd", self.opts.rrdpath, self:_mkpath( ... ) )
end

function Graph.mkpngpath( self, ... )
	return string.format( "%s/%s.%i.png", self.opts.imgpath, self:_mkpath( ... ), self.opts.timespan )
end

function Graph.strippngpath( self, path )
	return path:sub( self.opts.imgpath:len() + 2 )
end

function Graph._forcelol( self, list )
	if type(list[1]) ~= "table" then
		return( { list } )
	end
	return( list )
end

function Graph._rrdtool( self, def, rrd )

	-- prepare directory
	local dir = def[1]:gsub("/[^/]+$","")
	luci.fs.mkdir( dir, true )

	-- construct commandline
	local cmdline = "rrdtool graph"

	-- copy default arguments to def stack
	for i, opt in ipairs(self.args) do
		table.insert( def, 1 + i, opt )
	end

	-- construct commandline from def stack
	for i, opt in ipairs(def) do
		opt = opt .. ""    -- force string

		if rrd then
			opt = opt:gsub( "{file}", rrd )
		end

		if opt:match("[^%w]") then
			cmdline = cmdline .. " '" .. opt .. "'"
		else
			cmdline = cmdline .. " " .. opt
		end
	end

	-- execute rrdtool
	local rrdtool = io.popen( cmdline )
	rrdtool:close()
end

function Graph._generic( self, opts, plugin, plugin_instance, dtype, index )

	-- generated graph defs
	local defs = { }

	-- internal state variables
	local _args         = { }
	local _sources	    = { }
	local _stack_neg    = { }
	local _stack_pos    = { }
	local _longest_name = 0
	local _has_totals   = false

	-- some convenient aliases
	local _ti	    = table.insert
	local _sf	    = string.format

	-- local helper: append a string.format() formatted string to given table
	function _tif( list, fmt, ... )
		table.insert( list, string.format( fmt, ... ) )
	end

	-- local helper: create definitions for min, max, avg and create *_nnl (not null) variable from avg
	function __def(source)

		local inst = source.sname
		local rrd  = source.rrd
		local ds   = source.ds

		if not ds or ds:len() == 0 then ds = "value" end

		_tif( _args, "DEF:%s_avg=%s:%s:AVERAGE", inst, rrd, ds )

		if not self.opts.rrasingle then
			_tif( _args, "DEF:%s_min=%s:%s:MIN", inst, rrd, ds )
			_tif( _args, "DEF:%s_max=%s:%s:MAX", inst, rrd, ds )
		end

		_tif( _args, "CDEF:%s_nnl=%s_avg,UN,0,%s_avg,IF", inst, inst, inst )
	end

	-- local helper: create cdefs depending on source options like flip and overlay
	function __cdef(source)

		local prev

		-- find previous source, choose stack depending on flip state
		if source.flip then
			prev = _stack_neg[#_stack_neg]
		else
			prev = _stack_pos[#_stack_pos]
		end

		-- is first source in stack or overlay source: source_stk = source_nnl
		if not prev or source.overlay then
			-- create cdef statement
			_tif( _args, "CDEF:%s_stk=%s_nnl", source.sname, source.sname )

		-- is subsequent source without overlay: source_stk = source_nnl + previous_stk
		else
			-- create cdef statement
			_tif( _args, "CDEF:%s_stk=%s_nnl,%s_stk,+", source.sname, source.sname, prev )
		end

		-- create multiply by minus one cdef if flip is enabled
		if source.flip then

			-- create cdef statement: source_stk = source_stk * -1
			_tif( _args, "CDEF:%s_neg=%s_stk,-1,*", source.sname, source.sname )

			-- push to negative stack if overlay is disabled
			if not source.overlay then
				_ti( _stack_neg, source.sname )
			end

		-- no flipping, push to positive stack if overlay is disabled
		elseif not source.overlay then

			-- push to positive stack
			_ti( _stack_pos, source.sname )
		end

		-- calculate total amount of data if requested
		if source.total then
			_tif( _args,
				"CDEF:%s_avg_sample=%s_avg,UN,0,%s_avg,IF,sample_len,*",
				source.sname, source.sname, source.sname
			)

			_tif( _args,
				"CDEF:%s_avg_sum=PREV,UN,0,PREV,IF,%s_avg_sample,+",
				source.sname, source.sname, source.sname
			)
		end
	end

	-- local helper: create cdefs required for calculating total values
	function __cdef_totals()
		if _has_totals then
			_tif( _args, "CDEF:mytime=%s_avg,TIME,TIME,IF", _sources[1].sname    )
			_ti(  _args, "CDEF:sample_len_raw=mytime,PREV(mytime),-"             )
			_ti(  _args, "CDEF:sample_len=sample_len_raw,UN,0,sample_len_raw,IF" )
		end
	end

	-- local helper: create line and area statements
	function __line(source)

		local line_color
		local area_color
		local legend
		local var

		-- find colors: try source, then opts.colors; fall back to random color
		if type(source.color) == "string" then
			line_color = source.color
			area_color = self.colors:from_string( line_color )
		elseif type(opts.colors[source.name:gsub("[^%w]","_")]) == "string" then
			line_color = opts.colors[source.name:gsub("[^%w]","_")]
			area_color = self.colors:from_string( line_color )
		else
			area_color = self.colors:random()
			line_color = self.colors:to_string( area_color )
		end

		-- derive area background color from line color
		area_color = self.colors:to_string( self.colors:faded( area_color ) )

		-- choose source_stk or source_neg variable depending on flip state
		if source.flip then
			var = "neg"
		else
			var = "stk"
		end

		-- create legend
		legend = _sf( "%-" .. _longest_name .. "s", source.title )

		-- create area if not disabled
		if not source.noarea then
			_tif( _args, "AREA:%s_%s#%s", source.sname, var, area_color )
		end

		-- create line1 statement
		_tif( _args, "LINE1:%s_%s#%s:%s", source.sname, var, line_color, legend )
	end

	-- local helper: create gprint statements
	function __gprint(source)

		local numfmt = opts.number_format or "%6.1lf"
		local totfmt = opts.totals_format or "%5.1lf%s"

		-- don't include MIN if rrasingle is enabled
		if not self.opts.rrasingle then
			_tif( _args, "GPRINT:%s_min:MIN:\tMin\\: %s", source.sname, numfmt )
		end

		-- always include AVERAGE
		_tif( _args, "GPRINT:%s_avg:AVERAGE:\tAvg\\: %s", source.sname, numfmt )

		-- don't include MAX if rrasingle is enabled
		if not self.opts.rrasingle then
			_tif( _args, "GPRINT:%s_max:MAX:\tMax\\: %s", source.sname, numfmt )
		end

		-- include total count if requested else include LAST
		if source.total then
			_tif( _args, "GPRINT:%s_avg_sum:LAST:(ca. %s Total)\\l", source.sname, totfmt )
		else
			_tif( _args, "GPRINT:%s_avg:LAST:\tLast\\: %s\\l", source.sname, numfmt )
		end
	end


	--
	-- find all data sources
	--

	-- find data types
	local data_types

	if dtype then
		data_types = { dtype }
	else
		data_types = opts.data.types or { }
	end

	if not ( dtype or opts.data.types ) then
		if opts.data.instances then
			for k, v in pairs(opts.data.instances) do
				_ti( data_types, k )
			end
		elseif opts.data.sources then
			for k, v in pairs(opts.data.sources) do
				_ti( data_types, k )
			end
		end
	end


	-- iterate over data types
	for i, dtype in ipairs(data_types) do

		-- find instances

		local data_instances

		if not opts.per_instance then
			if type(opts.data.instances) == "table" and type(opts.data.instances[dtype]) == "table" then
				data_instances = opts.data.instances[dtype]
			else
				data_instances = self.tree:data_instances( plugin, plugin_instance, dtype )
			end
		end

		if type(data_instances) ~= "table" or #data_instances == 0 then data_instances = { "" } end


		-- iterate over data instances
		for i, dinst in ipairs(data_instances) do

			-- construct combined data type / instance name
			local dname = dtype

			if dinst:len() > 0 then
				dname = dname .. "_" .. dinst
			end


			-- find sources
			local data_sources = { "value" }

			if type(opts.data.sources) == "table" then
				if type(opts.data.sources[dname]) == "table" then
					data_sources = opts.data.sources[dname]
				elseif type(opts.data.sources[dtype]) == "table" then
					data_sources = opts.data.sources[dtype]
				end
			end


			-- iterate over data sources
			for i, dsource in ipairs(data_sources) do

				local dsname  = dtype .. "_" .. dinst:gsub("[^%w]","_") .. "_" .. dsource
				local altname = dtype .. "__" .. dsource

				-- find datasource options
				local dopts = { }

				if type(opts.data.options) == "table" then
					if type(opts.data.options[dsname]) == "table" then
						dopts = opts.data.options[dsname]
					elseif type(opts.data.options[altname]) == "table" then
						dopts = opts.data.options[altname]
					elseif type(opts.data.options[dname]) == "table" then
						dopts = opts.data.options[dname]
					elseif type(opts.data.options[dtype]) == "table" then
						dopts = opts.data.options[dtype]
					end
				end


				-- store values
				_ti( _sources, {
					rrd      = dopts.rrd     or self:mkrrdpath( plugin, plugin_instance, dtype, dinst ),
					color    = dopts.color   or self.colors:to_string( self.colors:random() ),
					flip     = dopts.flip    or false,
					total    = dopts.total   or false,
					overlay  = dopts.overlay or false,
					noarea   = dopts.noarea  or false,
					ds       = dsource,
					type     = dtype,
					instance = dinst,
					index    = #_sources + 1,
					sname    = ( #_sources + 1 ) .. dtype
				} )


				-- generate datasource title
				_sources[#_sources].title = self.i18n:ds( _sources[#_sources] )


				-- find longest name ...
				if _sources[#_sources].title:len() > _longest_name then
					_longest_name = _sources[#_sources].title:len()
				end


				-- has totals?
				if _sources[#_sources].total then
					_has_totals = true
				end
			end
		end
	end


	--
	-- construct diagrams
	--

	-- if per_instance is enabled then find all instances from the first datasource in diagram
	-- if per_instance is disabled then use an empty pseudo instance and use model provided values
	local instances = { "" }

	if opts.per_instance then
		instances = self.tree:data_instances( plugin, plugin_instance, _sources[1].type )
	end


	-- iterate over instances
	for i, instance in ipairs(instances) do

		-- store title and vlabel
		_ti( _args, "-t" )
		_ti( _args, opts.title  or self.i18n:title( plugin, plugin_instance, _sources[1].type, instance ) )
		_ti( _args, "-v" )
		_ti( _args, opts.vlabel or self.i18n:label( plugin, plugin_instance, _sources[1].type, instance ) )

		-- store additional rrd options
		if opts.rrdopts then
			for i, o in ipairs(opts.rrdopts) do _ti( _args, o ) end
		end


		-- create DEF statements for each instance
		for i, source in ipairs(_sources) do
			-- fixup properties for per instance mode...
			if opts.per_instance then
				source.instance = instance
				source.rrd      = self:mkrrdpath( plugin, plugin_instance, source.type, instance )
			end

			__def( source )
		end

		-- create CDEF required for calculating totals
		__cdef_totals()

		-- create CDEF statements for each instance in reversed order
		for i, source in ipairs(_sources) do
			__cdef( _sources[1 + #_sources - i] )
		end

		-- create LINE1, AREA and GPRINT statements for each instance
		for i, source in ipairs(_sources) do
			__line( source )
			__gprint( source )
		end

		-- prepend image path to arg stack
		_ti( _args, 1, self:mkpngpath( plugin, plugin_instance, index .. instance ) )

		-- push arg stack to definition list
		_ti( defs, _args )

		-- reset stacks
		_args         = { }
		_stack_pos    = { }
		_stack_neg    = { }
	end

	return defs
end

function Graph.render( self, plugin, plugin_instance )

	dtype_instances = dtype_instances or { "" }
	local pngs = { }

	-- check for a whole graph handler
	local plugin_def = "luci.statistics.rrdtool.definitions." .. plugin
	local stat, def = luci.util.copcall( require, plugin_def )

	if stat and def and type(def.rrdargs) == "function" then

		-- temporary image matrix
		local _images = { }

		-- get diagram definitions
		for i, opts in ipairs( self:_forcelol( def.rrdargs( self, plugin, plugin_instance ) ) ) do

			_images[i] = { }

			-- get diagram definition instances
			local diagrams = self:_generic( opts, plugin, plugin_instance, nil, i )

			-- render all diagrams
			for j, def in ipairs( diagrams ) do

				-- remember image
				_images[i][j] = def[1]

				-- exec
				self:_rrdtool( def )
			end
		end

		-- remember images - XXX: fixme (will cause probs with asymmetric data)
		for y = 1, #_images[1] do
			for x = 1, #_images do
				table.insert( pngs, _images[x][y] )
			end
		end
	else

		-- no graph handler, iterate over data types
		for i, dtype in ipairs( self.tree:data_types( plugin, plugin_instance ) ) do

			-- check for data type handler
			local dtype_def = plugin_def .. "." .. dtype
			local stat, def = luci.util.copcall( require, dtype_def )

			if stat and def and type(def.rrdargs) == "function" then

				-- temporary image matrix
				local _images = { }

				-- get diagram definitions
				for i, opts in ipairs( self:_forcelol( def.rrdargs( self, plugin, plugin_instance, dtype ) ) ) do

					_images[i] = { }

					-- get diagram definition instances
					local diagrams = self:_generic( opts, plugin, plugin_instance, dtype, i )

					-- render all diagrams
					for j, def in ipairs( diagrams ) do

						-- remember image
						_images[i][j] = def[1]

						-- exec
						self:_rrdtool( def )
					end
				end

				-- remember images - XXX: fixme (will cause probs with asymmetric data)
				for y = 1, #_images[1] do
					for x = 1, #_images do
						table.insert( pngs, _images[x][y] )
					end
				end
			else

				-- no data type handler, fall back to builtin definition
				if type(self.defs.definitions[dtype]) == "table" then

					-- iterate over data type instances
					for i, inst in ipairs( self.tree:data_instances( plugin, plugin_instance, dtype ) ) do

						local title = self.i18n:title( plugin, plugin_instance, dtype, inst )
						local label = self.i18n:label( plugin, plugin_instance, dtype, inst )
						local png   = self:mkpngpath( plugin, plugin_instance, dtype, inst )
						local rrd   = self:mkrrdpath( plugin, plugin_instance, dtype, inst )
						local args  = { png, "-t", title, "-v", label }

						for i, o in ipairs(self.defs.definitions[dtype]) do
							-- XXX: this is a somewhat ugly hack to exclude min/max RRAs when rrasingle is on
							if not ( self.opts.rrasingle and ( o:match("_min") or o:match("_max") ) ) then
								table.insert( args, o )
							end
						end

						-- remember image
						table.insert( pngs, png )

						-- exec
						self:_rrdtool( args, rrd )
					end
				end
			end
		end
	end

	return pngs
end
