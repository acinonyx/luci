include $(TOPDIR)/rules.mk

PKG_BRANCH:=tags/0.8.0

ifeq ($(DUMP),)
  USELOCAL:=$(shell grep luci ../../../.project 2>/dev/null >/dev/null && echo 1)
endif

PKG_NAME:=luci
PKG_RELEASE:=1

ifeq ($(USELOCAL),1)
  PKG_VERSION:=0.8+svn
else
  PKG_SOURCE_URL:=http://dev.leipzig.freifunk.net/svn/ff-luci/$(PKG_BRANCH)
  ifeq ($(DUMP),)
    PKG_REV:=HEAD
    PKG_VERSION:=0.8.0
  endif
  PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
  PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
  PKG_SOURCE_PROTO:=svn
  PKG_SOURCE_VERSION:=$(PKG_REV)
endif

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

PKG_BUILD_DEPENDS:=libnotimpl
LUA_TARGET:=source
PKG_SELECTED_MODULES:=


include $(INCLUDE_DIR)/package.mk

ifeq ($(USELOCAL),1)
  define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(TAR) c -C ../../../ . \
		--exclude=.pc --exclude=.svn --exclude=.git \
		--exclude='boa-0*' --exclude='*.o' --exclude='*.so' \
		--exclude=dist | \
			tar x -C $(PKG_BUILD_DIR)/
  endef
endif

define Build/Configure
endef

### Templates ###

define Package/luci/libtemplate
  SECTION:=admin
  CATEGORY:=Administration
  TITLE:=LuCI - Lua Configuration Interface
  URL:=http://luci.freifunk-halle.net/
  MAINTAINER:=Steven Barth <steven-at-midlink-dot-org>
  SUBMENU:=LuCI Libraries
  DEPENDS:=+luci-core
endef

define Package/luci/i18ntemplate
  $(call Package/luci/libtemplate)
  SUBMENU:=LuCI Translations
  DEPENDS:=+luci-web
endef

define Package/luci/thtemplate
  $(call Package/luci/libtemplate)
  SUBMENU:=LuCI Themes
  DEPENDS:=+luci-web
endef

define Package/luci/webtemplate
  $(call Package/luci/libtemplate)
  SUBMENU:=LuCI Components
endef


define Package/luci/install/template
	$(CP) -a $(PKG_BUILD_DIR)/$(2)/dist/* $(1)/ -R
	$(CP) -a $(PKG_BUILD_DIR)/$(2)/ipkg/* $(1)/CONTROL/ 2>/dev/null || true
endef



### Core package ###

define Package/luci-core
  $(call Package/luci/libtemplate)
  DEPENDS:=+lua
  TITLE:=LuCI core libraries
endef

define Package/luci-core/install
	$(call Package/luci/install/template,$(1),libs/core)
endef

define Package/luci-core/config
       choice
               prompt "Build Target"
               default PACKAGE_luci-core_source

       config PACKAGE_luci-core_compile
               bool "Precompiled"

       config PACKAGE_luci-core_stripped
               bool "Stripped"

       config PACKAGE_luci-core_source
               bool "Full Source"

       endchoice
endef

ifneq ($(CONFIG_PACKAGE_luci-core_compile),)
  LUA_TARGET:=compile
endif

ifneq ($(CONFIG_PACKAGE_luci-core_stripped),)
  LUA_TARGET:=strip
endif


### Libraries ###
define Package/luci-cbi
  $(call Package/luci/libtemplate)
  DEPENDS+=+luci-web +luci-uvl +luci-uci
  TITLE:=Configuration Binding Interface
endef

define Package/luci-cbi/install
	$(call Package/luci/install/template,$(1),libs/cbi)
endef


define Package/luci-uci
  $(call Package/luci/libtemplate)
  DEPENDS+=+libuci-lua
  TITLE:=High-Level UCI API
endef

define Package/luci-uci/install
	$(call Package/luci/install/template,$(1),libs/uci)
endef


define Package/luci-fastindex
  $(call Package/luci/libtemplate)
  TITLE:=Fastindex indexing module
endef

define Package/luci-fastindex/install
	$(call Package/luci/install/template,$(1),libs/fastindex)
endef


define Package/luci-http
  $(call Package/luci/libtemplate)
  TITLE:=HTTP Protocol implementation
endef

define Package/luci-http/install
	$(call Package/luci/install/template,$(1),libs/http)
endef


define Package/luci-ipkg
  $(call Package/luci/libtemplate)
  TITLE:=LuCI IPKG/OPKG call abstraction library
endef

define Package/luci-ipkg/install
	$(call Package/luci/install/template,$(1),libs/ipkg)
endef


define Package/luci-json
  $(call Package/luci/libtemplate)
  TITLE:=LuCI JSON Library
endef

define Package/luci-json/install
	$(call Package/luci/install/template,$(1),libs/json)
endef


define Package/luci-sys
  $(call Package/luci/libtemplate)
  TITLE:=LuCI Linux/POSIX system library
endef

define Package/luci-sys/install
	$(call Package/luci/install/template,$(1),libs/sys)
endef


define Package/luci-web
  $(call Package/luci/libtemplate)
  DEPENDS+=+luci-http +luci-sys +luci-uci +luci-sgi-cgi
  TITLE:=MVC Webframework
endef

define Package/luci-web/conffiles
/etc/config/luci
endef

define Package/luci-web/install
	$(call Package/luci/install/template,$(1),libs/web)
endef


define Package/luci-uvl
  $(call Package/luci/libtemplate)
  DEPENDS+=+luci-sys +luci-uci +luci-core
  TITLE:=UVL - UCI Validation Layer
endef

define Package/luci-uvl/install
	$(call Package/luci/install/template,$(1),libs/uvl)
endef


### Modules ###

define Package/luci-admin-core
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-web +luci-cbi +luci-theme-openwrt +luci-i18n-english
  TITLE:=Web UI Core Module
endef

define Package/luci-admin-core/conffiles
/etc/config/luci_hosts
/etc/config/luci_ethers
endef

define Package/luci-admin-core/install
	$(call Package/luci/install/template,$(1),modules/admin-core)
endef


define Package/luci-admin-mini
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-core
  TITLE:=LuCI Essentials - stripped down and user-friendly
endef

define Package/luci-admin-mini/install
	$(call Package/luci/install/template,$(1),modules/admin-mini)
endef


define Package/luci-admin-full
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-core +luci-ipkg
  TITLE:=LuCI Administration - full-featured for full control
endef

define Package/luci-admin-full/install
	$(call Package/luci/install/template,$(1),modules/admin-full)
endef


define Package/luci-admin-rpc
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-json
  TITLE:=LuCI RPC - JSON-RPC API
endef

define Package/luci-admin-rpc/install
	$(call Package/luci/install/template,$(1),modules/rpc)
endef


### Applications ###

define Package/luci-app-firewall
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-core
  TITLE:=Firewall and Portforwarding application
endef

define Package/luci-app-firewall/install
	$(call Package/luci/install/template,$(1),applications/luci-fw)
endef


define Package/luci-app-olsr
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-full +olsrd-luci +olsrd-luci-mod-txtinfo
  TITLE:=OLSR configuration and status module
endef

define Package/luci-app-olsr/install
	$(call Package/luci/install/template,$(1),applications/luci-olsr)
endef


define Package/luci-app-qos
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-core +qos-scripts
  TITLE:=Quality of Service configuration module
endef

define Package/luci-app-qos/install
	$(call Package/luci/install/template,$(1),applications/luci-qos)
endef


define Package/luci-app-statistics
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-full +collectd +collectd-mod-rrdtool1 +rrdtool1
  TITLE:=LuCI Statistics Application
endef

define Package/luci-app-statistics/conffiles
/etc/config/luci_statistics
endef

define Package/luci-app-statistics/install
	$(call Package/luci/install/template,$(1),applications/luci-statistics)
endef


define Package/luci-app-upnp
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-core +miniupnpd
  TITLE:=Universal Plug & Play configuration module
endef

define Package/luci-app-upnp/install
	$(call Package/luci/install/template,$(1),applications/luci-upnp)
endef


define Package/luci-app-ntpc
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-core +ntpclient
  TITLE:=NTP time synchronisation client configuration module
endef

define Package/luci-app-ntpc/install
	$(call Package/luci/install/template,$(1),applications/luci-ntpc)
endef


define Package/luci-app-ddns
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-core +ddns-scripts
  TITLE:=Dynamic DNS configuration module
endef

define Package/luci-app-ddns/install
	$(call Package/luci/install/template,$(1),applications/luci-ddns)
endef


define Package/luci-app-samba
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-full +samba3
  TITLE:=Network Shares - Samba SMB/CIFS module
endef

define Package/luci-app-samba/install
	$(call Package/luci/install/template,$(1),applications/luci-samba)
endef


define Package/luci-app-uvc_streamer
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-full +uvc-streamer
  TITLE:=Webcam Streaming - UVC-Streamer module
endef

define Package/luci-app-uvc_streamer/install
        $(call Package/luci/install/template,$(1),applications/luci-uvc_streamer)
endef


define Package/luci-app-p910nd
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-full +p910nd
  TITLE:=p910nd - Printer server module
endef

define Package/luci-app-p910nd/install
        $(call Package/luci/install/template,$(1),applications/luci-p910nd)
endef


define Package/luci-app-ushare
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-full +ushare
  TITLE:=ushare - UPnP A/V & DLNA Media Server
endef

define Package/luci-app-ushare/install
        $(call Package/luci/install/template,$(1),applications/luci-ushare)
endef

define Package/luci-app-hd_idle
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-full +hd-idle
  TITLE:=hd-idle
endef

define Package/luci-app-hd_idle/install
        $(call Package/luci/install/template,$(1),applications/luci-hd_idle)
endef

define Package/luci-app-tinyproxy
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-full +tinyproxy
  TITLE:=Tinyproxy - HTTP(S)-Proxy
endef

define Package/luci-app-tinyproxy/install
        $(call Package/luci/install/template,$(1),applications/luci-tinyproxy)
endef

define Package/luci-app-initmgr
  $(call Package/luci/webtemplate)
  DEPENDS+=+luci-admin-full
  TITLE:=LuCI Initscript Management
endef

define Package/luci-app-initmgr/install
        $(call Package/luci/install/template,$(1),applications/luci-initmgr)
endef


### Server Gateway Interfaces ###

define Package/luci-sgi-cgi
  $(call Package/luci/libtemplate)
  TITLE:=SGI for CGI
endef

define Package/luci-sgi-cgi/install
	$(call Package/luci/install/template,$(1),libs/sgi-cgi)
endef


### Themes ###
define Package/luci-theme-openwrt
  $(call Package/luci/thtemplate)
  TITLE:=OpenWRT.org (default)
endef

define Package/luci-theme-openwrt/install
	$(call Package/luci/install/template,$(1),themes/openwrt.org)
endef

define Package/luci-theme-openwrtlight
  $(call Package/luci/thtemplate)
  TITLE:=OpenWRT.org - light variant without images
endef

define Package/luci-theme-openwrtlight/install
	$(call Package/luci/install/template,$(1),themes/openwrt-light)
endef


### Translations ###
define Package/luci-i18n-german
  $(call Package/luci/i18ntemplate)
  TITLE:=German
endef

define Package/luci-i18n-german/install
	$(call Package/luci/install/template,$(1),i18n/german)
endef


define Package/luci-i18n-english
  $(call Package/luci/i18ntemplate)
  TITLE:=English
endef

define Package/luci-i18n-english/install
	$(call Package/luci/install/template,$(1),i18n/english)
endef


define Package/luci-i18n-french
  $(call Package/luci/i18ntemplate)
  TITLE:=French (by Florian Fainelli)
endef

define Package/luci-i18n-french/install
	$(call Package/luci/install/template,$(1),i18n/french)
endef


define Package/luci-i18n-russian
  $(call Package/luci/i18ntemplate)
  TITLE:=Russian (by Skryabin Dmitry)
endef

define Package/luci-i18n-russian/install
	$(call Package/luci/install/template,$(1),i18n/russian)
endef


define Package/luci-i18n-portuguese_brazilian
  $(call Package/luci/i18ntemplate)
  TITLE:=Portuguese (Brazilian) (by Carlos Cesario)
endef

define Package/luci-i18n-portuguese_brazilian/install
	$(call Package/luci/install/template,$(1),i18n/portuguese_brazilian)
endef



### Compile ###
ifneq ($(CONFIG_PACKAGE_luci-core),)
	PKG_SELECTED_MODULES+=libs/core
endif
ifneq ($(CONFIG_PACKAGE_luci-cbi),)
	PKG_SELECTED_MODULES+=libs/cbi
endif
ifneq ($(CONFIG_PACKAGE_luci-fastindex),)
	PKG_SELECTED_MODULES+=libs/fastindex
endif
ifneq ($(CONFIG_PACKAGE_luci-http),)
	PKG_SELECTED_MODULES+=libs/http
endif
ifneq ($(CONFIG_PACKAGE_luci-ipkg),)
	PKG_SELECTED_MODULES+=libs/ipkg
endif
ifneq ($(CONFIG_PACKAGE_luci-json),)
	PKG_SELECTED_MODULES+=libs/json
endif
ifneq ($(CONFIG_PACKAGE_luci-uci),)
	PKG_SELECTED_MODULES+=libs/uci
endif
ifneq ($(CONFIG_PACKAGE_luci-sys),)
	PKG_SELECTED_MODULES+=libs/sys
endif
ifneq ($(CONFIG_PACKAGE_luci-web),)
	PKG_SELECTED_MODULES+=libs/web
endif
ifneq ($(CONFIG_PACKAGE_luci-uvl),)
	PKG_SELECTED_MODULES+=libs/uvl
endif

ifneq ($(CONFIG_PACKAGE_luci-admin-core),)
	PKG_SELECTED_MODULES+=modules/admin-core
endif
ifneq ($(CONFIG_PACKAGE_luci-admin-mini),)
	PKG_SELECTED_MODULES+=modules/admin-mini
endif
ifneq ($(CONFIG_PACKAGE_luci-admin-full),)
	PKG_SELECTED_MODULES+=modules/admin-full
endif
ifneq ($(CONFIG_PACKAGE_luci-admin-rpc),)
	PKG_SELECTED_MODULES+=modules/rpc
endif

ifneq ($(CONFIG_PACKAGE_luci-app-firewall),)
	PKG_SELECTED_MODULES+=applications/luci-fw
endif
ifneq ($(CONFIG_PACKAGE_luci-app-olsr),)
	PKG_SELECTED_MODULES+=applications/luci-olsr
endif
ifneq ($(CONFIG_PACKAGE_luci-app-qos),)
	PKG_SELECTED_MODULES+=applications/luci-qos
endif
ifneq ($(CONFIG_PACKAGE_luci-app-statistics),)
	PKG_SELECTED_MODULES+=applications/luci-statistics
endif
ifneq ($(CONFIG_PACKAGE_luci-app-upnp),)
	PKG_SELECTED_MODULES+=applications/luci-upnp
endif
ifneq ($(CONFIG_PACKAGE_luci-app-ntpc),)
	PKG_SELECTED_MODULES+=applications/luci-ntpc
endif
ifneq ($(CONFIG_PACKAGE_luci-app-ddns),)
	PKG_SELECTED_MODULES+=applications/luci-ddns
endif
ifneq ($(CONFIG_PACKAGE_luci-app-samba),)
	PKG_SELECTED_MODULES+=applications/luci-samba
endif
ifneq ($(CONFIG_PACKAGE_luci-app-uvc_streamer),)
	PKG_SELECTED_MODULES+=applications/luci-uvc_streamer
endif
ifneq ($(CONFIG_PACKAGE_luci-app-p910nd),)
        PKG_SELECTED_MODULES+=applications/luci-p910nd
endif
ifneq ($(CONFIG_PACKAGE_luci-app-ushare),)
        PKG_SELECTED_MODULES+=applications/luci-ushare
endif
ifneq ($(CONFIG_PACKAGE_luci-app-hd_idle),)
       PKG_SELECTED_MODULES+=applications/luci-hd_idle
endif
ifneq ($(CONFIG_PACKAGE_luci-app-tinyproxy),)
       PKG_SELECTED_MODULES+=applications/luci-tinyproxy
endif
ifneq ($(CONFIG_PACKAGE_luci-app-initmgr),)
       PKG_SELECTED_MODULES+=applications/luci-initmgr
endif


ifneq ($(CONFIG_PACKAGE_luci-sgi-cgi),)
	PKG_SELECTED_MODULES+=libs/sgi-cgi
endif

ifneq ($(CONFIG_PACKAGE_luci-theme-openwrt),)
	PKG_SELECTED_MODULES+=themes/openwrt.org
endif
ifneq ($(CONFIG_PACKAGE_luci-theme-openwrtlight),)
	PKG_SELECTED_MODULES+=themes/openwrt-light
endif

ifneq ($(CONFIG_PACKAGE_luci-i18n-german),)
	PKG_SELECTED_MODULES+=i18n/german
endif
ifneq ($(CONFIG_PACKAGE_luci-i18n-english),)
	PKG_SELECTED_MODULES+=i18n/english
endif
ifneq ($(CONFIG_PACKAGE_luci-i18n-french),)
	PKG_SELECTED_MODULES+=i18n/french
endif
ifneq ($(CONFIG_PACKAGE_luci-i18n-russian),)
	PKG_SELECTED_MODULES+=i18n/russian
endif
ifneq ($(CONFIG_PACKAGE_luci-i18n-portuguese_brazilian),)
	PKG_SELECTED_MODULES+=i18n/portuguese_brazilian
endif


MAKE_FLAGS += \
	MODULES="$(PKG_SELECTED_MODULES)" \
	LUA_TARGET="$(LUA_TARGET)" \
	LUA_SHLIBS="-llua -lm" \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include" \
	LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib" \
	OS="Linux"


$(eval $(call BuildPackage,luci-core))
$(eval $(call BuildPackage,luci-cbi))
$(eval $(call BuildPackage,luci-fastindex))
$(eval $(call BuildPackage,luci-http))
$(eval $(call BuildPackage,luci-ipkg))
$(eval $(call BuildPackage,luci-json))
$(eval $(call BuildPackage,luci-uci))
$(eval $(call BuildPackage,luci-sys))
$(eval $(call BuildPackage,luci-web))
$(eval $(call BuildPackage,luci-uvl))

$(eval $(call BuildPackage,luci-admin-core))
$(eval $(call BuildPackage,luci-admin-mini))
$(eval $(call BuildPackage,luci-admin-full))
$(eval $(call BuildPackage,luci-admin-rpc))

$(eval $(call BuildPackage,luci-app-firewall))
$(eval $(call BuildPackage,luci-app-olsr))
$(eval $(call BuildPackage,luci-app-qos))
$(eval $(call BuildPackage,luci-app-statistics))
$(eval $(call BuildPackage,luci-app-upnp))
$(eval $(call BuildPackage,luci-app-ntpc))
$(eval $(call BuildPackage,luci-app-ddns))
$(eval $(call BuildPackage,luci-app-samba))
$(eval $(call BuildPackage,luci-app-uvc_streamer))
$(eval $(call BuildPackage,luci-app-p910nd))
$(eval $(call BuildPackage,luci-app-ushare))
$(eval $(call BuildPackage,luci-app-hd_idle))
$(eval $(call BuildPackage,luci-app-tinyproxy))
$(eval $(call BuildPackage,luci-app-initmgr))

$(eval $(call BuildPackage,luci-sgi-cgi))

$(eval $(call BuildPackage,luci-theme-openwrt))
$(eval $(call BuildPackage,luci-theme-openwrtlight))

$(eval $(call BuildPackage,luci-i18n-german))
$(eval $(call BuildPackage,luci-i18n-english))
$(eval $(call BuildPackage,luci-i18n-french))
$(eval $(call BuildPackage,luci-i18n-russian))
$(eval $(call BuildPackage,luci-i18n-portuguese_brazilian))
