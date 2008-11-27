olsrd = 'OLSR Daemon'
olsrd_neighbour_ip = 'Neighbour IP'
olsrd_local_ip = 'Local interface IP'
olsrd_network = 'Announced network'
olsrd_gateway = 'OLSR gateway'
olsrd_node = 'OLSR node'
olsrd_error = 'Unable to connect to the OLSR daemon!'
olsrd_error_desc = 'Make sure that OLSRd is running, the &quot;txtinfo&quot; plugin is loaded, configured on port 2006 and accepts connections from &quot;127.0.0.1&quot;.'
olsrd_hna = 'OLSR - HNA-Announcements'
olsrd_plugins = 'OLSR - Plugins'
olsrd_links = 'OLSR connections'
olsrd_links_desc = 'Overview of currently established OLSR connections'
olsrd_links_etx_desc = 'Expected retransmission count'
olsrd_links_lq_desc = 'Success rate of sent packages'
olsrd_links_nlq_desc = 'Success rate of received packages'
olsrd_routes = 'Known OLSR routes'
olsrd_routes_desc = 'Overview of currently known routes to other OLSR nodes'
olsrd_topology = 'Active OLSR nodes'
olsrd_topology_desc = 'Overview of currently known OLSR nodes'
olsrd_topology_lasthop = 'Last hop'
olsrd_hna2 = 'Active host net announcements'
olsrd_hna_desc = 'Overview of currently active OLSR host net announcements'
olsrd_mid = 'Active MID announcements'
olsrd_mid_desc = 'Overview of known multiple interface announcements'
olsrd_mid_aliases = 'Secondary OLSR interfaces'
olsrd_etx_ff = 'Freifunk'
olsrd_etx_float = 'floating point'
olsrd_etx_fpm = 'fixed point math'
olsrd_olsrd = 'General settings'
olsrd_olsrd_allownoint = 'Start without network'
olsrd_olsrd_clearscreen = 'Clear screen'
olsrd_olsrd_debuglevel = 'Debugmode'
olsrd_olsrd_fibmetric = 'FIB metric'
olsrd_olsrd_ipversion = 'Internet protocol'
olsrd_olsrd_linkqualityaging = 'LQ aging'
olsrd_olsrd_linkqualityalgorithm = 'LQ algorithm'
olsrd_olsrd_linkqualitydijkstralimit = 'LQ Dijkstra limit'
olsrd_olsrd_linkqualityfisheye = 'LQ fisheye'
olsrd_olsrd_linkqualitylevel = 'LQ level'
olsrd_olsrd_linkqualitylevel_1 = 'MPR selection'
olsrd_olsrd_linkqualitylevel_2 = 'MPR selection and routing'
olsrd_olsrd_linkqualitywinsize = 'LQ window size'
olsrd_olsrd_mprcoverage = 'MPR coverage'
olsrd_olsrd_pollrate = 'Pollrate'
olsrd_olsrd_tcredundancy = 'TC redundancy'
olsrd_olsrd_tcredundancy_0 = 'MPR selectors'
olsrd_olsrd_tcredundancy_1 = 'MPR selectors and MPR'
olsrd_olsrd_tcredundancy_2 = 'all neighbours'
olsrd_olsrd_usehysteresis = 'Use hysteresis'
olsrd_olsrd_willingness = 'Willingness'
olsrd_interface_hellointerval = 'Hello interval'
olsrd_interface_hellovaliditytime = 'Hello validity time'
olsrd_interface_hnainterval = 'HNA interval'
olsrd_interface_hnavaliditytime = 'HNA validity time'
olsrd_interface_ip4broadcast = 'IPv4 broadcast'
olsrd_interface_midinterval = 'MID interval'
olsrd_interface_midvaliditytime = 'MID validity time'
olsrd_interface_tcinterval = 'TC interval'
olsrd_interface_tcvaliditytime = 'TC validity time'
olsrd_ipcconnect = 'IPC settings'
olsrd_ipcconnect_desc = 'IPC connections enable you to remote-control the local OLSRd instance using external programs'
olsrd_ipcconnect_host = 'Allowed host addresses'
olsrd_ipcconnect_host_desc = 'Multiple separated by spaces'
olsrd_ipcconnect_maxconnections = 'Maxmimum connection count'
olsrd_ipcconnect_maxconnections_desc = 'Set to 0 to disable IPC'
olsrd_ipcconnect_net = 'Allowed subnets'
olsrd_ipcconnect_net_desc = 'Address Mask; multiple separated by space'
olsrd_hna4 = 'IPv4 HNA announcements'
olsrd_hna4_desc = 'Hna4 entries allow you to propagate local IPv4 host- and network-routes into the mesh network'
olsrd_hna4_netaddr = 'Network address'
olsrd_hna4_netaddr_desc = 'IPv4 address'
olsrd_hna4_netmask = 'Netmask'
olsrd_hna4_netmask_desc = 'IPv4 address'
olsrd_hna6 = 'IPv6 HNA announcements'
olsrd_hna6_desc = 'Hna6 entries allow you to propagate local IPv6 host- and network-routes into the mesh network'
olsrd_hna6_netaddr = 'Network address'
olsrd_hna6_netaddr_desc = 'IPv6 address'
olsrd_hna6_prefix = 'Prefix'
olsrd_hna6_prefix_desc = 'IPv6 prefix'
olsrd_loadplugin = 'Plugin configuration'
olsrd_loadplugin_ignore = 'Enable plugin'
olsrd_loadplugin_library = 'Library'
olsrd_loadplugin_accept = 'Allow connections from this hosts'
olsrd_loadplugin_ping = 'Ping test addresses'
olsrd_loadplugin_interval = 'Interval'
olsrd_loadplugin_hna = 'HNA announcements'
olsrd_loadplugin_hna_desc = 'Format: IP-Address Netmask / OLSR will announce this network once it is reachable'
olsrd_loadplugin_addhosts = 'Alternative \"hosts\" file'
olsrd_loadplugin_addhosts_desc = 'The contents of this file will be appended to the autogenerated \"hosts\" file'
olsrd_loadplugin_dnsserver = 'DNS server'
olsrd_loadplugin_hosts = 'Alternative hostnames'
olsrd_loadplugin_hosts_desc = 'Format: Interface-IP Hostname'
olsrd_loadplugin_hostsfile = 'Path to the \"hosts\" file'
olsrd_loadplugin_lat = 'Latitude'
olsrd_loadplugin_latlonfile = 'Output file for coordinates'
olsrd_loadplugin_latlonfile_desc = 'OLSR will write received coordinates of other nodes to this file'
olsrd_loadplugin_latloninfile = 'Input file for coordinates'
olsrd_loadplugin_latloninfile_desc = 'OLSR periodically checks this file for new coordinates and propagates them'
olsrd_loadplugin_lon = 'Longitude'
olsrd_loadplugin_name = 'Hostnames'
olsrd_loadplugin_namechangescript = 'Command for name changes'
olsrd_loadplugin_namechangescript_desc = 'OLSR executes this command once entries in the \"hosts\" are changed'
olsrd_loadplugin_resolvfile = 'Path to the \"resolv\" file'
olsrd_loadplugin_serviceschangescript = 'Command for service changes'
olsrd_loadplugin_serviceschangescript_desc = 'OLSR excutes this command once new service announcements are received'
olsrd_loadplugin_sighuppidfile = 'PID file for SIGHUP signals'
olsrd_loadplugin_sighuppidfile_desc = 'OLSR sends a HUP signal to this PID once the \"hosts\" oder \"resolv\" file is changed'
olsrd_loadplugin_suffix = 'Domain suffix'
olsrd_loadplugin_timeout = 'Timeout'
olsrd_loadplugin_bmfinterface = 'Name of the BMF interface'
olsrd_loadplugin_bmfinterfaceid = 'IP address of the BMF interface'
olsrd_loadplugin_dolocalbroadcast = 'Redirect local broadcasts'
olsrd_loadplugin_capturepacketsonolsrinterfaces = 'Also redirect broadcasts from OLSR interfaces'
olsrd_loadplugin_bmfmechanism = 'Propagation mechanism'
olsrd_loadplugin_broadcastretransmitcount = 'Number of retransmissions per package'
olsrd_loadplugin_fanoutlimit = 'Minimum number of neighbours for broadcast redirection'
olsrd_loadplugin_nonolsrif = 'Non-OLSR interfaces'
olsrd_loadplugin_port = 'Used port'
olsrd_loadplugin_host = 'Allow connections from hosts'
olsrd_loadplugin_net = 'Allow connections from subnets'
olsrd_loadplugin_net_desc = 'Format: IP-AddresseNetmask'
olsrd_loadplugin_redistribute = 'Used protocols'
olsrd_loadplugin_exportroutes = 'Only export routes to Quagga or to kernel too'
olsrd_loadplugin_localpref = 'Always prefer local routes'
olsrd_loadplugin_distance = 'Distance of exported routes'
olsrd_loadplugin_keyfile = 'Key file'
