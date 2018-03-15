-- sprint/init.lua

local sprinting       = {}
local secondary       = {}
local PRIMARY         = minetest.settings:get("sprint_primary") or "aux1"
local SECOND          = minetest.settings:get("sprint_second")  or "up"
local DIR             = minetest.settings:get("sprint_dir")     or "true"
local SPEED           = minetest.settings:get("sprint_speed")
local JUMP            = minetest.settings:get("sprint_jump")
local PARTICLE_NUM    = minetest.settings:get("sprint_particles")
local ALLOW_SEC       = minetest.settings:get("sprint_enable_second")

SPEED        = tonumber(SPEED)        or 1.3
JUMP         = tonumber(JUMP)         or 1.1
PARTICLE_NUM = tonumber(PARTICLE_NUM) or 1

---
--- Functions
---

local function start_sprint(player, name, trigger)
	if player_monoids then
		player_monoids.speed:add_change(player, SPEED, "sprint:sprint")
		player_monoids.jump:add_change(player, JUMP, "sprint:jump")
	else
		player:set_physics_override({speed = SPEED, jump = JUMP})
	end
	sprinting[name] = {is = true, trigger = trigger}
end

local function stop_sprint(player, name)
	if player_monoids then
		player_monoids.speed:del_change(player, "sprint:sprint")
		player_monoids.jump:del_change(player, "sprint:jump")
	else
		player:set_physics_override({speed = 1, jump = 1})
	end
	sprinting[name] = {is = false}
end

---
--- Registrations
---

minetest.register_globalstep(function(dtime)
	for _, player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local ctrl = player:get_player_control()

		if not sprinting[name] then
			sprinting[name] = {is = false}
		end

		local spr = sprinting[name]
		local allow = true

		if DIR == "true" then
			if not ctrl.up then
				allow = false
			end
		end

		-- Stop sprinting when movement controls are released even though
		-- sprint key is still pressed
		if spr.is then
			if DIR == "true" then
				if not ctrl.up then
					stop_sprint(player, name)
				end
			else
				if not ctrl.up and not ctrl.down and not ctrl.right and not ctrl.left then
					stop_sprint(player, name)
				end
			end
		end

		-- Begin sprinting again when movement controls are pressed again even
		-- if the sprint key has not been triggered again but is just being held
		if ctrl[PRIMARY] and allow and not spr.is and (ctrl.up or ctrl.down or ctrl.right or
				ctrl.left) then
			start_sprint(player, name, spr.trigger)
		end

		-- Primary Key
		if ctrl[PRIMARY] and allow and not spr.is and (ctrl.up or ctrl.down or ctrl.right or
				ctrl.left) then
			start_sprint(player, name, "primary")
		elseif ((not ctrl[PRIMARY] and spr.is) or
				 (ctrl[PRIMARY] and not allow and spr.is))
						and spr.trigger == "primary" then
			stop_sprint(player, name)
		end

		-- Secondary Key
		if ALLOW_SEC ~= "false" and SECOND and SECOND ~= "" and spr.trigger ~= "primary" then
			if not secondary[name] then
				secondary[name] = {count = 0, time = 0, last = false}
			end

			if ctrl[SECOND] ~= secondary[name].last then
				if secondary[name].time > 0.8 and not spr.is and
						 secondary[name].count > 0 and secondary[name].count < 3 then
					secondary[name] = {count = 0, time = 0, last = false}
					return
				end

				if secondary[name].count < 3 and ctrl[SECOND] ~= secondary[name].last then
					secondary[name].count = secondary[name].count + 1
					secondary[name].last  = ctrl[SECOND]
				end

				if (secondary[name].count == 3 and ctrl[SECOND]) and allow and not spr.is then
					start_sprint(player, name, "secondary")
				elseif ((secondary[name].count > 3 or not ctrl[SECOND]) or not allow) and
						spr.is then
					stop_sprint(player, name)
					secondary[name] = {count = 0, time = 0, last = false}
				end
			end

			if not spr.is and secondary[name].count ~= 0 then
				secondary[name].time = secondary[name].time + dtime
			end
		end

		-- Particles
		if PARTICLE_NUM ~= 0 and spr.is then
			local pos = player:get_pos()
			pos.y = pos.y - 1

			local node = minetest.get_node_or_nil(pos)
			if node and node.name ~= "air" and node.name ~= "ignore" then
				local def = minetest.registered_nodes[node.name]
				local tile = def.tiles[1] or def.inventory_image or ""
				if type(tile) == "string" then
					minetest.add_particlespawner({
						time = 0.5,
						amount = PARTICLE_NUM,
						minpos = {x = pos.x - 0.5, y = pos.y + 1.1, z = pos.z - 0.5},
						maxpos = {x = pos.x + 0.5, y = pos.y + 1.1, z = pos.z + 0.5},
						minvel = {x = 0, y = 3, z = 0},
						maxvel = {x = 0, y = 5, z = 0},
						minacc = {x = 0, y = -10, z = 0},
						maxacc = {x = 0, y = -13, z = 0},
						minexptime = 0.5,
						maxexptime = 1,
						minsize = 0.5,
						maxsize = 2,
						collisiondetection = true,
						vertical = false,
						texture = tile,
					})
				end
			end
		end
	end
end)
