--[[

Luci i18n translation file for the statistics application
(c) 2008 Freifunk Leipzig / Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

$Id$

]]--


--
-- general translations
--

stat_statistics	    = "Statistics"
stat_systemplugins  = "System plugins"
stat_networkplugins = "Network plugins"
stat_outputplugins  = "Output plugins"
stat_showtimespan   = "Display timespan &raquo;"
stat_graphs         = "Graphs"


--
-- collectd plugin translations
--

stat_collectd  = "Collectd"
stat_cpu       = "Processor"
stat_ping      = "Ping"
stat_iptables  = "Firewall"
stat_netlink   = "Netlink"
stat_processes = "Processes"
stat_wireless  = "Wireless"
stat_tcpconns  = "TCP Connections"
stat_interface = "Interfaces"
stat_df        = "Disk Space Usage"
stat_irq       = "Interrupts"
stat_disk      = "Disk Usage"
stat_exec      = "Exec"
stat_rrdtool   = "RRDTool"
stat_network   = "Network"
stat_csv       = "CSV Output"


--
-- diagram translations
--

stat_dg_title_wireless__signal_noise = "%H: Wireless - Signal Noise Ratio"
stat_dg_label_wireless__signal_noise = "dBm"
stat_ds_signal_noise = "Noise Level"
stat_ds_signal_power = "Signal Strength"

stat_dg_title_wireless__signal_quality = "%H: Wireless - Signal Quality"
stat_dg_label_wireless__signal_quality = "n"
stat_ds_signal_quality = "Signal Quality"

stat_dg_title_ping = "%H: ICMP Roundtrip Times"
stat_dg_label_ping = "ms"
stat_ds_ping = "%di"

stat_dg_title_iptables__ipt_packets = "%H: Firewall - Processed Packets"
stat_dg_label_iptables__ipt_packets = "Packets/s"
stat_ds_ipt_packets = 'Chain "%di"'

stat_dg_title_netlink__if_octets = "%H: Netlink - Transfer on %pi"
stat_dg_label_netlink__if_octets = "Bytes/s"
stat_ds_if_octets = "Bytes (%ds)"

stat_dg_title_netlink__if_packets = "%H: Netlink - Packets on %pi"
stat_dg_label_netlink__if_packets = "Packets/s"
stat_ds_if_packets = "Processed (%ds)"
stat_ds_if_dropped = "Dropped   (%ds)"
stat_ds_if_errors  = "Errors    (%ds)"

stat_dg_title_netlink__if_multicast = "%H: Netlink - Multicast on %pi"
stat_dg_label_netlink__if_multicast = "Packets/s"
stat_ds_if_multicast = "Packets"

stat_dg_title_netlink__if_collisions = "%H: Netlink - Collisions on %pi"
stat_dg_label_netlink__if_collisions = "Collisions/s"
stat_ds_if_collisions = "Collisions"

stat_dg_title_netlink__if_tx_errors = "%H: Netlink - Errors on %pi"
stat_dg_label_netlink__if_tx_errors = "Errors/s"
stat_ds_if_tx_errors = "%di"
stat_ds_if_rx_errors = "%di"

stat_dg_title_processes = "%H: Processes"
stat_dg_label_processes = "Processes/s"
stat_ds_ps_state = "%di"

stat_dg_title_processes__ps_cputime = "%H: Process %pi - used cpu time"
stat_dg_label_processes__ps_cputime = "Jiffies"
stat_ds_ps_cputime__syst = "system"
stat_ds_ps_cputime__user = "user"

stat_dg_title_processes__ps_count = "%H: Process %pi - threads and processes"
stat_dg_label_processes__ps_count = "Count"
stat_ds_ps_count = "%ds"

stat_dg_title_processes__ps_pagefaults = "%H: Process %pi - page faults"
stat_dg_label_processes__ps_pagefaults = "Pagefaults"
stat_ds_ps_pagefaults = "page faults"

stat_dg_title_processes__ps_rss = "%H: Process %pi - virtual memory size"
stat_dg_label_processes__ps_rss = "Bytes"
stat_ds_ps_rss = "virtual memory"

stat_dg_title_cpu = "%H: Usage on Processor #%pi"
stat_dg_label_cpu = "%"
stat_ds_cpu       = "%di"

stat_dg_title_interface__if_octets = "%H: Transfer on %di"
stat_dg_label_interface__if_octets = "Bytes/s"

stat_dg_title_interface__if_packets = "%H: Packets on %di"
stat_dg_label_interface__if_packets = "Packets/s"

stat_dg_title_tcpconns  = "%H: TCP-Connections to Port %pi"
stat_dg_label_tcpconns  = "Connections/s"
stat_ds_tcp_connections = "%di"

stat_dg_title_df	= "%H: Disk Space Usage on %di"
stat_dg_label_df	= "Bytes"
stat_ds_df__free	= "%ds"
stat_ds_df__used	= "%ds"

stat_dg_title_irq	= "%H: Interrupts"
stat_dg_label_irq	= "Issues/s"
stat_ds_irq		= "IRQ %di"


--
-- CBI translations
--

lucistatistics			= "Statistics"

-- general config
lucistatistics_collectd		= "Collectd Settings"
lucistatistics_collectd_desc	= [[
	Collectd is a small daeomon for collecting data from various sources through different plugins.
	On this page you can change general settings for the collectd daemon.
]]

lucistatistics_collectd_hostname      = "Hostname"
lucistatistics_collectd_basedir       = "Base Directory"
lucistatistics_collectd_include       = "Directory for sub-configurations"
lucistatistics_collectd_plugindir     = "Directory for collectd plugins"
lucistatistics_collectd_pidfile       = "Used PID file"
lucistatistics_collectd_typesdb       = "Datasets definition file"
lucistatistics_collectd_interval      = "Data collection interval"
lucistatistics_collectd_interval_desc = "Seconds"
lucistatistics_collectd_readthreads   = "Number of threads for data collection"
lucistatistics_collectd_fqdnlookup    = "Try to lookup fully qualified hostname"

-- cpu plugin
lucistatistics_collectdcpu            = "CPU Plugin Configuration"
lucistatistics_collectdcpu_desc       = "The cpu plugin collects basic statistics about the processor usage."
lucistatistics_collectdcpu_enable     = "Enable this plugin"

-- csv plugin
lucistatistics_collectdcsv            = "CSV Plugin Configuration"
lucistatistics_collectdcsv_desc       = "The csv plugin stores collected data in csv file format for further processing by external programs."
lucistatistics_collectdcsv_enable     = "Enable this plugin"
lucistatistics_collectdcsv_datadir    = "Storage directory for the csv files"
lucistatistics_collectdcsv_storerates = "Store data values as rates instead of absolute values"

-- df plugin
lucistatistics_collectddf                  = "DF Plugin Configuration"
lucistatistics_collectddf_desc             = "The df plugin collects statistics about the disk space usage on different devices, mount points or filesystem types."
lucistatistics_collectddf_enable           = "Enable this plugin"
lucistatistics_collectddf_devices          = "Monitor devices"
lucistatistics_collectddf_devices_desc     = "multiple separated by space"
lucistatistics_collectddf_mountpoints      = "Monitor mount points"
lucistatistics_collectddf_mountpoints_desc = "multiple separated by space"
lucistatistics_collectddf_fstypes          = "Monitor filesystem types"
lucistatistics_collectddf_fstypes_desc     = "multiple separated by space"
lucistatistics_collectddf_ignoreselected   = "Monitor all except selected ones"

-- disk plugin
lucistatistics_collectddisk                = "Disk Plugin Configuration"
lucistatistics_collectddisk_desc           = "The disk plugin collects detailled usage statistics for selected partitions or whole disks."
lucistatistics_collectddisk_enable         = "Enable this plugin"
lucistatistics_collectddisk_disks          = "Monitor disks and partitions"
lucistatistics_collectddisk_disks_desc     = "multiple separated by space"
lucistatistics_collectddisk_ignoreselected = "Monitor all except selected ones"

-- dns plugin
lucistatistics_collectddns                    = "DNS Plugin Configuration"
lucistatistics_collectddns_desc               = "The dns plugin collects detailled statistics about dns related traffic on selected interfaces."
lucistatistics_collectddns_enable             = "Enable this plugin"
lucistatistics_collectddns_interfaces         = "Monitor interfaces"
lucistatistics_collectddns_interfaces_desc    = "multiple separated by space"
lucistatistics_collectddns_ignoresources      = "Ignore source addresses"
lucistatistics_collectddns_ignoresources_desc = "multiple separated by space"

-- email plugin
lucistatistics_collectdemail                    = "E-Mail Plugin Configuration"
lucistatistics_collectdemail_desc               = [[
	The email plugin creates a unix socket which can be used to transmit
	email-statistics to a running collectd daemon. This plugin is primarily
	intended to be used in conjunction with Mail::SpamAssasin::Plugin::Collectd
	but can be used in other ways as well.
]]

lucistatistics_collectdemail_enable           = "Enable this plugin"
lucistatistics_collectdemail_socketfile       = "Filepath of the unix socket"
lucistatistics_collectdemail_socketgroup      = "Group ownership of the unix socket"
lucistatistics_collectdemail_socketgroup_desc = "group name"
lucistatistics_collectdemail_socketperms      = "File permissions of the unix socket"
lucistatistics_collectdemail_socketperms_desc = "octal"
lucistatistics_collectdemail_maxconns         = "Maximum allowed connections"

-- exec plugin
lucistatistics_collectdexec                = "Exec Plugin Configuration"
lucistatistics_collectdexec_desc           = [[
	The exec plugin starts external commands to read values from or
	to notify external processes when certain threshold values have
	been reached.
]]

lucistatistics_collectdexec_enable         = "Enable this plugin"
lucistatistics_collectdexecinput           = "Add command for reading values"
lucistatistics_collectdexecinput_desc      = [[
	Here you can define external commands which will be started by collectd in order
	to read certain values. The values will be read from stdout.
]]

lucistatistics_collectdexecinput_cmdline   = "Commandline"
lucistatistics_collectdexecinput_cmduser   = "Run as user"
lucistatistics_collectdexecinput_cmdgroup  = "Run as group"
lucistatistics_collectdexecnotify          = "Add notification command"
lucistatistics_collectdexecnotify_desc     = [[
	Here you can define external commands which will be started by collectd 
	when certain threshold values have been reached. The values leading to
	invokation will be feeded to the the called programs stdin.
]]

lucistatistics_collectdexecnotify_cmdline  = "Commandline"
lucistatistics_collectdexecnotify_cmduser  = "Run as user"
lucistatistics_collectdexecnotify_cmdgroup = "Run as group"

-- interface plugin
lucistatistics_collectdinterface                 = "Interface Plugin Configuration"
lucistatistics_collectdinterface_desc            = "The interface plugin collects traffic statistics on selected interfaces."
lucistatistics_collectdinterface_enable          = "Enable this plugin"
lucistatistics_collectdinterface_interfaces      = "Monitor interfaces"
lucistatistics_collectdinterface_interfaces_desc = "hold Ctrl while clicking to select multiple interfaces"
lucistatistics_collectdinterface_ignoreselected  = "Monitor all except selected ones"

-- iptables plugin
lucistatistics_collectdiptables			      = "Iptables Plugin Configuration"
lucistatistics_collectdiptables_desc                  = [[
	The iptables plugin will monitor selected firewall rules and collect
	informations about processed bytes and packets per rule.
]]

lucistatistics_collectdiptables_enable                = "Enable this plugin"

lucistatistics_collectdiptablesmatch                  = "Add matching rule"
lucistatistics_collectdiptablesmatch_desc             = [[
	Here you can define various criteria by which the monitored
	iptables rules are selected.
]]

lucistatistics_collectdiptablesmatch_name             = "Name of the rule"
lucistatistics_collectdiptablesmatch_name_desc        = "max. 16 chars"
lucistatistics_collectdiptablesmatch_table            = "Table"
lucistatistics_collectdiptablesmatch_chain            = "Chain"
lucistatistics_collectdiptablesmatch_target           = "Action (target)"
lucistatistics_collectdiptablesmatch_protocol         = "Network protocol"
lucistatistics_collectdiptablesmatch_source           = "Source ip range"
lucistatistics_collectdiptablesmatch_source_desc      = "CIDR notation"
lucistatistics_collectdiptablesmatch_destination      = "Destination ip range"
lucistatistics_collectdiptablesmatch_destination_desc = "CIDR notation"
lucistatistics_collectdiptablesmatch_inputif          = "Incoming interface"
lucistatistics_collectdiptablesmatch_inputif_desc     = "e.g. br-lan"
lucistatistics_collectdiptablesmatch_outputif         = "Outgoing interface"
lucistatistics_collectdiptablesmatch_outputif_desc    = "e.g. br-ff"
lucistatistics_collectdiptablesmatch_options          = "Options"
lucistatistics_collectdiptablesmatch_options_desc     = "e.g. reject-with tcp-reset"

-- irq plugin
lucistatistics_collectdirq                = "IRQ Plugin Configuration"
lucistatistics_collectdirq_desc           = [[
	The irq plugin will monitor the rate of issues per second for each selected interrupt.
	If no interrupt is selected then all interrupts are monitored.
]]

lucistatistics_collectdirq_enable         = "Enable this plugin"
lucistatistics_collectdirq_irqs           = "Monitor interrupts"
lucistatistics_collectdirq_irqs_desc      = "multiple separated by space"
lucistatistics_collectdirq_ignoreselected = "Monitor all except selected ones"

-- netlink plugin
lucistatistics_collectdnetlink            = "Netlink Plugin Configuration"
lucistatistics_collectdnetlink_desc       = [[
	The netlink plugin collects extended informations like qdisc-, class- and
	filter-statistics for selected interfaces.
]]

lucistatistics_collectdnetlink_enable                 = "Enable this plugin"
lucistatistics_collectdnetlink_interfaces             = "Basic monitoring"
lucistatistics_collectdnetlink_interfaces_desc        = "hold Ctrl while clicking to select multiple interfaces"
lucistatistics_collectdnetlink_verboseinterfaces      = "Verbose monitoring"
lucistatistics_collectdnetlink_verboseinterfaces_desc = "hold Ctrl while clicking to select multiple interfaces"
lucistatistics_collectdnetlink_qdiscs                 = "Qdisc monitoring"
lucistatistics_collectdnetlink_qdiscs_desc            = "hold Ctrl while clicking to select multiple interfaces"
lucistatistics_collectdnetlink_classes                = "Shaping class monitoring"
lucistatistics_collectdnetlink_classes_desc           = "hold Ctrl while clicking to select multiple interfaces"
lucistatistics_collectdnetlink_filters                = "Filter class monitoring"
lucistatistics_collectdnetlink_filters_desc           = "hold Ctrl while clicking to select multiple interfaces"

-- network plugin
lucistatistics_collectdnetwork            = "Network Plugin Configuration"
lucistatistics_collectdnetwork_desc       = [[
	The network plugin provides network based communication between different
	collectd instances. Collectd can operate both in client and server mode.
	In client mode locally collected date is transferred to a collectd server
	instance, in server mode the local instance receives data from other hosts.
]]

lucistatistics_collectdnetwork_enable          = "Enable this plugin"
lucistatistics_collectdnetworklisten           = "Listener interfaces"
lucistatistics_collectdnetworklisten_desc      = "This section defines on which interfaces collectd will wait for incoming connections."
lucistatistics_collectdnetworklisten_host      = "Listen host"
lucistatistics_collectdnetworklisten_host_desc = "host-, ip- or ip6 address"
lucistatistics_collectdnetworklisten_port      = "Listen port"
lucistatistics_collectdnetworklisten_port_desc = "0 - 65535"
lucistatistics_collectdnetworkserver           = "serverer interfaces"
lucistatistics_collectdnetworkserver_desc      = "This section defines to which servers the locally collected data is sent to."
lucistatistics_collectdnetworkserver_host      = "Server host"
lucistatistics_collectdnetworkserver_host_desc = "host-, ip- or ip6 address"
lucistatistics_collectdnetworkserver_port      = "Server port"
lucistatistics_collectdnetworkserver_port_desc = "0 - 65535"
lucistatistics_collectdnetwork_timetolive      = "TTL for network packets"
lucistatistics_collectdnetwork_timetolive_desc = "0 - 255"
lucistatistics_collectdnetwork_forward         = "Forwarding between listen and server addresses"
lucistatistics_collectdnetwork_cacheflush      = "Cache flush interval"
lucistatistics_collectdnetwork_cacheflush_desc = "seconds"

-- ping plugin
lucistatistics_collectdping            = "Ping Plugin Configuration"
lucistatistics_collectdping_desc       = [[
	The ping plugin will send icmp echo replies to selected hosts and
	measure the roundtrip time for each host.
]]

lucistatistics_collectdping_enable     = "Enable this plugin"
lucistatistics_collectdping_hosts      = "Monitor hosts"
lucistatistics_collectdping_hosts_desc = "multiple separated by space"
lucistatistics_collectdping_ttl        = "TTL for ping packets"
lucistatistics_collectdping_ttl_desc   = "0 - 255"

-- processes plugin
lucistatistics_collectdprocesses                = "Processes Plugin Configuration"
lucistatistics_collectdprocesses_desc           = [[
	The processes plugin collects informations like cpu time, page faults
	and memory usage of selected processes.
]]

lucistatistics_collectdprocesses_enable         = "Enable this plugin"
lucistatistics_collectdprocesses_processes      = "Monitor processes"
lucistatistics_collectdprocesses_processes_desc = "multiple separated by space"

-- rrdtool plugin
lucistatistics_collectdrrdtool                   = "RRDTool Plugin Configuration"
lucistatistics_collectdrrdtool_desc              = [[
	The rrdtool plugin stores the collected data in rrd database files, the
	foundation of the diagrams.<br /><br />
	<strong>Warning: Setting the wrong values will result in a very
	high memory consumption in the temporary directory. This can
	render the device unusable!</strong>
]]

lucistatistics_collectdrrdtool_enable            = "Enable this plugin"
lucistatistics_collectdrrdtool_datadir           = "Storage directory"
lucistatistics_collectdrrdtool_stepsize          = "RRD step interval"
lucistatistics_collectdrrdtool_stepsize_desc     = "seconds"
lucistatistics_collectdrrdtool_heartbeat         = "RRD heart beat interval"
lucistatistics_collectdrrdtool_heartbeat_desc    = "seconds"
lucistatistics_collectdrrdtool_rrasingle         = "Only create average RRAs"
lucistatistics_collectdrrdtool_rrasingle_desc    = "reduces rrd size"
lucistatistics_collectdrrdtool_rratimespans      = "Stored timespans"
lucistatistics_collectdrrdtool_rratimespans_desc = "seconds; multiple separated by space"
lucistatistics_collectdrrdtool_rrarows           = "Rows per RRA"
lucistatistics_collectdrrdtool_xff               = "RRD XFiles Factor"
lucistatistics_collectdrrdtool_cachetimeout      = "Cache collected data for"
lucistatistics_collectdrrdtool_cachetimeout_desc = "seconds"
lucistatistics_collectdrrdtool_cacheflush        = "Flush cache after"
lucistatistics_collectdrrdtool_cacheflush_desc   = "seconds"

-- tcpconns plugin
lucistatistics_collectdtcpconns                  = "TCPConns Plugin Configuration"
lucistatistics_collectdtcpconns_desc             = [[
	The tcpconns plugin collects informations about
	open tcp connections on selected ports.
]]

lucistatistics_collectdtcpconns_enable           = "Enable this plugin"
lucistatistics_collectdtcpconns_listeningports   = "Monitor all local listen ports"
lucistatistics_collectdtcpconns_localports       = "Monitor local ports"
lucistatistics_collectdtcpconns_localports_desc  = "0 - 65535; multiple separated by space"
lucistatistics_collectdtcpconns_remoteports      = "Monitor remote ports"
lucistatistics_collectdtcpconns_remoteports_desc = "0 - 65535; multiple separated by space"

-- unixsock plugin
lucistatistics_collectdunixsock                    = "Unixsock Plugin Configuration"
lucistatistics_collectdunixsock_desc               = [[
	The unixsock plugin creates a unix socket which can be used to read 
	collected data from a running collectd instance.
]]

lucistatistics_collectdunixsock_enable           = "Enable this plugin"
lucistatistics_collectdunixsock_socketfile       = "Filepath of the unix socket"
lucistatistics_collectdunixsock_socketgroup      = "Group ownership of the unix socket"
lucistatistics_collectdunixsock_socketgroup_desc = "group name"
lucistatistics_collectdunixsock_socketperms      = "File permissions of the unix socket"
lucistatistics_collectdunixsock_socketperms_desc = "octal"

-- wireless plugin
lucistatistics_collectdwireless                    = "Wireless Plugin Configuration"
lucistatistics_collectdwireless_desc               = [[
	The wireless plugin collects statistics about wireless signal strength, noise and quality.
]]

lucistatistics_collectdwireless_enable           = "Enable this plugin"
