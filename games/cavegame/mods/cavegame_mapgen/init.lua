
local mgname = core.get_mapgen_setting("mg_name")
if mgname == "v6" then
	error("Mapgen 'v6' is not supported by Cave Game.", 0)
end

core.register_alias("mapgen_stone", "minecraft:stone")
core.register_alias("mapgen_water_source", "air")
-- DO NOT SET THIS TO "air"! LEST MINETEST BE UPON YOU! 
-- TWO YEARS OF PAIN! THERE WAS NO EXPLANATION IN SIGHT!
--core.register_alias("mapgen_river_water_source", ...)


core.register_biome({
	name = "cavegame",
	node_dust = "minecraft:grass",
--	node_top = "minecraft:grass",
--	depth_top = 1,
	node_stone = "minecraft:stone",
	heat_point = 50,
	humidity_point = 50,
	y_min = -3100, y_max = 3100,
})


if mgname == "singlenode" then
	local ground_level = tonumber(core.settings:get("water_level") or 1)
	local air = core.get_content_id("air")
	local stone = core.get_content_id("minecraft:stone")
	local grass = core.get_content_id("minecraft:grass")
	
	core.register_on_generated(function(minp, maxp, blockseed)
		local vm, emin, emax = core.get_mapgen_object("voxelmanip")
		local va = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
		
		local nodes = vm:get_data()
		
		for i, _ in pairs(nodes) do
			local y = va:position(i).y
			if y < ground_level then
				nodes[i] = stone
			elseif y == ground_level then
				nodes[i] = grass
			else
				nodes[i] = air
			end
		end
		
		vm:set_data(nodes)
		vm:write_to_map()
	end)
	
	-- see https://github.com/minetest/minetest/issues/12782
	if not core.settings:get("static_spawnpoint") then
		local spawnpos = vector.new(0, ground_level+1, 0)
		core.register_on_joinplayer(function(player, lastlogin)
			if not lastlogin then
				player:set_pos(spawnpos)
			end
		end)
		core.register_on_respawnplayer(function(player)
			player:set_pos(spawnpos)
			return true
		end)
	end
end
