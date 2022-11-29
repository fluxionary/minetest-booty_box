local f = string.format

local check_player_privs = minetest.check_player_privs
local create_detached_inventory = minetest.create_detached_inventory
local get_meta = minetest.get_meta
local hash_node_position = minetest.hash_node_position
local remove_detached_inventory = minetest.remove_detached_inventory

local DefaultTable = futil.DefaultTable
local deserialize_invlist = futil.deserialize_invlist
local serialize_invlist = futil.serialize_invlist

local api = booty_box.api
local settings = booty_box.settings

api.staff_inv_by_player_name_by_hpos = DefaultTable(function(hpos)
	return DefaultTable(function(player_name)
		local pos = minetest.get_position_from_hash(hpos)
		local inv_name = f("booty_box:%i:%s", hpos, player_name)

		local staff_inv_callbacks = {
			allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
				return 0
			end,

			allow_put = function(inv, listname, index, stack, player)
				if check_player_privs(player, settings.staff_priv) then
					return stack:get_count()
				end
			end,

			allow_take = function(inv, listname, index, stack, player)
				if check_player_privs(player, settings.staff_priv) then
					return stack:get_count()
				end
			end,

			on_put = function(inv, listname, index, stack, player)
				api.save_staff_inventory(pos, player)
			end,

			on_take = function(inv, listname, index, stack, player)
				api.save_staff_inventory(pos, player)
			end,
		}

		local inv = create_detached_inventory(inv_name, staff_inv_callbacks, player_name)
		inv:set_size("main", settings.size)

		return inv
	end)
end)

api.player_inv_by_player_name_by_hpos = DefaultTable(function(hpos)
	return DefaultTable(function(player_name)
		local pos = minetest.get_position_from_hash(hpos)
		local inv_name = f("booty_box:%i:%s", hpos, player_name)

		local staff_inv_callbacks = {
			allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
				return 0
			end,

			allow_put = function(inv, listname, index, stack, player)
				return 0
			end,

			on_take = function(inv, listname, index, stack, player)
				api.save_player_inventory(pos, player)
			end,
		}

		local inv = create_detached_inventory(inv_name, staff_inv_callbacks, player_name)
		inv:set_size("main", settings.size)

		return inv
	end)
end)

function api.get_staff_inventory(pos, player)
	local hpos = hash_node_position(pos)
	local player_name = player:get_player_name()
	local inv = api.staff_inv_by_player_name_by_hpos[hpos][player_name]

	local node_meta = get_meta(pos)
	local serialized_list = node_meta:get("inv")

	if serialized_list then
		inv:set_list("main", {})
		deserialize_invlist(serialized_list, inv, "main")
	end

	return inv
end

function api.save_staff_inventory(pos, player)
	local hpos = hash_node_position(pos)
	local player_name = player:get_player_name()
	local inv = api.staff_inv_by_player_name_by_hpos[hpos][player_name]
	local list = inv:get_list("main")

	for other_player_name, other_inv in pairs(api.staff_inv_by_player_name_by_hpos[hpos]) do
		if other_player_name ~= player_name then
			other_inv:set_list("main", list)
		end
	end

	local meta = get_meta(pos)
	meta:set_string("inv", serialize_invlist(inv, "main"))
	meta:mark_as_private("inv")
end

function api.unload_staff_inventory(pos)
	local hpos = hash_node_position(pos)

	for player_name, inv in pairs(api.staff_inv_by_player_name_by_hpos[hpos]) do
		remove_detached_inventory(inv:get_location().name)
		api.staff_inv_by_player_name_by_hpos[hpos][player_name] = nil
	end

	api.staff_inv_by_player_name_by_hpos[hpos] = nil
end
