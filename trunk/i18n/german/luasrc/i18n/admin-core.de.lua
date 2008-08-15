a_i_i_admin1 = [[Dies ist der Administrationsbereich von LuCI.]]
a_i_i_admin2 = [[LuCI ist eine freie, flexible und benutzerfreundliche grafische Oberfläche zur Konfiguration von OpenWRT Kamikaze.]]
a_i_i_admin3 = [[Auf den folgenden Seiten können alle wichtigen Einstellungen des Routers vorgenommen werden.]]
a_i_i_admin4 = [[Hinweis: In LuCI werden getätigte Änderungen erst nach einem Klick auf Änderungen - Anwenden gespeichert.]]
a_i_i_admin5 = [[Wir sind natürlich stets darum bemüht, diese Oberfläche 
noch besser und intuitiver zu Gestalten und freuen uns über jegliche Art von Feedback oder Verbesserungsvorschlägen.]]
a_i_i_admin6 = [[Und nun wünschen wir viel Spaß mit dem Router!]]
a_i_i_hello = [[Hallo!]]
a_i_i_team = [[Das LuCI-Team]]
a_i_keepflash = [[Zu übernehmende Dateien bei Firmwareupgrade]]
a_i_keepflash1 = [[Die folgenden Dateien und Verzeichnisse werden beim Aktualisieren der Firmware
über die Oberfläche automatisch in die neue Firmware übernommen.]]
a_i_luci1 = "Hier können Eigenschaften und die Funktionalität der Oberfläche angepasst werden."
a_i_ucicommit = [[UCI-Befehle beim Anwenden]]
a_i_ucicommit1 = [[Beim Anwenden
der Konfiguration aus der Oberflächliche heraus können automatisch die relevanten Dienste neugestart werden,
sodass Änderungen sofort nach dem Anwenden aktiv werden und der Router nicht erst neugestartet werden muss.]]
a_i_ui = [[Benutzeroberfläche]]
a_n_i_bridge = [[Netzwerkbrücke]]
a_n_i_bridge1 = [[überbrückt angegebene Schnittstelle(n)]]
a_n_ifaces1 = [[An dieser Stelle können die einzelnen Schnittstellen 
des Netzwerkes konfiguriert werden. Es können mehrere Schnittstellen zu einer Brücke zusammengefasst werden,
indem diese durch Leerzeichen getrennt aufgezählt werden und ein entsprechender Haken im Feld Netzwerkbrücke
gesetzt wird. Es können VLANs in der Notation SCHNITTSTELLE.VLANNR (z.B.: eth0.1) verwendet werden.]]
a_n_ptp = [[Punkt-zu-Punkt Verbindungen]]
a_n_ptp1 = [[Punkt-zu-Punkt Verbindungen
über PPPoE oder PPTP werden häufig dazu verwendet, um über DSL o.ä. Techniken eine
Verbindung zum Internetgateway eines Internetzugangsanbieters aufzubauen.]]
a_n_r_netmask1 = [[falls Ziel ein Netzwerk ist]]
a_n_r_target1 = [[Host-IP oder Netzwerk]]
a_n_routes = [[Routen]]
a_n_routes1 = [[Routen geben an,
über welche Schnittstelle und welches Gateway ein bestimmter Host
oder ein bestimmtes Netzwerk erreicht werden kann.]]
a_n_routes_static = [[Statische Routen]]
a_n_routes_kernel4 = [[Aktive IPv4-Routen]]
a_n_switch = [[Switch]]
a_n_switch1 = [[Die Netzwerkschnittstellen am Router
können zu verschienden VLANs zusammengefasst werden, in denen Geräte miteinander direkt
kommunizieren können. VLANs werden auch häufig dazu genutzt, um Netzwerke voneiander zu trennen.
So ist oftmals eine Schnittstelle als Uplink zu einem größerem Netz, wie dem Internet vorkonfiguriert
und die anderen Schnittstellen bilden ein VLAN für das lokale Netzwerk.]]
a_network1 = [[In diesem Bereich finden sich alle netzwerkbezogenen Einstellungen.]]
a_network2 = [[Der Netzwerkswitch kann bei den meisten Routern frei konfiguriert
und in mehrere VLANs aufgeteilt werden. ]]
a_network3 = [[Schnittstellen und PPPoE/PPTP-Einstellungen ermöglichen
die freie Organisation des Netzwerks und die Anbindung an ein WAN.]]
a_network4 = [[DHCP ermöglichst die automatische Netzwerkkonfiguration von Rechnern im (W)LAN.]]
a_network5 = [[Portweiterleitung und Firewall erlauben eine effektive Absicherung des Netzes, bei gleichzeitiger
Bereitstellung von externen Diensten.]]
a_s_changepw = [[Passwort ändern]]
a_s_changepw1 = [[Ändert das Passwort des Systemverwalters (Benutzer "root")]]
a_s_changepw_changed = [[Passwort erfolgreich geändert]]
a_s_changepw_nomatch = [[Passwörter stimmen nicht überein]]
a_s_desc = "An dieser Stelle können Grundeinstellungen des Systems wie Hostname oder Zeitzone vorgenommen werden."
a_s_flash = [[Upgrade]]
a_s_flash_flashed = [[Flashvorgang erfolgreich. Router startet neu...]]
a_s_flash_flasherr = [[Flashvorgang fehlgeschlagen]]
a_s_flash_fwimage = [[Firmwareimage]]
a_s_flash_fwupgrade = [[Firmware aktualisieren]]
a_s_flash_keepcfg = [[Konfigurationsdateien übernehmen]]
a_s_flash_notimplemented = [[Diese Funktion steht leider (noch) nicht zur Verfügung.]]
a_s_flash_upgrade1 = [[Ersetzt die installierte Firmware (das Betriebssystem des Routers) durch ein neues.
Das Format der Firmware ist plattformabhängig.]]
a_s_fstab = [[Einhängepunkte]]
a_s_fstab_active = "Eingehängte Dateisysteme"
a_s_fstab_used = "Benutzt"
a_s_fstab_avail = "Verfügbar"
a_s_fstab_device1 = [[Die Gerätedatei des Speichers oder der Partition (z.B.: /dev/sda)]]
a_s_fstab_fs1 = [[Das Dateisystem mit dem der Speicher formatiert ist (z.B.: ext3)]]
a_s_fstab_mountpoint = [[Einhängepunkt]]
a_s_fstab_mountpoints = [[Einhängepunkte]]
a_s_fstab_mountpoints1 = [[Einhängepunkte bestimmen, an welcher Stelle des Dateisystems
bestimmte Laufwerke und Speicher zur Verwendung eingebunden werden.]]
a_s_fstab_swap1 = [[Falls der Arbeitsspeicher des Routers nicht ausreicht,
kann dieser nicht benutzte Daten zeitweise auf einem SWAP-Laufwerk auslagern um so die
effektive Größe des Arbeitsspeichers zu erhöhen. Die Auslagerung der Daten ist natürlich bedeutend langsamer
als direkte Arbeitsspeicherzugriffe.]]
a_s_i_system1 = [[Hier finden sich Einstellungen, die das System selbst, dessen Kennung,
installierte Software und Hardware, Authentifizierung oder eingehängte Speicher betreffen.]]
a_s_i_system2 = [[Diese Einstellungen definieren die Grundlage des Systems, auf dem die
installierte Software aufbaut.]]
a_s_i_system3 = [[Beachte bitte, dass eine fehlerhafte Konfiguration den Start
des Routers verhindern oder dich vom Zugriff auf diesen ausschließen kann.]]
a_s_p_ipkg = [[IPKG-Konfiguration]]
a_s_p_ipkg_pkglists = [[Paketlisten]]
a_s_p_ipkg_targets = [[Installationsziele]]
a_s_packages = [[Paketverwaltung]]
a_s_packages_do = [[Aktionen ausführen]]
a_s_packages_install = [[Installation von]]
a_s_packages_installurl = [[Paket herunterladen und installieren]]
a_s_packages_ipkg = [[Paketlisten und Installationsziele bearbeiten]]
a_s_packages_name = [[Paketname]]
a_s_packages_remove = [[Deinstallation von]]
a_s_packages_search = [[Paket suchen]]
a_s_packages_update = [[Paketlisten aktualisieren]]
a_s_packages_updatelist = [[Paketlisten aktualisieren]]
a_s_packages_upgrade = [[Installierte Pakete aktualisieren]]
a_s_reboot1 = [[Startet das Betriebssystem des Routers neu.]]
a_s_reboot_do = [[Neustart durchführen]]
a_s_reboot_running = [[Bitte warten: Neustart wird durchgeführt...]]
a_s_reboot_u = "Warnung: Es gibt ungespeicherte Änderungen, die beim Neustart verloren gehen!"
a_s_sshkeys = [[SSH-Schlüssel]]
a_s_sshkeys1 = [[Hier können öffentliche SSH-Schlüssel (einer pro Zeile)
 zur Authentifizierung abgelegt werden.]]
a_srv_d_pwauth = [[Passwortanmeldung]]
a_srv_d_pwauth1 = [[Erlaube Anmeldung per Passwort]]
a_srv_dropbear1 = [[Der SSH-Server ermöglicht Shell-Zugriff
über das Netzwerk und bietet einen integrierten SCP-Dienst.]]
a_srv_http1 = [[Ein kleiner Webserver, der für die Bereitstellung von LuCI genutzt werden kann.]]
a_srv_http_authrealm = [[Anmeldeaufforderung]]
a_srv_http_authrealm1 = [[Aufforderungstext zum Anmelden im Administrationsbereich]]
a_srv_http_config1 = [[/etc/httpd.conf wenn leer]]
a_srv_http_root = [[Wurzelverzeichnis]]
a_srv_services1 = [[Dienste und Dämonen stellen bestimmte Funktionalitäten auf dem Router zur Verfügung.]]
a_srv_services2 = [[Es handelt sich hierbei meist um Netzwerkserver, die verschiedene Aufgaben auf dem Router erfüllen,
beispielsweise Shell-Zugang ermöglichen oder diese Weboberfläche per HTTP anbieten.]]
a_st_i_status1 = [[Hier finden sich Informationen über den aktuellen Status des Systems, beispielsweise
Prozessortakt, Speicherauslastung und Netzwerkschnittstellen.]]
a_st_i_status2 = [[Zusätzlich können hier Protokolldaten, des Kernels und diverser Systemdienste eingesehen werden,
um deren Zustand zu kontrollieren.]]
a_w_devices1 = "An dieser Stelle können eingebaute WLAN-Geräte konfiguriert werden."
a_w_apisolation = [[AP-Isolation]]
a_w_apisolation1 = [[Unterbindet Client-Client-Verkehr]]
a_w_athburst = [[Atheros-Frameburst]]
a_w_brcmburst = [[Broadcom-Frameburst]]
a_w_channel = [[Funkkanal]]
a_w_connlimit = [[Verbindungslimit]]
a_w_countrycode = [[Ländercode]]
a_w_distance1 = [[Distanz zum am weitesten entfernten Funkpartner (m)]]
a_w_diversity = [[Diversität]]
a_w_hideessid = [[ESSID verstecken]]
a_w_netid = [[Netzkennung (ESSID)]]
a_w_network1 = [[WLAN-Netz zu Netzwerk hinzufügen]]
a_w_networks1 = [[Pro WLAN-Gerät können mehrere Netze bereitgestellt werden.
Es sollte beachtet werden, dass es hardware- / treiberspezifische Einschränkungen gibt.
So kann pro WLAN-Gerät in der Regel entweder 1 Ad-Hoc-Zugang ODER bis zu 3 Access-Point und 1 Client-Zugang
gleichzeitig erstellt werden.]]
a_w_radiusport = [[Radius-Port]]
a_w_radiussrv = [[Radius-Server]]
a_w_rxantenna = [[Empfangsantenne]]
a_w_txantenna = [[Sendeantenne]]
a_w_txpwr = [[Sendeleistung]]
a_w_wifi1 = [[Hier finden sich Konfiugrationsmöglichkeiten für Drahtlos-Netzwerke nach dem WLAN-Standard.]]
a_w_wifi2 = [[802.11b/g/a/n-Geräte können so einfach in das bestehende physische Netzwerk integriert werden.
Die Unterstützung von virtuellen Adaptern ermöglicht auch den Einsatz als Wireless-Repeater oder von
mehreren Netzwerken gleichzeitig auf einem Gerät.]]
a_w_wifi3 = [[Es werden Managed, Client, Ad-Hoc und WDS-Modus unterstützt sowie WPA und WPA2-Verschlüsselung zur gesicherten
Kommunikation.]]
a_w_ap = "Access Point"
a_w_adhoc = "Ad-Hoc"
a_w_client = "Client"
a_w_ahdemo = "Pseudo Ad-Hoc (ahdemo)"
a_w_monitor = "Monitor"
a_w_wds = "WDS"
accept = [[Annehmen]]
aliases = [[Aliasse]]
bitrate = [[Bitrate]]
c_contributors = [[Mitwirkende Entwickler]]
c_leaddev = [[Leitende Entwicklung]]
c_lucidesc = [[LuCI ist eine Sammlung freier Lua-Software einschließlich eines MVC-Webframeworks und einer Weboberfläche für eingebettete Geräte. Luci steht unter der Apache-Lizenz.]]
c_projecthome = [[Projekt Homepage]]
c_thanksto = [[Dank an]]
configure = [[Konfigurieren]]
contact = [[Kontakt]]
contact1 = [[Diese Daten sind
auf der öffentlichen Kontaktseite sichtbar. Bitte gib an, wie man dich am besten kontaktieren kann.
Diese Informationen sollten nach der Picopeering Vereinbarung mindestens deine E-Mail-Adresse enthalten.
Damit dein Knoten durch Topographieprogramme erfasst werden kann, gib bitte deine Geokoordinaten oder
zumindest deine Straße und Hausnummer unter Standort an.]]
coord = [[Koordinaten]]
coord1 = [[Bitte als Breite;Länge (z.B: 51.5;12.9) angeben]]
cpu = [[Prozessor]]
decline = [[Ablehnen]]
defroutes = [[Standardrouten]]
destination = [[Ziel]]
dhcp_desc = [[Mit Hilfe von DHCP können Netzteilnehmer automatisch
ihre Netzwerkkonfiguration (IP-Adresse, Netzmaske, DNS-Server, ...) beziehen.]]
dhcp_dhcp_dynamicdhcp = [[Dynamisches DHCP]]
dhcp_dhcp_force = [[Start erzwingen]]
dhcp_dhcp_ignore = [[Schnittstelle ignorieren]]
dhcp_dhcp_ignore_desc = [[DHCP für dieses Netzwerk deaktivieren]]
dhcp_dhcp_leasetime = [[Laufzeit]]
dhcp_dhcp_limit_desc = [[Anzahl zu vergebender Adressen -1]]
dhcp_dhcp_start_desc = [[Erste vergebene Adresse (letztes Oktett)]]
dhcp_dnsmasq_addnhosts = [[Zusätzliche Hostdatei]]
dhcp_dnsmasq_authoritative = [[Authoritativ]]
dhcp_dnsmasq_authoritative_desc = [[Dies ist der einzige DHCP im lokalen Netz]]
dhcp_dnsmasq_boguspriv = [[Private Anfragen filtern]]
dhcp_dnsmasq_boguspriv_desc = [[Reverse DNS-Anfragen für lokale Netze nicht weiterleiten]]
dhcp_dnsmasq_dhcpleasemax = [[max. DHCP-Leases]]
dhcp_dnsmasq_dnsforwardmax = [[gleichzeitige Abfragen]]
dhcp_dnsmasq_domain = [[Lokale Domain]]
dhcp_dnsmasq_domainneeded = [[Anfragen nur mit Domain]]
dhcp_dnsmasq_domainneeded_desc = [[Anfragen ohne Domainnamen nicht weiterleiten]]
dhcp_dnsmasq_ednspacket_max = [[max. EDNS.0 Paketgröße]]
dhcp_dnsmasq_expandhosts = [[Erweitere Hosts]]
dhcp_dnsmasq_expandhosts_desc = [[Fügt Domainnamen zu einfachen Hosteinträgen in der Resolvdatei hinzu]]
dhcp_dnsmasq_filterwin2k = [[Windowsanfragen filtern]]
dhcp_dnsmasq_filterwin2k_desc = [[nutzlose DNS-Anfragen aktueller Windowssysteme filtern]]
dhcp_dnsmasq_leasefile = [[Leasedatei]]
dhcp_dnsmasq_leasefile_desc = [[Speicherort für vergebenen DHCP-Adressen]]
dhcp_dnsmasq_local = [[Lokale Server]]
dhcp_dnsmasq_localisequeries = [[Lokalisiere Anfragen]]
dhcp_dnsmasq_localisequeries_desc = [[Gibt die Adresse eines Hostnamen entsprechend seines Subnetzes zurück]]
dhcp_dnsmasq_logqueries = [[Schreibe Abfragelog]]
dhcp_dnsmasq_nohosts = [[Ignoriere /etc/hosts]]
dhcp_dnsmasq_nonegcache = [[Unbekannte nicht cachen]]
dhcp_dnsmasq_nonegcache_desc = [[Negative DNS-Antworten nicht zwischenspeichern]]
dhcp_dnsmasq_noresolv = [[Ignoriere Resolvdatei]]
dhcp_dnsmasq_port = [[DNS-Port]]
dhcp_dnsmasq_queryport = [[Abfrageport]]
dhcp_dnsmasq_readethers = [[Verwende /etc/ethers]]
dhcp_dnsmasq_readethers_desc = [[Lese Informationen aus /etc/ethers um den DHCP-Server zu konfigurieren]]
dhcp_dnsmasq_resolvfile = [[Resolvdatei]]
dhcp_dnsmasq_resolvfile_desc = [[Lokale DNS-Datei]]
dhcp_dnsmasq_strictorder = [[Strikte Reihenfolge]]
dhcp_dnsmasq_strictorder_desc = [[DNS-Server werden strikt der Reihenfolge in der Resolvdatei nach abgefragt]]
file = [[Datei]]
frag = [[Frag.]]
frequency = [[Frequenz]]

hellonet = [[Hallo und willkommen im Netz von]]
iface = [[Schnittstelle]]
iwscan = [[WLAN-Scan]]
iwscan1 = [[Drahtlosnetzwerke in der lokalen Umgebung des Routers:]]
iwscan_encr = [[Vers.]]
iwscan_link = [[Verb.]]
iwscan_noise = [[Rausch]]
iwscan_signal = [[Signal]]
link = [[Verb.]]

dhcp_leases = "Zuweisungen"
luci_ethers = "Statische Einträge"
dhcp_timeremain = "Verbleibende Gültigkeit"
dhcp_leases_active = "Aktive Zuweisungen"

network_interface_demand = [[Automatische Trennung]]
network_interface_demand_desc = [[Zeit (in s) nach der die Verbindung bei Inaktivität getrennt wird]]
network_interface_keepalive = [[Keep-Alive]]
network_interface_keepalive_desc = [[Anzahl fehlgeschlagener Verbindungstests nach der automatisch neu verbunden wird]]
network_interface_server = [[PPTP-Server]]
network_switch_desc = [[Die zu einem VLAN gehörenden Schnittstellen
werden durch Leerzeichen getrennt. Die Schnittstelle mit der höchsten Nummer (meistens 5) bildet
in der Regel die Verbindung zur internen Netzschnittstelle des Routers. Bei Geräten mit 5 Schnittstellen
ist in der Regel die Schnittstelle mit der niedrigsten Nummer (0) die standardmäßige Uplinkschnittstelle des Routers.]]


noise = [[Rausch]]
power = [[Leistung]]
routes = [[Routen]]
routes_gateway = [[Gateway]]
routes_metric = [[Metrik]]
routes_netmask = [[Netzmaske]]
rts = [[RTS]]
signal = [[Signal]]
status = [[Status]]
system_type = [[Systemtyp]]
texteditor = [[Texteditor]]
uci_applied = [[Die folgenden Änderungen wurden übernommen]]
uci_reverted = [[Die folgenden Änderungen wurden verworfen]]

m_n_local = "Lokales Netz"
m_n_inet  = "Internetverbindung"
m_n_route = "Weiterleiten"
m_n_bridge = "Überbrücken"

m_w_ap = "Anbieten (Access Point)"
m_w_adhoc = "Unabhängig (Ad-Hoc)"
m_w_client = "Einklinken (Client)"
m_w_wds = "Verteilen (WDS)"
m_w_clientmode = "Verbindungsmodus"


system_system_logsize = "Größe des Systemprotokollpuffers"
system_system_logip = "Externer Systemprotokollserver"
system_system_conloglevel = "Protokollausgabelevel"
system_system_conloglevel_desc = "Level auf der Konsole ausgegebener Meldungen"

m_i_processor = "Prozessor"
m_i_memory = "Hauptspeicher"
m_i_systemtime = "Lokale Zeit"
m_i_uptime = "Laufzeit"

m_n_d_firstaddress = "Erste vergebene Adresse"
m_n_d_numleases = "Anzahl vergebener Adressen"

routingtable = "Routingtabelle"
wlanscan = "WLAN-Scan"


m_n_keepalive = "automatisch neu verbinden"
m_n_dialondemand = "trennen bei Inaktivität nach"
m_n_pptp_server = "PPTP-Server"

a_s_applyreboot1 = "Änderungen angewandt."

a_s_backup = "Sichern / Wiederherstellen"
a_s_backup_backup = "Sicherung erstellen"
a_s_backup_archive = "Sicherungsarchiv"
a_s_backup_reset = "Grundeinstellungen wiederherstellen"
a_s_backup_reset1 = "Alle aktuellen Einstellungen verwerfen und Grundeinstellungen wiederherstellen?"
a_s_backup_restore = "Sicherung wiederherstellen"
a_s_backup1 = [[Auf dieser Seite können Sicherungen der Konfiguration erstellt und eingespielt werden
und - wenn möglich - die Grundeinstellungen wiederhergestellt werden.]]

leds = "LED Konfiguration"
leds_desc = "Passt das Verhalten der Geräte-LEDs an - wenn dies möglich ist."
system_led_name = "LED Name"
system_led_sysfs = "LED Gerät"
system_led_default = "Grundzustand"
system_led_default_desc = "ausgewählt = an"
system_led_trigger = "Auslöser"
system_led_trigger_none = "Keiner"
system_led_trigger_defaulton = "Immer an"
system_led_trigger_timer = "Taktgeber"
system_led_trigger_heartbeat = "Herzschlag (Mittlere Systemlast)"
system_led_trigger_netdev = "Netzwerkschnittstelle"
system_led_delayoff = "Einschaltverzögerung"
system_led_delayoff_desc = "Zeit (in ms) die die LED deaktiviert ist"
system_led_delayon = "Ausschaltverzögerung"
system_led_delayon_desc = "Zeit (in ms) die die LED aktiviert ist"
system_led_dev = "Schnittstelle"
system_led_mode = "Auslösemodus"
system_led_mode_link = "Verbindung hergestellt"
system_led_mode_tx = "Senden"
system_led_mode_rx = "Empfangen"

network_interface_up = "Aktiv"
network_interface_hwaddr = "MAC-Adresse"
network_interface_hwaddr_desc = "Hardware Adresse"
network_interface_txrx = "Traffic"
network_interface_txrx_desc = "gesendet / empfangen"
network_interface_err = "Fehler"
network_interface_err_desc = "TX / RX"

network_interface_fwzone = "Firewallzone anlegen / zuweisen"
network_interface_fwzone_desc = "Diese Schnittstelle gehört bis jetzt zu keiner Firewallzone."