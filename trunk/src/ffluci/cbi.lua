--[[
FFLuCI - Configuration Bind Interface

Description:
Offers an interface for binding confiugration values to certain
data types. Supports value and range validation and basic dependencies.

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
module("ffluci.cbi", package.seeall)

require("ffluci.template")
require("ffluci.util")
require("ffluci.http")
require("ffluci.model.uci")

local Template   = ffluci.template.Template
local class      = ffluci.util.class
local instanceof = ffluci.util.instanceof


function load(cbimap)
	require("ffluci.fs")
	require("ffluci.i18n")
	
	local cbidir = ffluci.fs.dirname(ffluci.util.__file__()) .. "model/cbi/"
	local func, err = loadfile(cbidir..cbimap..".lua")
	
	if not func then
		error(err)
		return nil
	end
	
	ffluci.util.resfenv(func)
	ffluci.util.updfenv(func, ffluci.cbi)
	ffluci.util.extfenv(func, "translate", ffluci.i18n.translate)
	
	local map = func()
	
	if not instanceof(map, Map) then
		error("CBI map returns no valid map object!")
		return nil
	end
	
	ffluci.i18n.loadc("cbi")
	
	return map
end

-- Node pseudo abstract class
Node = class()

function Node.__init__(self, title, description)
	self.children = {}
	self.title = title or ""
	self.description = description or ""
	self.template = "cbi/node"
end

function Node.append(self, obj)
	table.insert(self.children, obj)
end

function Node.parse(self)
	for k, child in ipairs(self.children) do
		child:parse()
	end
end

function Node.render(self)
	ffluci.template.render(self.template, {self=self})
end

function Node.render_children(self)
	for k, node in ipairs(self.children) do
		node:render()
	end
end


--[[
Map - A map describing a configuration file 
]]--
Map = class(Node)

function Map.__init__(self, config, ...)
	Node.__init__(self, ...)
	self.config = config
	self.template = "cbi/map"
	self.uci = ffluci.model.uci.Session()
end

function Map.parse(self)
	self.ucidata = self.uci:show(self.config)
	if not self.ucidata then
		error("Unable to read UCI data: " .. self.config)
	else
		self.ucidata = self.ucidata[self.config]
	end
	Node.parse(self)
end

function Map.render(self)
	self.ucidata = self.uci:show(self.config)
	if not self.ucidata then
		error("Unable to read UCI data: " .. self.config)
	else
		self.ucidata = self.ucidata[self.config]
	end
	Node.render(self)	
end

function Map.section(self, class, ...)
	if instanceof(class, AbstractSection) then
		local obj  = class(...)
		obj.map    = self
		obj.config = self.config
		self:append(obj)
		return obj
	else
		error("class must be a descendent of AbstractSection")
	end
end

function Map.add(self, sectiontype)
	return self.uci:add(self.config, sectiontype)
end

function Map.set(self, section, option, value)
	return self.uci:set(self.config, section, option, value)
end

function Map.remove(self, section, option)
	return self.uci:del(self.config, section, option)
end

--[[
AbstractSection
]]--
AbstractSection = class(Node)

function AbstractSection.__init__(self, sectiontype, ...)
	Node.__init__(self, ...)
	self.sectiontype = sectiontype
end

function AbstractSection.option(self, class, ...)
	if instanceof(class, AbstractValue) then
		local obj  = class(...)
		obj.map    = self.map
		obj.config = self.config
		self:append(obj)
		return obj
	else
		error("class must be a descendent of AbstractValue")
	end	
end
	


--[[
NamedSection - A fixed configuration section defined by its name
]]--
NamedSection = class(AbstractSection)

function NamedSection.__init__(self, section, ...)
	AbstractSection.__init__(self, ...)
	self.template = "cbi/nsection"
	
	self.section = section
end

function NamedSection.option(self, ...)
	local obj = AbstractSection.option(self, ...)
	obj.section = self.section
	return obj
end


--[[
TypedSection - A (set of) configuration section(s) defined by the type
	addremove: 	Defines whether the user can add/remove sections of this type
	anonymous:  Allow creating anonymous sections
	valid: 		a list of names or a validation function for creating sections 
	scope:		a list of names or a validation function for editing sections
]]--
TypedSection = class(AbstractSection)

function TypedSection.__init__(self, ...)
	AbstractSection.__init__(self, ...)
	self.template  = "cbi/tsection"
	
	self.addremove   = true
	self.anonymous   = false
	self.valid       = nil
	self.scope		 = nil
end

function TypedSection.create(self, name)
	if name then	
		self.map:set(name, nil, self.sectiontype)
	else
		name = self.map:add(self.sectiontype)
	end
	
	for k,v in pairs(self.children) do
		if v.default then
			self.map:set(name, v.option, v.default)
		end
	end
end

function TypedSection.parse(self)
	if self.addremove then
		local crval = "cbi.cts." .. self.config .. "." .. self.sectiontype
		local name  = ffluci.http.formvalue(crval)
		if self.anonymous then
			if name then
				self:create()
			end
		else		
			if name then
				name = ffluci.util.validate(name, self.valid)
				if not name then
					self.err_invalid = true
				end		
				if name and name:len() > 0 then
					self:create(name)
				end
			end
		end
		
		
		crval = "cbi.rts." .. self.config
		name = ffluci.http.formvalue(crval)
		if type(name) == "table" then
			for k,v in pairs(name) do
				if ffluci.util.validate(k, self.valid) then
					self:remove(k)
				end
			end
		end		
	end
	
	for k, v in pairs(self:ucisections()) do
		for i, node in ipairs(self.children) do
			node.section = k
			node:parse()
		end 
	end
end

function TypedSection.remove(self, name)
	return self.map:remove(name)
end

function TypedSection.render_children(self, section)
	for k, node in ipairs(self.children) do
		node.section = section
		node:render()
	end
end

function TypedSection.ucisections(self)
	local sections = {}
	for k, v in pairs(self.map.ucidata) do
		if v[".type"] == self.sectiontype then
			if ffluci.util.validate(k, self.scope) then
				sections[k] = v
			end
		end
	end
	return sections	
end


--[[
AbstractValue - An abstract Value Type
	null:		Value can be empty
	valid:		A function returning the value if it is valid otherwise nil 
	depends:	A table of option => value pairs of which one must be true
	default:	The default value
	size:		The size of the input fields
]]--
AbstractValue = class(Node)

function AbstractValue.__init__(self, option, ...)
	Node.__init__(self, ...)
	self.option  = option
	
	self.valid   = nil
	self.depends = nil
	self.default = nil
	self.size    = nil
end

function AbstractValue.formvalue(self)
	local key = "cbid."..self.map.config.."."..self.section.."."..self.option
	return ffluci.http.formvalue(key)
end

function AbstractValue.parse(self)
	local fvalue = self:formvalue()
	if fvalue then
		fvalue = self:validate(fvalue)
		if not fvalue then
			self.err_invalid = true
		end
		if fvalue and not (fvalue == self:ucivalue()) then
			self:write(fvalue)
		end 
	end
end

function AbstractValue.ucivalue(self)
	return self.map.ucidata[self.section][self.option]
end

function AbstractValue.validate(self, val)
	return ffluci.util.validate(val, self.valid)
end

function AbstractValue.write(self, value)
	return self.map:set(self.section, self.option, value)
end




--[[
Value - A one-line value
	maxlength:	The maximum length
	isnumber:	The value must be a valid (floating point) number
	isinteger:  The value must be a valid integer
	ispositive: The value must be positive (and a number)
]]--
Value = class(AbstractValue)

function Value.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/value"
	
	self.maxlength  = nil
	self.isnumber   = false
	self.isinteger  = false
end

function Value.validate(self, val)
	if self.maxlength and tostring(val):len() > self.maxlength then
		val = nil
	end
	
	return ffluci.util.validate(val, self.valid, self.isnumber, self.isinteger)
end


--[[
ListValue - A one-line value predefined in a list
]]--
ListValue = class(AbstractValue)

function ListValue.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/lvalue"
	
	self.list = {}
end

function ListValue.add_value(self, key, val)
	val = val or key
	self.list[key] = val
end