--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

require("luci.fs")
require("luci.ip")


if arg[1] then
	mp = Map("olsrd", translate("olsrd_plugins", "OLSR - Plugins"))

	p = mp:section(TypedSection, "LoadPlugin")
	p:depends("library", arg[1])
	p.anonymous = true

	ign = p:option(Flag, "ignore", "Enable")
	ign.enabled  = "0"
	ign.disabled = "1"
	ign.rmempty  = false
	function ign.cfgvalue(self, section)
		return Flag.cfgvalue(self, section) or "0"
	end

	lib = p:option(DummyValue, "library", translate("library"))
	lib.default = arg[1]

	local function Range(x,y)
		local t = {}
		for i = x, y do t[#t+1] = i end
		return t
	end

	local function Cidr2IpMask(val)
		if val then
			for i = 1, #val do
				local cidr = luci.ip.IPv4(val[i]) or luci.ip.IPv6(val[i])
				if cidr then
					val[i] = cidr:network():string() .. " " .. cidr:mask():string()
				end
			end
			return val
		end
	end

	local function IpMask2Cidr(val)
		if val then
			for i = 1, #val do
				local ip, mask = val[i]:gmatch("([^%s+])%s+([^%s+])")()
				local cidr
				if ip and mask and ip:match(":") then
					cidr = luci.ip.IPv6(ip, mask)
				elseif ip and mask then
					cidr = luci.ip.IPv4(ip, mask)
				end

				if cidr then
					val[i] = cidr:string()
				end
			end
			return val
		end
	end


	local knownPlParams = {
		["olsrd_bmf.so.1.5.3"] = {
			{ Value, 		"BmfInterface",			"bmf0" },
			{ Value, 		"BmfInterfaceIp",		"10.10.10.234/24" },
			{ Flag,  		"DoLocalBroadcast",		"no" },
			{ Flag,  		"CapturePacketsOnOlsrInterfaces", "yes" },
			{ ListValue, 	"BmfMechanism",			{ "UnicastPromiscuous", "Broadcast" } },
			{ Value, 		"BroadcastRetransmitCount",	"2" },
			{ Value, 		"FanOutLimit",			"4" },
			{ DynamicList,	"NonOlsrIf",			"eth1" }
		},

		["olsrd_dyn_gw.so.0.4"] = {
			{ Value,		"Interval",				"40" },
			{ DynamicList,  "Ping",					"141.1.1.1" },
			{ DynamicList,	"HNA",					"192.168.80.0/24", IpMask2Cidr, Cidr2IpMask }
		},

		["olsrd_httpinfo.so.0.1"] = {
			{ Value,		"port",					"80" },
			{ DynamicList,	"Host",					"163.24.87.3" },
			{ DynamicList,	"Net",					"0.0.0.0/0", IpMask2Cidr, Cidr2IpMask }
		},

		["olsrd_nameservice.so.0.3"] = {
			{ DynamicList,	"name",					"my-name.mesh" },
			{ DynamicList,	"hosts",				"1.2.3.4 name-for-other-interface.mesh" },
			{ Value,		"suffix",				".olsr" },
			{ Value,		"hosts_file",			"/path/to/hosts_file" },
			{ Value,		"add_hosts",			"/path/to/file" },
			{ Value,		"dns_server",			"141.1.1.1" },
			{ Value,		"resolv_file",			"/path/to/resolv.conf" },
			{ Value,		"interval",				"120" },
			{ Value,		"timeout",				"240" },
			{ Value,		"lat",					"12.123" },
			{ Value,		"lon",					"12.123" },
			{ Value,		"latlon_file",			"/var/run/latlon.js" },
			{ Value,		"latlon_infile",		"/var/run/gps.txt" },
			{ Value,		"sighup_pid_file",		"/var/run/dnsmasq.pid" },
			{ Value,		"name_change_script",	"/usr/local/bin/announce_new_hosts.sh" },
			{ Value,		"services_change_script",	"/usr/local/bin/announce_new_services.sh" }
		},

		["olsrd_quagga.so.0.2.2"] = {
			{ StaticList,	"redistribute",			{
				"system", "kernel", "connect", "static", "rip", "ripng", "ospf",
				"ospf6", "isis", "bgp", "hsls"
			} },
			{ ListValue,	"ExportRoutes",			{ "only", "both" } },
			{ Flag,			"LocalPref",			"true" },
			{ Value,		"Distance",				Range(0,255) }
		},

		["olsrd_secure.so.0.5"] = {
			{ Value,		"Keyfile",				"/etc/private-olsr.key" }
		},

		["olsrd_txtinfo.so.0.1"] = {
			{ Value,		"accept",				"10.247.200.4" }
		},

		["olsrd_arprefresh.so.0.1"]		= {},
		["olsrd_dot_draw.so.0.3"]		= {},
		["olsrd_dyn_gw_plain.so.0.4"]	= {},
		["olsrd_pgraph.so.1.1"]			= {},
		["olsrd_tas.so.0.1"]			= {}
	}


	-- build plugin options with dependencies
	if knownPlParams[arg[1]] then
		for _, option in ipairs(knownPlParams[arg[1]]) do
			local otype, name, default, uci2cbi, cbi2uci = unpack(option)
			local values

			if type(default) == "table" then
				values  = default
				default = default[1]
			end

			if otype == Flag then
				local bool = p:option( Flag, name )
				if default == "yes" or default == "no" then
					bool.enabled  = "yes"
					bool.disabled = "no"
				elseif default == "on" or default == "off" then
					bool.enabled  = "on"
					bool.disabled = "off"
				elseif default == "1" or default == "0" then
					bool.enabled  = "1"
					bool.disabled = "0"
				else
					bool.enabled  = "true"
					bool.disabled = "false"
				end
				bool.optional = true
				bool.default = default
				bool:depends({ library = plugin })
			else
				local field = p:option( otype, name )
				if values then
					for _, value in ipairs(values) do
						field:value( value )
					end
				end
				if type(uci2cbi) == "function" then
					function field.cfgvalue(self, section)
						return uci2cbi(otype.cfgvalue(self, section))
					end
				end
				if type(cbi2uci) == "function" then
					function field.formvalue(self, section)
						return cbi2uci(otype.formvalue(self, section))
					end
				end
				field.optional = true
				field.default = default
				--field:depends({ library = arg[1] })
			end
		end
	end

	return mp

else

	mpi = Map("olsrd", "OLSR - Plugins")

	local plugins = {}
	mpi.uci:foreach("olsrd", "LoadPlugin",
		function(section)
			if section.library and not plugins[section.library] then
				plugins[section.library] = true
			end
		end
	)

	-- create a loadplugin section for each found plugin
	for k, v in pairs(luci.fs.dir("/usr/lib")) do
		if v:sub(1, 6) == "olsrd_" then
			if not plugins[v] then
				mpi.uci:section(
					"olsrd", "LoadPlugin", nil,
					{ library = v, ignore = 1 }
				)
			end
		end
	end

	t = mpi:section( TypedSection, "LoadPlugin", "Plugins" )
	t.anonymous = true
	t.template  = "cbi/tblsection"
	t.override_scheme = true
	function t.extedit(self, section)
		local lib = self.map:get(section, "library") or ""
		return luci.dispatcher.build_url("admin", "services", "olsrd", "plugins") .. "/" .. lib
	end

	ign = t:option( Flag, "ignore", "Enabled" )
	ign.enabled  = "0"
	ign.disabled = "1"
	ign.rmempty  = false
	function ign.cfgvalue(self, section)
		return Flag.cfgvalue(self, section) or "0"
	end

	t:option( DummyValue, "library", "Library" )

	return mpi
end
