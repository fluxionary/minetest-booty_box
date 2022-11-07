local s = minetest.settings

booty_box.settings = {
	size = tonumber(s:get("booty_box:size")) or 32,
	priv = s:get("booty_box:staff_priv") or "server",
}
