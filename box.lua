local S = booty_box.S
local api = booty_box.api
local settings = booty_box.settings

minetest.register_node("booty_box:box", {
	description = S("booty box"),
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = { not_in_creative_inventory = 1, unbreakable = 1 },

	tiles = booty_box.resources.tiles,
	sounds = booty_box.resources.sounds,

	on_destruct = function(pos)
		api.unload_staff_inventory(pos)
	end,

	can_dig = function(pos, player)
		if not minetest.is_player(player) then
			return false
		end

		return minetest.check_player_privs(player, settings.priv)
	end,

	on_blast = function() end,

	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		if minetest.check_player_privs(clicker, settings.priv) then
			api.show_staff_formspec(pos, clicker)
		else
			api.show_player_formspec(pos, clicker)
		end
	end,
})
