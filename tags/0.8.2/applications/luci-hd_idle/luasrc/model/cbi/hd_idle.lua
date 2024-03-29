--[[

LuCI hd-idle
(c) 2008 Yanira <forum-2008@email.de>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

$Id$

]]--

require("luci.fs")

m = Map("hd-idle", translate("hd_idle"), translate("hd_idle_desc"))

s = m:section(TypedSection, "hd-idle", translate("settings"))
s.anonymous = true

s:option(Flag, "enabled", translate("enable", "Enable"))

disk = s:option(Value, "disk", translate("disk"))
disk.rmempty = true
for _, dev in ipairs(luci.fs.glob("/dev/[sh]d[a-z]")) do
	disk:value(luci.fs.basename(dev))
end

s:option(Value, "idle_time_interval", translate("idle_time_interval")).default = 10
s.rmempty = true
unit = s:option(ListValue, "idle_time_unit", translate("idle_time_unit"))
unit.default = "minutes"
unit:value("minutes", "min")
unit:value("hours", "h")
unit.rmempty = true

s:option(Flag, "enable_debug", translate("enable_debug"))

return m
