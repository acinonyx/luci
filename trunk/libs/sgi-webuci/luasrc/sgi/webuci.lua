--[[
LuCI - SGI-Module for Webuci

Description:
Server Gateway Interface for Webuci

FileId:
$Id: webuci.lua 2027 2008-05-07 21:16:35Z Cyrus $

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
module("luci.sgi.webuci", package.seeall)
require("luci.http")
require("luci.util")
require("luci.dispatcher")

function run(env, vars)
	local r = luci.http.Request()
	r.env = env
	r.request = vars
	
	local x = coroutine.create(luci.dispatcher.httpdispatch)
	
	while coroutine.status(x) ~= "dead" do
		local res, id, data1, data2 = coroutine.resume(x, r)

		if not res then
			print(env.SERVER_PROTOCOL .. " 500 Internal Server Error")
			print("Content-Type: text/plain\n")
			print(id)
			break;
		end
		
		if id == 1 then
			io.write(env.SERVER_PROTOCOL .. " " .. tostring(data1) .. " " .. data2 .. "\n")
		elseif id == 2 then
			io.write(data1 .. ": " .. data2 .. "\n")
		elseif id == 3 then
			io.write("\n")
		elseif id == 4 then
			io.write(data1)
		end
		
	end
end
