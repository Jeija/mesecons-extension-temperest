--TEMPEREST-PLUG

local plug_rules = {
	{x=-1, y=0, z=0},
	{x=1, y=0, z=0},
	{x=0, y=-1, z=0},
	{x=0, y=1, z=0},
	{x=0, y=0, z=-1},
	{x=0, y=0, z=1},
}

local plug_on = function(pos)
	for i, rule in ipairs(plug_rules) do
		local checkpos = {x=pos.x + rule.x, y=pos.y + rule.y, z=pos.z + rule.z}
		if minetest.env:get_node(checkpos).name == "air" then
			checkpos.x, checkpos.y, checkpos.z = checkpos.x + rule.x, checkpos.y + rule.y, checkpos.z + rule.z
			local node = minetest.env:get_node(checkpos)
			if node.name == "mesecons_temperest:mesecon_socket_off" then
				mesecon:swap_node(checkpos, "mesecons_temperest:mesecon_socket_on")
				mesecon:receptor_on(checkpos)
			elseif node.name == "mesecons_temperest:mesecon_inverter_on" then
				mesecon:swap_node(checkpos, "mesecons_temperest:mesecon_inverter_off")
				mesecon:receptor_off(checkpos)
			end
		end
	end
end

local plug_off = function(pos)
	for i, rule in ipairs(plug_rules) do
		local checkpos = {x=pos.x + rule.x, y=pos.y + rule.y, z=pos.z + rule.z}
		if minetest.env:get_node(checkpos).name == "air" then
			checkpos.x, checkpos.y, checkpos.z = checkpos.x + rule.x, checkpos.y + rule.y, checkpos.z + rule.z
			local node = minetest.env:get_node(checkpos)
			if node.name == "mesecons_temperest:mesecon_socket_on" then
				mesecon:swap_node(checkpos, "mesecons_temperest:mesecon_socket_off")
				mesecon:receptor_off(checkpos)
			elseif node.name == "mesecons_temperest:mesecon_inverter_off" then
				mesecon:swap_node(checkpos, "mesecons_temperest:mesecon_inverter_on")
				mesecon:receptor_on(checkpos)
			end
		end
	end
end

minetest.register_node("mesecons_temperest:mesecon_plug", {
	description = "Plug",
	drawtype = "nodebox",
	paramtype = "light",
	tile_images = {"jeija_mesecon_plug.png"},
	inventory_image = "jeija_mesecon_plug.png",
	wield_image = "jeija_mesecon_plug.png",
	groups = {dig_immediate=2, mesecon_effector_on=1, mesecon_effector_off=1, mesecon=2},
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	node_box = {
		type = "fixed",
		fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	after_place_node = plug_off,
	after_dig_node = plug_off,
	mesecons = {effector = {
		action_on = plug_on,
		action_off = plug_off,
	}},
})

minetest.register_craft({
	output = 'mesecons_temperest:mesecon_plug 2',
	recipe = {
		{'', 'group:mesecon_conductor_craftable', ''},
		{'group:mesecon_conductor_craftable', 'default:steel_ingot', 'group:mesecon_conductor_craftable'},
		{'', 'group:mesecon_conductor_craftable', ''},
	}
})

--TEMPEREST-SOCKET

minetest.register_node("mesecons_temperest:mesecon_socket_off", {
	description = "Socket",
	drawtype = "nodebox",
	paramtype = "light",
	tile_images = {"jeija_mesecon_socket_off.png"},
	inventory_image = "jeija_mesecon_socket_off.png",
	wield_image = "jeija_mesecon_socket_off.png",
	groups = {dig_immediate=2, mesecon_effector_on=1, mesecon_effector_off=1, mesecon=2},
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	node_box = {
		type = "fixed",
		fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	mesecons = {receptor = {
		state = mesecon.state.off
	}},
})

minetest.register_node("mesecons_temperest:mesecon_socket_on", {
	drawtype = "nodebox",
	paramtype = "light",
	tile_images = {"jeija_mesecon_socket_on.png"},
	groups = {dig_immediate=2,not_in_creative_inventory=1, mesecon_effector_on=1, mesecon_effector_off=1, mesecon=2},
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	node_box = {
		type = "fixed",
		fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	drop = 'mesecons_temperest:mesecon_socket_off',
	after_dig_node = function(pos)
		mesecon:receptor_off(pos)
	end,
	mesecons = {receptor = {
		state = mesecon.state.on
	}},
})

minetest.register_craft({
	output = '"mesecons_temperest:mesecon_socket_off" 2',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:steel_ingot', 'mesecons_temperest:mesecon_off', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	}
})

--TEMPEREST-INVERTER

minetest.register_node("mesecons_temperest:mesecon_inverter_off", {
	drawtype = "nodebox",
	paramtype = "light",
	tile_images = {"jeija_mesecon_inverter_off.png"},
	groups = {dig_immediate=2,not_in_creative_inventory=1, mesecon_effector_on=1, mesecon_effector_off=1, mesecon=2},
	walkable = false,
	selection_box = {
		type = "fixed",
	fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	node_box = {
		type = "fixed",
	fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	drop = 'mesecons_temperest:mesecon_inverter_on',
	mesecons = {receptor = {
		state = mesecon.state.off
	}},
})

minetest.register_node("mesecons_temperest:mesecon_inverter_on", {
	description = "Inverter",
	drawtype = "nodebox",
	paramtype = "light",
	tile_images = {"jeija_mesecon_inverter_on.png"},
	inventory_image = "jeija_mesecon_inverter_on.png",
	wield_image = "jeija_mesecon_inverter_on.png",
	groups = {dig_immediate=2, mesecon_effector_on=1, mesecon_effector_off=1, mesecon=2},
	walkable = false,
	selection_box = {
		type = "fixed",
	fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	node_box = {
		type = "fixed",
		fixed = { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 },
	},
	after_place_node = function(pos)
		mesecon:receptor_on(pos)
	end,
	after_dig_node = function(pos)
		mesecon:receptor_off(pos)
	end,
	mesecons = {receptor = {
		state = mesecon.state.on
	}},
})

minetest.register_craft({
	output = 'mesecons_temperest:mesecon_inverter_on 2',
	recipe = {
		{'mesecons_temperest:mesecon_off', 'default:steel_ingot', 'group:mesecon_conductor_craftable'},
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'group:mesecon_conductor_craftable', 'default:steel_ingot', 'group:mesecon_conductor_craftable'},
	}
})
