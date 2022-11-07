std = "lua51+luajit+minetest+booty_box"
unused_args = false
max_line_length = 120

stds.minetest = {
	read_globals = {
		"DIR_DELIM",
		"minetest",
		"core",
		"dump",
		"vector",
		"nodeupdate",
		"VoxelManip",
		"VoxelArea",
		"PseudoRandom",
		"ItemStack",
		"default",
		"table",
		"math",
		"string",
	},
}

stds.booty_box = {
	globals = {
		"booty_box",
	},
	read_globals = {
		"futil",
		"flow",
	},
}
