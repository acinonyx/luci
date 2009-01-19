--[[
LuCI - UCI model

Description:
Generalized UCI model

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
local os    = require "os"
local uci   = require "uci"
local util  = require "luci.util"
local table = require "table"


local setmetatable, rawget, rawset = setmetatable, rawget, rawset
local error, pairs, ipairs, tostring = error, pairs, ipairs, tostring
local require, getmetatable, type = require, getmetatable, type

--- LuCI UCI model library.
-- @cstyle	instance
module "luci.model.uci"

--- Create a new UCI-Cursor.
-- @class function
-- @name cursor
-- @return	UCI-Cursor
cursor = uci.cursor

APIVERSION = uci.APIVERSION

--- Create a new Cursor initialized to the state directory.
-- @return UCI cursor
function cursor_state()
	return cursor(nil, "/var/state")
end


local Cursor = getmetatable(cursor())

--- Applies UCI configuration changes
-- @param configlist		List of UCI configurations
-- @param command			Don't apply only return the command
function Cursor.apply(self, configlist, command)
	configlist = self:_affected(configlist)
	local reloadcmd = "/sbin/luci-reload " .. table.concat(configlist, " ")

	return command and reloadcmd or os.execute(reloadcmd .. " >/dev/null 2>&1")
end


--- Delete all sections of a given type that match certain criteria.
-- @param config		UCI config
-- @param type			UCI section type
-- @param comparator	Function that will be called for each section and
-- returns a boolean whether to delete the current section (optional)
function Cursor.delete_all(self, config, stype, comparator)
	local del = {}

	if type(comparator) == "table" then
		local tbl = comparator
		comparator = function(section)
			for k, v in pairs(tbl) do
				if section[k] ~= v then
					return false
				end
			end
			return true
		end
	end

	local function helper (section)

		if not comparator or comparator(section) then
			del[#del+1] = section[".name"]
		end
	end

	self:foreach(config, stype, helper)

	for i, j in ipairs(del) do
		self:delete(config, j)
	end
end

--- Create a new section and initialize it with data.
-- @param config	UCI config
-- @param type		UCI section type
-- @param name		UCI section name (optional)
-- @param values	Table of key - value pairs to initialize the section with
-- @return			Name of created section
function Cursor.section(self, config, type, name, values)
	local stat = true
	if name then
		stat = self:set(config, name, type)
	else
		name = self:add(config, type)
		stat = name and true
	end

	if stat and values then
		stat = self:tset(config, name, values)
	end

	return stat and name
end

--- Updated the data of a section using data from a table.
-- @param config	UCI config
-- @param section	UCI section name (optional)
-- @param values	Table of key - value pairs to update the section with
function Cursor.tset(self, config, section, values)
	local stat = true
	for k, v in pairs(values) do
		if k:sub(1, 1) ~= "." then
			stat = stat and self:set(config, section, k, v)
		end
	end
	return stat
end

--- Get a boolean option and return it's value as true or false.
-- @param config	UCI config
-- @param section	UCI section name
-- @param option	UCI option
-- @return			Boolean
function Cursor.get_bool(self, ...)
	local val = self:get(...)
	return ( val == "1" or val == "true" or val == "yes" or val == "on" )
end

--- Get an option or list and return values as table.
-- @param config	UCI config
-- @param section	UCI section name
-- @param option	UCI option
-- @return			UCI value
function Cursor.get_list(self, config, section, option)
	if config and section and option then
		local val = self:get(config, section, option)
		return ( type(val) == "table" and val or { val } )
	end
	return nil
end

--- Set given values as list.
-- @param config	UCI config
-- @param section	UCI section name
-- @param option	UCI option
-- @param value		UCI value
-- @return			Boolean whether operation succeeded
function Cursor.set_list(self, config, section, option, value)
	if config and section and option then
		return self:set(
			config, section, option,
			( type(value) == "table" and value or { value } )
		)
	end
	return false
end

-- Return a list of initscripts affected by configuration changes.
function Cursor._affected(self, configlist)
	configlist = type(configlist) == "table" and configlist or {configlist}

	local c = cursor()
	c:load("ucitrack")

	-- Resolve dependencies
	local reloadlist = {}

	local function _resolve_deps(name)
		local reload = {name}
		local deps = {}

		c:foreach("ucitrack", name,
			function(section)
				if section.affects then
					for i, aff in ipairs(section.affects) do
						deps[#deps+1] = aff
					end
				end
			end)

		for i, dep in ipairs(deps) do
			for j, add in ipairs(_resolve_deps(dep)) do
				reload[#reload+1] = add
			end
		end

		return reload
	end

	-- Collect initscripts
	for j, config in ipairs(configlist) do
		for i, e in ipairs(_resolve_deps(config)) do
			if not util.contains(reloadlist, e) then
				reloadlist[#reloadlist+1] = e
			end
		end
	end

	return reloadlist
end


--- Add an anonymous section.
-- @class function
-- @name Cursor.add
-- @param config	UCI config
-- @param type		UCI section type
-- @return			Name of created section

--- Get a table of unsaved changes.
-- @class function
-- @name Cursor.changes
-- @param config	UCI config
-- @return			Table of changes

--- Commit unsaved changes.
-- @class function
-- @name Cursor.commit
-- @param config	UCI config
-- @return			Boolean whether operation succeeded
-- @see Cursor.revert

--- Deletes a section or an option.
-- @class function
-- @name Cursor.delete
-- @param config	UCI config
-- @param section	UCI section name
-- @param option	UCI option (optional)
-- @return			Boolean whether operation succeeded

--- Call a function for every section of a certain type.
-- @class function
-- @name Cursor.foreach
-- @param config	UCI config
-- @param type		UCI section type
-- @param callback	Function to be called
-- @return			Boolean whether operation succeeded

--- Get a section type or an option
-- @class function
-- @name Cursor.get
-- @param config	UCI config
-- @param section	UCI section name
-- @param option	UCI option (optional)
-- @return			UCI value

--- Get all sections of a config or all values of a section.
-- @class function
-- @name Cursor.get_all
-- @param config	UCI config
-- @param section	UCI section name (optional)
-- @return			Table of UCI sections or table of UCI values

--- Manually load a config.
-- @class function
-- @name Cursor.load
-- @param config	UCI config
-- @return			Boolean whether operation succeeded
-- @see Cursor.save
-- @see Cursor.unload

--- Revert unsaved changes.
-- @class function
-- @name Cursor.revert
-- @param config	UCI config
-- @return			Boolean whether operation succeeded
-- @see Cursor.commit

--- Saves changes made to a config to make them committable.
-- @class function
-- @name Cursor.save
-- @param config	UCI config
-- @return			Boolean whether operation succeeded
-- @see Cursor.load
-- @see Cursor.unload

--- Set a value or create a named section.
-- @class function
-- @name Cursor.set
-- @param config	UCI config
-- @param section	UCI section name
-- @param option	UCI option or UCI section type
-- @param value		UCI value or nil if you want to create a section
-- @return			Boolean whether operation succeeded

--- Get the configuration directory.
-- @class function
-- @name Cursor.get_confdir
-- @return			Configuration directory

--- Get the directory for uncomitted changes.
-- @class function
-- @name Cursor.get_savedir
-- @return			Save directory

--- Set the configuration directory.
-- @class function
-- @name Cursor.set_confdir
-- @param directory	UCI configuration directory
-- @return			Boolean whether operation succeeded

--- Set the directory for uncommited changes.
-- @class function
-- @name Cursor.set_savedir
-- @param directory	UCI changes directory
-- @return			Boolean whether operation succeeded

--- Discard changes made to a config.
-- @class function
-- @name Cursor.unload
-- @param config	UCI config
-- @return			Boolean whether operation succeeded
-- @see Cursor.load
-- @see Cursor.save
