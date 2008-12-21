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

local uci = require "luci.model.uci".cursor()

-------------------- View --------------------
f = SimpleForm("siitwizward", "4over6-Assistent",
 "Dieser Assistent unterstüzt bei der Einrichtung von IPv4-over-IPv6 Translation.")

mode = f:field(ListValue, "mode", "Betriebsmodus")
mode:value("gateway", "Gateway")
mode:value("client", "Client")

dev = f:field(ListValue, "device", "WLAN-Gerät")
uci:foreach("wireless", "wifi-device",
	function(section)
		dev:value(section[".name"])
	end)

lanip = f:field(Value, "ipaddr", "LAN IP Adresse")
lanip.value = "127.23.1.1"

lanmsk = f:field(Value, "netmask", "LAN Netzmaske")
lanmsk.value = "255.255.0.0"


-------------------- Control --------------------
LL_PREFIX = luci.ip.IPv6("fe80::/64")

--
-- find link-local address
--
function find_ll()
	for _, r in ipairs(luci.sys.net.routes6()) do
		if LL_PREFIX:contains(r.dest) and r.dest:higher(LL_PREFIX) then
			return r.dest:sub(LL_PREFIX)
		end
	end
	return luci.ip.IPv6("::")
end



function f.handle(self, state, data)
	if state == FORM_VALID then
		luci.http.redirect(luci.dispatcher.build_url("admin", "uci", "changes"))
		return false
	elseif state == FORM_INVALID then
		self.errmessage = "Ungültige Eingabe: Bitte die Formularfelder auf Fehler prüfen."
	end
	return true
end

function mode.write(self, section, value)

	--
	-- Configure wifi device
	--
	local wifi_device  = dev:formvalue(section)
	local wifi_essid   = uci:get("siit", "wifi", "essid")   or "6mesh.freifunk.net"
	local wifi_bssid   = uci:get("siit", "wifi", "bssid")   or "02:ca:ff:ee:ba:be"
	local wifi_channel = uci:get("siit", "wifi", "channel") or "1"

	-- nuke old device definition
	uci:delete_all("wireless", "wifi-iface",
		function(s) return s.device == wifi_device end )

	uci:delete_all("network", "interface",
		function(s) return s['.name'] == wifi_device end )

	-- create wifi device definition
	uci:tset("wireless", wifi_device, {
		disabled  = 0,
		channel   = wifi_channel,
--		txantenna = 1,
--		rxantenna = 1,
--		diversity = 0
	})

	uci:section("wireless", "wifi-iface", nil, {
		encryption = "none",
		mode       = "adhoc",
		network    = wifi_device,
		device     = wifi_device,
		ssid       = wifi_essid,
		bssid      = wifi_bssid,
	})


	--
	-- Determine defaults
	--
	local ula_prefix  = uci:get("siit", "ipv6", "ula_prefix")  or "fd00::"
	local ula_global  = uci:get("siit", "ipv6", "ula_global")  or "00ca:ffee:babe::"		-- = Freifunk
	local ula_subnet  = uci:get("siit", "ipv6", "ula_subnet")  or "0000:0000:0000:4223::"	-- = Berlin
	local siit_prefix = uci:get("siit", "ipv6", "siit_prefix") or "::ffff:0000:0000"

	-- Find wifi interface
	local device = dev:formvalue(section)

	--
	-- Generate ULA
	--
	local ula = luci.ip.IPv6("::/64")

	for _, prefix in ipairs({ ula_prefix, ula_global, ula_subnet }) do
		ula = ula:add(luci.ip.IPv6(prefix))
	end

	ula = ula:add(find_ll())


	--
	-- Gateway mode
	--
	--	* wan port is dhcp, lan port is 172.23.1.1/24
	--	* siit0 gets a dummy address: 169.254.42.42
	--	* wl0 gets an ipv6 address, in this case the fdca:ffee:babe::1:1/64
	--	* we do a ::ffff:ffff:0/96 route into siit0, so everything from 6mesh goes into translation.
	--	* an HNA6 of ::ffff:ffff:0:0/96 announces the mapped 0.0.0.0/0 ipv4 space.
	--	* MTU on WAN, LAN down to 1400, ipv6 headers are slighly larger.

	if value == "gateway" then

		uci:set("network", "wan", "mtu", 1400)

		-- use full siit subnet
		siit_route = luci.ip.IPv6(siit_prefix .. "/96")

	--
	-- Client mode
	--
	--	* 172.23.2.1/24 on its lan, fdca:ffee:babe::1:2 on wl0 and the usual dummy address on siit0.
	--	* we do a ::ffff:ffff:172.13.2.0/120 to siit0, because in this case, only traffic directed to clients needs to go into translation.
	--	* same route as HNA6 announcement to catch the traffic out of the mesh.
	--	* Also, MTU on LAN reduced to 1400.

	else
		-- lan interface
		local lan_net = luci.ip.IPv4(
			lanip:formvalue(section) or "192.168.1.1",
			lanmsk:formvalue(section) or "255.255.255.0"
		)

		uci:tset("network", "lan", {
			mtu     = 1400,
			ipaddr  = lan_net:host():string(),
			netmask = lan_net:mask():string()
		})

		-- derive siit subnet from lan config
		siit_route = luci.ip.IPv6(
			siit_prefix .. "/" .. (96 + lan_net:prefix())
		):add(lan_net[2])

	end

	-- siit0 interface
	uci:delete_all("network", "interface",
		function(s) return ( s.ifname == "siit0" ) end)

	uci:section("network", "interface", "siit0", {
		ifname  = "siit0",
		proto   = "static",
		ipaddr  = "169.254.42.42",
		netmask = "255.255.255.0"
	})

	-- siit0 route
	uci:delete_all("network", "route6",
		function(s) return siit_route:contains(luci.ip.IPv6(s.target)) end)

	uci:section("network", "route6", nil, {
		interface = "siit0",
		target    = siit_route:string()
	})

	-- create wifi network interface
	uci:section("network", "interface", wifi_device, {
		proto   = "static",
		mtu     = 1400,
		ip6addr = ula:string()
	})

	-- nuke old olsrd interfaces
	uci:delete_all("olsrd", "Interface",
		function(s) return s.interface == wifi_device end)

	-- configure olsrd interface
	uci:foreach("olsrd", "olsrd",
		function(s) uci:set("olsrd", s['.name'], "IpVersion", 6) end)

	uci:section("olsrd", "Interface", nil, {
		ignore      = 0,
		interface   = wifi_device,
		Ip6AddrType = "global"
	})

	-- hna6
	uci:delete_all("olsrd", "Hna6",
		function(s)
			if s.netaddr and s.prefix then
				return siit_route:contains(luci.ip.IPv6(s.netaddr.."/"..s.prefix))
			end
		end)

	uci:section("olsrd", "Hna6", nil, {
		netaddr = siit_route:host():string(),
		prefix  = siit_route:prefix()
	})

	uci:save("wireless")
	uci:save("network")
	uci:save("olsrd")
end

return f
