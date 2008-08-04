fw_portfw = "Port forwarding"
fw_forwarding = "Forwarding"
fw_fw = "Firewall"
fw_zone = "Zone"
fw_zones = "Zones"
fw_custfwd = "Custom redirect"
fw_rules = "Custom Rules"
fw_rules1 = "Here you can create custom firewall rules to control your network traffic."
fw_fw1 = "The firewall creates zones over your network interfaces to control network traffic flow."
firewall_rule_src = "Input Zone"
firewall_rule_dest = "Output Zone"
firewall_rule_srcip = "Source address"
firewall_rule_destip = "Destination address"
firewall_rule_srcmac = "Source MAC-Address"
firewall_rule_srcport = "Source port"
firewall_rule_destport = "Destination port"
firewall_rule_target = "Action"
fw_accept = "accept"
fw_reject = "reject"
fw_drop = "drop"

fw_portfw1 = [[Port forwarding allows to provide network services 
in the internal network to an external network.]]
firewall_redirect_src_desc = "External Zone"
firewall_redirect_srcdport = "External port"
firewall_redirect_srcdport_desc = "port or range as first:last"
firewall_redirect_destip = "Internal address"
firewall_redirect_destip_desc = "IP-Address"
firewall_redirect_destport = "Internal port (optional)"
firewall_redirect_destport_desc = "port or range as first:last"
firewall_redirect_srcip = firewall_rule_srcip
firewall_redirect_srcmac = firewall_rule_srcmac
firewall_redirect_srcport = firewall_rule_srcport

fw_forwarding1 = [[Here you can specify which network traffic is allowed to flow between network zones.
Only new connections will be matched. Packets belonging to already open connections are automatically allowed
to pass the firewall.]]
firewall_forwarding_src = "Input"
firewall_forwarding_src_desc = firewall_rule_src
firewall_forwarding_dest = "Output" 
firewall_forwarding_dest_desc = firewall_rule_dest

firewall_defaults = "Defaults"
firewall_defaults_desc = "These are the default settings that are used if no other rules match."
firewall_defaults_synflood = "SYN-flood protection"
firewall_defaults_input = "Incoming Traffic"
firewall_defaults_output = "Outgoing Traffic"
firewall_defaults_forward = "Forwarded Traffic"

firewall_zone_desc = [[Zones part the network interfaces into certain isolated areas to separate network traffic.
One or more networks can belong to a zone. The MASQ-flag enables NAT masquerading for all outgoing traffic on this zone.]]
firewall_zone_input = "Incoming Traffic"
firewall_zone_input_desc = "Default Policy"
firewall_zone_output = "Outgoing Traffic"
firewall_zone_output_desc = "Default Policy"
firewall_zone_forward = "Forwarded Traffic"
firewall_zone_forward_desc = "Default Policy"
firewall_zone_masq = "MASQ"
firewall_zone_network = "Networks"
firewall_zone_network_desc = "contained networks"