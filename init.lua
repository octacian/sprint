-- sprint/init.lua

local sprinting = {}
local SPEED     = minetest.settings:get("sprint_speed")   or 1.8
local JUMP      = minetest.settings:get("sprint_jump")    or 1.1
local PRIMARY   = minetest.settings:get("sprint_primary") or "aux1"
local DIR       = minetest.settings:get("sprint_dir")     or true

---
--- Functions
---

local function start_sprint(player, name)
	player:set_physics_override({speed = SPEED, jump = JUMP})
	sprinting[name] = true
end

local function stop_sprint(player, name)
	player:set_physics_override({speed = 1, jump = 1})
	sprinting[name] = false
end

---
--- Registrations
---

minetest.register_globalstep(function(dtime)
	for _, player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local ctrl = player:get_player_control()

		local allow = true
		if DIR == true then
			if not ctrl.up then
				allow = false
			end
		end

		if ctrl[PRIMARY] and allow and not sprinting[name] then
			start_sprint(player, name)
		elseif (not ctrl[PRIMARY] and sprinting[name] == true) or
		 		(ctrl[PRIMARY] and not allow and sprinting[name] == true) then
			stop_sprint(player, name)
		end
	end
end)
