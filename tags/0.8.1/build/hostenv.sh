#!/bin/sh
export LD_LIBRARY_PATH="$1/usr/lib:$LD_LIBRARY_PATH"
export PATH="$1/bin:$1/usr/bin:$PATH"
export LUA_PATH="$1/$2/?.lua;$1/$2/?/init.lua;;"
export LUA_CPATH="$1/$3/?.so;;"
$4
