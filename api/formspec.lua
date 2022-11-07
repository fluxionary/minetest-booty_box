local f = string.format

local fs = flow.widgets

local idiv = futil.math.idiv

local api = booty_box.api
local settings = booty_box.settings

local function get_w_h(size)
	for i = math.floor(math.sqrt(size)), 2, -1 do
		local j, r = idiv(size, i)
		if r == 0 then
			return j, i
		end
	end

	return size, 1
end

local w, h = get_w_h(settings.size)

api.staff_fs = flow.make_gui(function(player, ctx)
	local inv = ctx.inv
	local inv_location = f("detached:%s", inv:get_location().name)
	local player_w, player_h = get_w_h(player:get_inventory():get_size("main"))
	return fs.VBox({
		padding = 0.5,
		spacing = 0.1,
		fs.List({
			inventory_location = inv_location,
			list_name = "main",
			w = w,
			h = h,
		}),
		fs.Spacer({}),
		fs.List({
			inventory_location = "current_player",
			list_name = "main",
			w = player_w,
			h = player_h,
		}),
	})
end)

function api.show_staff_formspec(pos, player)
	local inv = api.get_staff_inventory(pos, player)
	api.staff_fs:show(player, { inv = inv })
end
