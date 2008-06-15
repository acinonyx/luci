--[[
LuCI - SGI-Module for WSAPI

Description:
Server Gateway Interface for WSAPI

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
module("luci.sgi.wsapi", package.seeall)
require("luci.http")
require("luci.dispatcher")
require("luci.http.protocol")

function run(wsapi_env)
	local r = luci.http.Request(wsapi_env, wsapi_env.input, wsapi_env.error)
	r.postds = function() return wsapi.request.parse_post_data(wsapi_env) end
	r.getds  = function() return wsapi.request.parse_qs(wsapi_env.QUERY_STRING) end
		
	local res, id, data1, data2 = true, 0, nil, nil
	local headers = {}
	local status = 200
	
	local x = coroutine.create(luci.dispatcher.httpdispatch)
	while id < 3 do
		res, id, data1, data2 = coroutine.resume(x, r)
		
		if not res then
			status = 500
			headers["Content-Type"] = "text/plain"
			local err = {id}
			return status, headers, function() local x = table.remove(err) return x end
		end
		
		if id == 1 then
			status = data1
		elseif id == 2 then
			headers[data1] = data2
		end
	end
	
	local function iter()
		local res, id, data1, data2 = coroutine.resume(x)
		if not res or id == 5 then
			return nil
		else
			return data1
		end
	end
	
	return status, headers, iter
end