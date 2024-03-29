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
require("luci.tools.webadmin")
arg[1] = arg[1] or ""
m = Map("network", translate("interfaces"), translate("a_n_ifaces1"))

s = m:section(NamedSection, arg[1], "interface")
s.addremove = true

back = s:option(DummyValue, "_overview", translate("overview"))
back.value = ""
back.titleref = luci.dispatcher.build_url("admin", "network", "network")

p = s:option(ListValue, "proto", translate("protocol"))
p:value("static", translate("static"))
p:value("dhcp", "DHCP")
p:value("pppoe", "PPPoE")
p:value("ppp", "PPP")
p:value("3g", "UMTS/3G")
p:value("pptp", "PPTP")
p.default = "static"

br = s:option(Flag, "type", translate("a_n_i_bridge"), translate("a_n_i_bridge1"))
br.enabled = "bridge"
br.rmempty = true

ifname = s:option(Value, "ifname", translate("interface"))
ifname.rmempty = true
for i,d in ipairs(luci.sys.net.devices()) do
	if d ~= "lo" then
		ifname:value(d)
	end
end

local zones = luci.tools.webadmin.network_get_zones(arg[1])
if zones then
	if #zones == 0 then
		m:chain("firewall")

		fwzone = s:option(Value, "_fwzone",
			translate("network_interface_fwzone"),
			translate("network_interface_fwzone_desc"))
		fwzone.rmempty = true
		fwzone:value("", "- " .. translate("none") .. " -")
		fwzone:value(arg[1])
		m.uci:load("firewall")
		m.uci:foreach("firewall", "zone",
			function (section)
				fwzone:value(section.name)
			end
		)

		function fwzone.write(self, section, value)
			local zone = luci.tools.webadmin.firewall_find_zone(value)
			local stat

			if not zone then
				stat = m.uci:section("firewall", "zone", nil, {
					name = value,
					network = section
				})
			else
				local net = m.uci:get("firewall", zone, "network")
				net = (net or value) .. " " .. section
				stat = m.uci:set("firewall", zone, "network", net)
			end

			if stat then
				self.render = function() end
			end
		end
	else
		fwzone = s:option(DummyValue, "_fwzone", translate("zone"))
		fwzone.value = table.concat(zones, ", ")
	end
	fwzone.titleref = luci.dispatcher.build_url("admin", "network", "firewall", "zones")
	m.uci:unload("firewall")
end

ipaddr = s:option(Value, "ipaddr", translate("ipaddress"))
ipaddr.rmempty = true
ipaddr:depends("proto", "static")

nm = s:option(Value, "netmask", translate("netmask"))
nm.rmempty = true
nm:depends("proto", "static")
nm:value("255.255.255.0")
nm:value("255.255.0.0")
nm:value("255.0.0.0")

gw = s:option(Value, "gateway", translate("gateway"))
gw:depends("proto", "static")
gw.rmempty = true

bcast = s:option(Value, "bcast", translate("broadcast"))
bcast:depends("proto", "static")
bcast.optional = true

ip6addr = s:option(Value, "ip6addr", translate("ip6address"), translate("cidr6"))
ip6addr.optional = true
ip6addr:depends("proto", "static")

ip6gw = s:option(Value, "ip6gw", translate("gateway6"))
ip6gw:depends("proto", "static")
ip6gw.optional = true

dns = s:option(Value, "dns", translate("dnsserver"))
dns:depends("proto", "static")
dns.optional = true

mtu = s:option(Value, "mtu", "MTU")
mtu.optional = true
mtu.isinteger = true

mac = s:option(Value, "macaddr", translate("macaddress"))
mac.optional = true


srv = s:option(Value, "server", translate("network_interface_server"))
srv:depends("proto", "pptp")
srv.rmempty = true

service = s:option(ListValue, "service", translate("network_interface_service"))
service:value("umts", "UMTS/GPRS")
service:value("cdma", "CDMA")
service:value("evdo", "EV-DO")
service:depends("proto", "3g")

apn = s:option(Value, "apn", translate("network_interface_apn"))
apn:depends("proto", "3g")

pincode = s:option(Value, "pincode",
 translate("network_interface_pincode"),
 translate("network_interface_pincode_desc")
)
pincode:depends("proto", "3g")

user = s:option(Value, "username", translate("username"))
user.rmempty = true
user:depends("proto", "pptp")
user:depends("proto", "pppoe")
user:depends("proto", "ppp")
user:depends("proto", "3g")

pass = s:option(Value, "password", translate("password"))
pass.rmempty = true
pass:depends("proto", "pptp")
pass:depends("proto", "pppoe")
pass:depends("proto", "ppp")
pass:depends("proto", "3g")

ka = s:option(Value, "keepalive",
 translate("network_interface_keepalive"),
 translate("network_interface_keepalive_desc")
)
ka.optional = true
ka:depends("proto", "pptp")
ka:depends("proto", "pppoe")
ka:depends("proto", "ppp")
ka:depends("proto", "3g")

demand = s:option(Value, "demand",
 translate("network_interface_demand"),
 translate("network_interface_demand_desc")
)
demand.optional = true
demand:depends("proto", "pptp")
demand:depends("proto", "pppoe")
demand:depends("proto", "ppp")
demand:depends("proto", "3g")

device = s:option(Value, "device",
 translate("network_interface_device"),
 translate("network_interface_device_desc")
)
device:depends("proto", "ppp")
device:depends("proto", "3g")

defaultroute = s:option(Flag, "defaultroute",
 translate("network_interface_defaultroute"),
 translate("network_interface_defaultroute_desc")
)
defaultroute:depends("proto", "ppp")
defaultroute:depends("proto", "3g")

peerdns = s:option(Flag, "peerdns",
 translate("network_interface_peerdns"),
 translate("network_interface_peerdns_desc")
)
peerdns:depends("proto", "ppp")

ipv6 = s:option(Flag, "ipv6", translate("network_interface_ipv6") )
ipv6:depends("proto", "ppp")
--ipv6:depends("proto", "3g")

connect = s:option(Value, "connect",
 translate("network_interface_connect"),
 translate("network_interface_connect_desc")
)
connect.optional = true
connect:depends("proto", "ppp")
connect:depends("proto", "3g")

disconnect = s:option(Value, "disconnect",
 translate("network_interface_disconnect"),
 translate("network_interface_disconnect_desc")
)
disconnect.optional = true
disconnect:depends("proto", "ppp")
disconnect:depends("proto", "3g")

pppd_options = s:option(Value, "pppd_options",
 translate("network_interface_pppd_options"),
 translate("network_interface_pppd_options_desc")
)
pppd_options.optional = true
pppd_options:depends("proto", "ppp")
pppd_options:depends("proto", "3g")

maxwait = s:option(Value, "maxwait",
 translate("network_interface_maxwait"),
 translate("network_interface_maxwait_desc")
)
maxwait.optional = true
maxwait:depends("proto", "3g")


s2 = m:section(TypedSection, "alias", translate("aliases"))
s2.addremove = true

s2:depends("interface", arg[1])
s2.defaults.interface = arg[1]


s2.defaults.proto = "static"

ipaddr = s2:option(Value, "ipaddr", translate("ipaddress"))
ipaddr.rmempty = true

nm = s2:option(Value, "netmask", translate("netmask"))
nm.rmempty = true
nm:value("255.255.255.0")
nm:value("255.255.0.0")
nm:value("255.0.0.0")

gw = s2:option(Value, "gateway", translate("gateway"))
gw.rmempty = true

bcast = s2:option(Value, "bcast", translate("broadcast"))
bcast.optional = true

ip6addr = s2:option(Value, "ip6addr", translate("ip6address"), translate("cidr6"))
ip6addr.optional = true

ip6gw = s2:option(Value, "ip6gw", translate("gateway6"))
ip6gw.optional = true

dns = s2:option(Value, "dns", translate("dnsserver"))
dns.optional = true

return m
