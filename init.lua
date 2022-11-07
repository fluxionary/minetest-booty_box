local f = string.format

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

booty_box = {
	author = "flux",
	license = "AGPL_v3",
	version = os.time({ year = 2022, month = 11, day = 6 }),
	fork = "flux",

	modname = modname,
	modpath = modpath,
	S = S,

	has = {
		default = minetest.get_modpath("default"),
	},

	log = function(level, messagefmt, ...)
		return minetest.log(level, f("[%s] %s", modname, f(messagefmt, ...)))
	end,

	dofile = function(...)
		return dofile(table.concat({ modpath, ... }, DIR_DELIM) .. ".lua")
	end,
}

booty_box.dofile("settings")
booty_box.dofile("resources")
booty_box.dofile("api", "init")
booty_box.dofile("box")
