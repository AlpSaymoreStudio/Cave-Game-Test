
local hud_flags = {
	hotbar = true,
	crosshair = true,
	wielditem = false,
	healthbar = false,
	breathbar = false,
	minimap = false,
	minimap_radar = false,
	basic_debug = true,
}

local inv_list = {}

core.register_on_mods_loaded(function()
	for name,def in pairs(core.registered_nodes) do
		if (def.groups.not_in_creative_inventory or 0) == 0 then
			inv_list[#inv_list+1] = name
		end
	end
	table.sort(inv_list, function(a,b)
		local oa, ob = core.registered_nodes[a].order, core.registered_nodes[b].order
		if     oa and ob then return oa < ob
		elseif oa        then return true
		elseif        ob then return false
		else return a < b
		end
	end)
end)


core.register_on_joinplayer(function(player, last_login)
--	player:set_sky({}) --TODO
	player:set_sun({ visible=false, sunrise_visible=false })
	player:set_moon({ visible=false })
	player:set_stars({ visible=false })
	player:set_clouds({ density=0 })
	player:override_day_night_ratio(1)
	player:set_lighting({ shadows=0 })

	player:set_inventory_formspec("")
--	player:set_formspec_prepend("") --TODO?
	
	player:hud_set_flags(hud_flags)
	player:hud_set_hotbar_itemcount(#inv_list)
	
	local name = player:get_player_name()
	local inv = core.get_inventory({ type="player", name=name })
	inv:set_size("main", #inv_list)
	inv:set_list("main", inv_list)
	
	player:set_properties({
		collisionbox = {-0.3, 0, -0.3, 0.3, 1.8, 0.3},
		-- TODO
	})
end)



 -- hand --

local cap = {
	times = { [1]=0.6, [2]=0.3, [3]=0.0, },
	uses = 0,
}

local groups = { "dig_immediate", "oddly_breakable_by_hand", "crumbly", "snappy", "cracky", }
local groupcaps = {}
for _,group in ipairs(groups) do
	groupcaps[group] = cap
end

core.register_item(":", {
	type = "none",
	tool_capabilities = {
		full_punch_interval = 0.2,
		max_drop_level = 0,
		damage_groups = { fleshy = 1 },
		groupcaps = groupcaps,
	},
})



 -- in-world items --

--local old_item_drop = core.item_drop
core.item_drop = function(itemstack, ...)
	return itemstack
end

local old_item_place = core.item_place
core.item_place = function(...)
	old_item_place(...)
	return nil
end

--local old_handle_node_drops = core.handle_node_drops
core.handle_node_drops = function(...)
	-- Ignore all drops
end
