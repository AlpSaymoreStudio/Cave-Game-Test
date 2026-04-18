
core.register_on_mods_loaded(function()
	for name,def in pairs(core.registered_nodes) do
		if def.order then
			core.register_alias(tostring(def.order), name)
		end
	end
end)



 -- nodes --

core.register_node(":minecraft:stone", {
	order = 1,
	description = "Stone",
	tiles = { "default_cobble.png" },
	groups = { crumbly=1, cracky=3, },
	is_ground_content = true,
})

core.register_node(":minecraft:grass", {
	order = 2,
	description = "Grass",
	tiles = { "default_grass.png" },
	groups = { crumbly=2, snappy=3, },
	is_ground_content = true,
})
