--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--
module("luci.controller.ntpc", package.seeall)

function index()
	require("luci.i18n")
	luci.i18n.loadc("ntpc")
	if not luci.fs.access("/etc/config/ntpclient") then
		return
	end
	
	local page = entry({"admin", "system", "ntpc"}, cbi("ntpc/ntpc"), luci.i18n.translate("ntpc"), 50)
	page.i18n = "ntpc"
	page.dependent = true
	
	
	local page = entry({"mini", "system", "ntpc"}, cbi("ntpc/ntpcmini", {autoapply=true}), luci.i18n.translate("ntpc"), 50)
	page.i18n = "ntpc"
	page.dependent = true
end