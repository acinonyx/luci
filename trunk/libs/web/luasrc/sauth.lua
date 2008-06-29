--[[

Session authentication
(c) 2008 Steven Barth <steven@midlink.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

$Id$

]]--
module("luci.sauth", package.seeall)
require("luci.fs")
require("luci.config")


luci.config.sauth = luci.config.sauth or {}
sessionpath = luci.config.sauth.sessionpath
sessiontime = tonumber(luci.config.sauth.sessiontime)


function clean()
	local now   = os.time()
	local files = luci.fs.dir(sessionpath)
	
	if not files then
		return nil
	end
	
	for i, file in pairs(files) do
		local fname = sessionpath .. "/" .. file
		local stat = luci.fs.stat(fname)
		if stat and stat.type == "regular" and stat.atime + sessiontime < now then
			luci.fs.unlink(fname)
		end 
	end
end

function prepare()
	luci.fs.mkdir(sessionpath)
	luci.fs.chmod(sessionpath, "a-rwx,u+rwx")
end

function read(id)
	if not id then
		return
	end
	clean()
	return luci.fs.readfile(sessionpath .. "/" .. id)
end

function write(id, data)
	if not luci.fs.stat(sessionpath) then
		prepare()
	end
	luci.fs.writefile(sessionpath .. "/" .. id, data)
	luci.fs.chmod(sessionpath .. "/" .. id, "a-rwx,u+rw")
end