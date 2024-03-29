--[[

Luci configuration model for statistics - collectd dns plugin configuration
(c) 2008 Freifunk Leipzig / Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

$Id$

]]--

require("luci.sys")


m = Map("luci_statistics")

-- collectd_dns config section
s = m:section( NamedSection, "collectd_dns", "luci_statistics" )

-- collectd_dns.enable
enable = s:option( Flag, "enable" )
enable.default = 0

-- collectd_dns.interfaces (Interface)
interfaces = s:option( ListValue, "Interfaces" )
interfaces:depends( "enable", 1 )
interfaces:value("any")
for k, v in pairs(luci.sys.net.devices()) do
	interfaces:value(v)
end

-- collectd_dns.ignoresources (IgnoreSource)
ignoresources = s:option( Value, "IgnoreSources" )
ignoresources.default = "127.0.0.1"
ignoresources:depends( "enable", 1 )

return m
