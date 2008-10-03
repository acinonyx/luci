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
module("luci.controller.init", package.seeall)

function index()
	if not luci.fs.isfile("/etc/rc.common") then
		return
	end

	local page = entry({"admin", "system", "init"}, form("init/init"), translate("initmgr", "Init Scripts"))
	page.i18n = "initmgr"
	page.dependent = true
end
