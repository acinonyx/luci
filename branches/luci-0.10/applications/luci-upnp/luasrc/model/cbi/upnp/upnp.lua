--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008-2011 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

m = Map("upnpd", translate("Universal Plug & Play"),
	translate("UPnP allows clients in the local network to automatically configure the router."))

m:section(SimpleSection).template  = "upnp_status"

s = m:section(NamedSection, "config", "upnpd", translate("MiniUPnP settings"))
s.addremove = false
s:tab("general",  translate("General Settings"))
s:tab("advanced", translate("Advanced Settings"))

e = s:taboption("general", Flag, "_init", translate("Start UPnP and NAT-PMP service"))
e.rmempty  = false

function e.cfgvalue(self, section)
	return luci.sys.init.enabled("miniupnpd") and self.enabled or self.disabled
end

function e.write(self, section, value)
	if value == "1" then
		luci.sys.call("/etc/init.d/miniupnpd enable >/dev/null")
		luci.sys.call("/etc/init.d/miniupnpd start >/dev/null")
	else
		luci.sys.call("/etc/init.d/miniupnpd stop >/dev/null")
		luci.sys.call("/etc/init.d/miniupnpd disable >/dev/null")
	end
end

s:taboption("general", Flag, "enable_upnp", translate("Enable UPnP functionality")).default = "1"
s:taboption("general", Flag, "enable_natpmp", translate("Enable NAT-PMP functionality")).default = "1"

s:taboption("general", Flag, "secure_mode", translate("Enable secure mode"),
	translate("Allow adding forwards only to requesting ip addresses")).default = "1"

s:taboption("general", Flag, "log_output", translate("Enable additional logging"),
	translate("Puts extra debugging information into the system log")).default = "1"

s:taboption("general", Value, "download", translate("Downlink"), 
	translate("Value in KByte/s, informational only")).rmempty = true

s:taboption("general", Value, "upload", translate("Uplink"),
	translate("Value in KByte/s, informational only")).rmempty = true

port = s:taboption("general", Value, "port", translate("Port"))
port.datatype = "port"
port.default  = 5000


s:taboption("advanced", Flag, "system_uptime", translate("Report system instead of daemon uptime")).default = "1"

s:taboption("advanced", Value, "uuid", translate("Device UUID"))
s:taboption("advanced", Value, "serial_number", translate("Announced serial number"))
s:taboption("advanced", Value, "model_number", translate("Announced model number"))

ni = s:taboption("advanced", Value, "notify_interval", translate("Notify interval"))
ni.datatype    = "uinteger"
ni.placeholder = 30

ct = s:taboption("advanced", Value, "clean_ruleset_threshold", translate("Clean rules threshold"))
ct.datatype    = "uinteger"
ct.placeholder = 20

ci = s:taboption("advanced", Value, "clean_ruleset_interval", translate("Clean rules interval"))
ci.datatype    = "uinteger"
ci.placeholder = 600

pu = s:taboption("advanced", Value, "presentation_url", translate("Presentation URL"))
pu.placeholder = "http://192.168.1.1/"

lf = s:taboption("advanced", Value, "upnp_lease_file", translate("UPnP lease file"))
lf.placeholder = "/var/log/upnp.leases"


s2 = m:section(TypedSection, "perm_rule", translate("MiniUPnP ACLs"),
	translate("ACLs specify which external ports may be redirected to which internal addresses and ports"))

s2.template  = "cbi/tblsection"
s2.sortable  = true
s2.anonymous = true
s2.addremove = true

s2:option(Value, "comment", translate("Comment"))

ep = s2:option(Value, "ext_ports", translate("External ports"))
ep.datatype    = "portrange"
ep.placeholder = "0-65535"

ia = s2:option(Value, "int_addr", translate("Internal addresses"))
ia.datatype    = "ip4addr"
ia.placeholder = "0.0.0.0/0"

ip = s2:option(Value, "int_ports", translate("Internal ports"))
ip.datatype    = "portrange"
ip.placeholder = "0-65535"

ac = s2:option(ListValue, "action", translate("Action"))
ac:value("allow")
ac:value("deny")

return m
