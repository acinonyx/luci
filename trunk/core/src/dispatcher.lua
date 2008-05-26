--[[
LuCI - Dispatcher

Description:
The request dispatcher and module dispatcher generators

FileId:
$Id$

License:
Copyright 2008 Steven Barth <steven@midlink.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

]]--
module("luci.dispatcher", package.seeall)
require("luci.http")
require("luci.sys")
require("luci.fs")

-- Local dispatch database
local tree = {nodes={}}

-- Index table
local index = {}

-- Global request object
request = {}

-- Active dispatched node
dispatched = nil

-- Status fields
built_index = false
built_tree  = false


-- Builds a URL
function build_url(...)
	return luci.http.dispatcher() .. "/" .. table.concat(arg, "/")
end

-- Sends a 404 error code and renders the "error404" template if available
function error404(message)
	luci.http.status(404, "Not Found")
	message = message or "Not Found"

	require("luci.template")
	if not pcall(luci.template.render, "error404") then
		luci.http.prepare_content("text/plain")
		print(message)
	end
	return false
end

-- Sends a 500 error code and renders the "error500" template if available
function error500(message)
	luci.http.status(500, "Internal Server Error")

	require("luci.template")
	if not pcall(luci.template.render, "error500", {message=message}) then
		luci.http.prepare_content("text/plain")
		print(message)
	end
	return false
end

-- Creates a request object for dispatching
function httpdispatch()
	local pathinfo = luci.http.env.PATH_INFO or ""
	local c = tree

	for s in pathinfo:gmatch("([%w_]+)") do
		table.insert(request, s)
	end

	dispatch()
end

-- Dispatches a request
function dispatch()
	if not built_tree then
		createtree()
	end

	local c = tree
	local track = {}

	for i, s in ipairs(request) do
		c = c.nodes[s]
		if not c then
			break
		end

		for k, v in pairs(c) do
			track[k] = v
		end
	end


	if track.i18n then
		require("luci.i18n").loadc(track.i18n)
	end

	if track.setgroup then
		luci.sys.process.setgroup(track.setgroup)
	end

	if track.setuser then
		luci.sys.process.setuser(track.setuser)
	end
	
	-- Init template engine
	local tpl = require("luci.template")
	tpl.viewns.translate  = function(...) return require("luci.i18n").translate(...) end
	tpl.viewns.controller = luci.http.dispatcher()
	tpl.viewns.uploadctrl = luci.http.dispatcher_upload()
	tpl.viewns.media      = luci.config.main.mediaurlbase
	tpl.viewns.resource   = luci.config.main.resourcebase


	if c and type(c.target) == "function" then
		dispatched = c

		stat, err = pcall(c.target)
		if not stat then
			error500(err)
		end
	else
		error404()
	end
end

-- Generates the dispatching tree
function createindex()
	index = {}
	local path = luci.sys.libpath() .. "/controller/"
	local suff = ".lua"
	
	if pcall(require, "fastindex") then
		createindex_fastindex(path, suff)
	else
		createindex_plain(path, suff)
	end
	
	built_index = true
end

-- Uses fastindex to create the dispatching tree
function createindex_fastindex(path, suffix)	
	local fi = fastindex.new("index")
	fi.add(path .. "*" .. suffix)
	fi.add(path .. "*/*" .. suffix)
	fi.scan()
	
	for k, v in pairs(fi.indexes) do
		index[v[2]] = v[1]
	end
end

-- Calls the index function of all available controllers
function createindex_plain(path, suffix)
	local controllers = luci.util.combine(
		luci.fs.glob(path .. "*" .. suffix) or {},
		luci.fs.glob(path .. "*/*" .. suffix) or {}
	)

	for i,c in ipairs(controllers) do
		c = "luci.controller." .. c:sub(#path+1, #c-#suffix):gsub("/", ".")
		stat, mod = pcall(require, c)

		if stat and mod and type(mod.index) == "function" then
			index[c] = mod.index
		end
	end
end

-- Creates the dispatching tree from the index
function createtree()
	if not built_index then
		createindex()
	end

	for k, v in pairs(index) do
		luci.util.updfenv(v, _M)
		
		local stat, mod = pcall(require, k)
		if stat then		
			luci.util.updfenv(v, mod)
		end
		
		pcall(v)
	end
	
	built_tree = true
end

-- Shortcut for creating a dispatching node
function entry(path, target, title, order, add)
	add = add or {}

	local c = node(path)
	c.target = target
	c.title  = title
	c.order  = order

	for k,v in pairs(add) do
		c[k] = v
	end

	return c
end

-- Fetch a dispatching node
function node(...)
	local c = tree

	if arg[1] and type(arg[1]) == "table" then
		arg = arg[1]
	end

	for k,v in ipairs(arg) do
		if not c.nodes[v] then
			c.nodes[v] = {nodes={}}
		end

		c = c.nodes[v]
	end

	return c
end

-- Subdispatchers --
function alias(...)
	local req = arg
	return function()
		request = req
		dispatch()
	end
end

function template(name)
	require("luci.template")
	return function() luci.template.render(name) end
end

function cbi(model)
	require("luci.cbi")
	require("luci.template")

	return function()
		local stat, res = pcall(luci.cbi.load, model)
		if not stat then
			error500(res)
			return true
		end

		local stat, err = pcall(res.parse, res)
		if not stat then
			error500(err)
			return true
		end

		luci.template.render("cbi/header")
		res:render()
		luci.template.render("cbi/footer")
	end
end
