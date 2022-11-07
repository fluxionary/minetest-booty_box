booty_box.resources = {
	sounds = {},
	tiles = {
		"[combine:16x16^[noalpha^[colorize:#804000:255",
	},
}

if booty_box.has.default then
	booty_box.resources.sounds = default.node_sound_wood_defaults()
	booty_box.resources.tiles = {
		"default_chest_top.png",
		"default_chest_top.png",
		"default_chest_side.png",
		"default_chest_side.png",
		"default_chest_front.png",
	}
end
