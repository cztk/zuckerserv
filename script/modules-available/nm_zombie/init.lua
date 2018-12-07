--[[
	Script:			noobmod/clone.lua
	Authors:		Hanack (Andreas Schaeffer)
	Created:		24-Apr-2013
	Last Modified:	24-Apr-2013
	License:		GPL3
]]

nm_zombie = {}
nm_zombie.module = "ZOMBIE"
nm_zombie.label = "ZOMBIE"
nm_zombie.lock_reason = "infected by a zombie"
nm_zombie.name = "zombie"
nm_zombie.team = "zombie"
nm_zombie.enabled = 1
nm_zombie.running = 0
nm_zombie.debug = 0
nm_zombie.max_number_of_zombies = 60
nm_zombie.initial_number_of_zombies = 10
nm_zombie.current_number_of_zombies = 0
nm_zombie.regenerate_rate = 2
nm_zombie.bite_regeneration = 180
nm_zombie.bite_dist = 20
nm_zombie.need_regeneration_min_health = 200
nm_zombie.regenerated_min_health = 400
nm_zombie.max_health = 500
nm_zombie.armour = 25
nm_zombie.strength = 20
nm_zombie.weakness = 50
nm_zombie.gunselect = 0
nm_zombie.target_cn = -1
nm_zombie.search_min_dist = 1000
nm_zombie.search_max_vlen = 2
nm_zombie.search_acceleration = 1.2
nm_zombie.search_max_velocity_length_dividor = 6
nm_zombie.search_max_falling_vcubes = 7
nm_zombie.attack_acceleration = 1.4
nm_zombie.max_attack_iterations = 150
nm_zombie.path_change = 7
nm_zombie.min_velocity = 5
nm_zombie.max_velocity = 60
nm_zombie.init_velocity = 5
nm_zombie.max_not_moved_iterations = 5
nm_zombie.states = { search = 1, attack = 2, regenerate = 3 }
nm_zombie.start_state = nm_zombie.states.search
nm_zombie.instances = {}
nm_zombie.vcube_i = 0
nm_zombie.RAD = (math.pi / 180.0)

function nm_zombie.reset_zombie(zcn)
	nm_zombie.instances[zcn] = {
		zcn = zcn,
		state = nm_zombie.start_state,
		pos = { 0, 0, 0 },
		vel = { 0, 0, 0 },
		last_pos = { 0, 0, 0 },
		health = nm_zombie.max_health,
		armour = nm_zombie.armour,
		gunselect = nm_zombie.gunselect,
		strength = nm_zombie.strength,
		weakness = nm_zombie.weakness,
		target_cn = nm_zombie.target_cn,
		not_moved_iterations = 0,
		attack_iterations = 0
	}
end

function nm_zombie.create_zombie()
	if nm_zombie.current_number_of_zombies >= nm_zombie.max_number_of_zombies then return end
	local zcn = players.get_fake_cn()
	nm_zombie.current_number_of_zombies = nm_zombie.current_number_of_zombies + 1
	nm_zombie.reset_zombie(zcn)
	server.send_fake_connect(-1, zcn, nm_zombie.name, nm_zombie.team)
	nm_zombie.spawn(zcn)
	return zcn
end

function nm_zombie.destroy_zombie(zcn)
	if nm_zombie.instances[zcn] == nil then return end
	nm_zombie.instances[zcn] = nil
	nm_zombie.current_number_of_zombies = nm_zombie.current_number_of_zombies - 1
	server.send_fake_disconnect(-1, zcn)
	players.free_fake_cn(zcn)
end

function nm_zombie.spawn(zcn)
	local playerstart_slots = {}
	for i, slot in ipairs(entities.map_slots) do
		if entities.get_type(slot) == entities.types['playerstart'] then
			table.insert(playerstart_slots, slot)
		end
	end

	if #playerstart_slots > 0 then
		local selected_slot = playerstart_slots[math.random(#playerstart_slots)]
		nm_zombie.instances[zcn].pos = entities.get_pos(selected_slot)
		nm_zombie.instances[zcn].last_pos = nm_zombie.instances[zcn].pos
		for _, view_cn in ipairs(players.all()) do
			server.player_send_fake_spawn(view_cn, zcn, nm_zombie.instances[zcn].health, nm_zombie.instances[zcn].armour, nm_zombie.instances[zcn].gunselect)
		end
	end
end

function nm_zombie.hit(target_cn, actor_cn)
	if nm_zombie.running == 0 then return end
	if nm_zombie.instances[target_cn] ~= nil then
		local zcn = target_cn
		nm_zombie.instances[zcn].health = nm_zombie.instances[zcn].health - nm_zombie.instances[zcn].weakness
		if nm_zombie.instances[zcn].health < 0 then
			nm_zombie.instances[zcn].health = 0
		end
		if nm_zombie.instances[zcn].health < nm_zombie.need_regeneration_min_health then
			-- zombie got hit seriously and have to regenerate
			nm_zombie.instances[zcn].attack_iterations = 0
			nm_zombie.instances[zcn].state = nm_zombie.states.regenerate
		else
			if nm_zombie.instances[zcn].state == nm_zombie.states.search then
				-- zombie got attention
				nm_zombie.instances[zcn].state = nm_zombie.states.attack
				nm_zombie.instances[zcn].target_cn = actor_cn
			else
				-- zombie changes the target if the actor is nearest player
				nm_zombie.find_nearest_target(zcn, actor_cn)
			end
		end
	end
	if nm_zombie.instances[actor_cn] ~= nil and server.player_status_code(target_cn) ~= server.ALIVE then
		if #players.active() == 0 then
			-- zombies win
--TODO			messages.msg(-1, players.all(), nm_zombie.label, "Zombies win!", "red", {"info"})
			--server.changetime(0)
		else
			-- spectator.fspec(actor_cn, nm_zombie.lock_reason, nm_zombie.module)
			nm_zombie.create_zombie()
		end
	end
end

function nm_zombie.bite(zcn)
	local target_cn = nm_zombie.instances[zcn].target_cn
	for _, player_cn in ipairs(players.all()) do
		server.player_send_fake_shotfx(player_cn, zcn, nm_zombie.instances[zcn].gunselect, math.random(1000, 2000));
	end
	server.do_fake_damage(zcn, target_cn, nm_zombie.instances[zcn].strength, nm_zombie.instances[zcn].gunselect);
	nm_zombie.instances[zcn].health = nm_zombie.instances[zcn].health + nm_zombie.bite_regeneration
	if nm_zombie.instances[zcn].health > nm_zombie.max_health then
		nm_zombie.instances[zcn].health = nm_zombie.max_health
	end
	nm_zombie.instances[zcn].strength = nm_zombie.instances[zcn].strength + 1 -- the zombie gets stronger by biting!
	nm_zombie.instances[zcn].state = nm_zombie.states.search
	nm_zombie.instances[zcn].vel = { 0, 0, 0 }
	for zcn,instance in ipairs(nm_zombie.instances) do
		if instance.target_cn == target_cn then
			instance.target_cn = -1
			instance.state = nm_zombie.states.search
			instance.vel = { 0, 0, 0 }
		end
	end
end

function nm_zombie.find_nearest_target(zcn, new_target_cn)
	local nearest_cn = -1
	local nearest_dist = 100000
	for _, player_cn in ipairs(players.active()) do
		if server.player_status_code(player_cn) == server.ALIVE then
			local x, y, z = server.player_pos(player_cn)
			local dist = math.abs(nm_zombie.instances[zcn].pos[1] - x) + math.abs(nm_zombie.instances[zcn].pos[2] - y) + math.abs(nm_zombie.instances[zcn].pos[3] - z)
			if dist < nm_zombie.search_min_dist and dist < nearest_dist then
				nearest_cn = player_cn
			end
		end
	end
	if nearest_cn >= 0 and (new_target_cn == nil or (new_target_cn ~= nil and nearest_cn == new_target_cn)) then
		nm_zombie.instances[zcn].target_cn = nearest_cn
		return true
	end
	return false
end

function nm_zombie.is_valid_vcube(vcube)
	if maphack.profile[vcube[3]] == nil then
		return false
	elseif maphack.profile[vcube[3]][vcube[2]] == nil then
		return false
	elseif maphack.profile[vcube[3]][vcube[2]][vcube[1]] == nil then
		return false
	end

	return true
end

function nm_zombie.are_valid_vcubes(vcube)
	for x = 1, 3, 1 do
		for y = 1, 3, 1 do
			if maphack.profile[vcube[3]] == nil then
				return false
			elseif maphack.profile[vcube[3]][vcube[2] + ((y - 2) * maphack.distance)] == nil then
				return false
			elseif maphack.profile[vcube[3]][vcube[2] + ((y - 2) * maphack.distance)][vcube[1] + ((x - 2) * maphack.distance)] == nil then
				return false
			end
		end
	end
	return true
end

function nm_zombie.pos_to_vcube(pos)
	local vcube = {
		math.floor(pos[1]),
		math.floor(pos[2]),
		math.floor(pos[3])
	}
	for i = 1, 3, 1 do vcube[i] = vcube[i] - (vcube[i] % maphack.distance) end
	return vcube
end

function nm_zombie.get_next_vcube(pos, vel)
	local velocity = vel
--	if velocity[1] == 0 and velocity[2] == 0 and velocity[3] == 0 then
--		velocity = { math.random(10), math.random(10), 0 }
--	end
	local best_vcube = nm_zombie.pos_to_vcube(pos) -- initial: no movement
	local found = false
	-- check vcube layers in front of you, reducing the distance of the layers
	for velocity_length_dividor = 1, nm_zombie.search_max_velocity_length_dividor, 1 do
		local next_pos_by_velocity = {
			pos[1] + velocity[1] / velocity_length_dividor,
			pos[2] + velocity[2] / velocity_length_dividor,
			pos[3] + velocity[3] / velocity_length_dividor
		}
		local search_vcube = nm_zombie.pos_to_vcube(next_pos_by_velocity)
		-- center
		if nm_zombie.are_valid_vcubes(search_vcube) then
			best_vcube = search_vcube
			break
		end
		-- one step up in z... and search for the most center vcube, if exists
		for z = 1, 2, 1 do
			search_vcube[3] = search_vcube[3] + maphack.distance
			for x = 1, 4, 1 do
				for y = 1, 4, 1 do
					search_vcube[1] = best_vcube[1] - maphack.distance + (((x + nm_zombie.vcube_i) % 3) * maphack.distance) -- starting at the center x, then x+1, then x-1
					search_vcube[2] = best_vcube[2] - maphack.distance + (((y + nm_zombie.vcube_i) % 3) * maphack.distance) -- starting at the center y, then y+1, then y-1
					if nm_zombie.are_valid_vcubes(search_vcube) then
						best_vcube = search_vcube
						found = true
						break
					end
				end
			end
			if found then break end
		end
		if found then break end
	end
	if not found then
		nm_zombie.vcube_i = nm_zombie.vcube_i + 1
	end
	-- falling
	for x = 1, nm_zombie.search_max_falling_vcubes, 1 do
		local falling_vcube = { best_vcube[1], best_vcube[2], best_vcube[3] - maphack.distance }
		if nm_zombie.is_valid_vcube(falling_vcube) then
			best_vcube[3] = best_vcube[3] - maphack.distance
		else
			break
		end
	end
	return best_vcube
end

function nm_zombie.accelerate(zcn, acceleration)
	if
		math.abs(nm_zombie.instances[zcn].vel[1]) > nm_zombie.min_velocity or
		math.abs(nm_zombie.instances[zcn].vel[2]) > nm_zombie.min_velocity or
		math.abs(nm_zombie.instances[zcn].vel[3]) > nm_zombie.min_velocity
	then
		-- calc velocity vector length
		local vlen = math.sqrt(nm_zombie.instances[zcn].vel[1] * nm_zombie.instances[zcn].vel[1] + nm_zombie.instances[zcn].vel[2] * nm_zombie.instances[zcn].vel[2] + nm_zombie.instances[zcn].vel[3] * nm_zombie.instances[zcn].vel[3])
		if vlen < nm_zombie.search_max_vlen then
			for i = 1, 3, 1 do
				nm_zombie.instances[zcn].vel[i] = nm_zombie.instances[zcn].vel[i] * acceleration
				if math.abs(nm_zombie.instances[zcn].vel[i]) > nm_zombie.max_velocity then
					if nm_zombie.instances[zcn].vel[i] > 0 then
						nm_zombie.instances[zcn].vel[i] = nm_zombie.max_velocity
					else
						nm_zombie.instances[zcn].vel[i] = -nm_zombie.max_velocity
					end
				end
			end
		end
	else
		if nm_zombie.instances[zcn].not_moved_iterations > nm_zombie.max_not_moved_iterations then
			nm_zombie.instances[zcn].vel[1] = (math.random(20 * nm_zombie.init_velocity) / 10) - nm_zombie.init_velocity
			nm_zombie.instances[zcn].vel[2] = (math.random(20 * nm_zombie.init_velocity) / 10) - nm_zombie.init_velocity
			nm_zombie.instances[zcn].vel[3] = (math.random(20 * nm_zombie.init_velocity) / 10) - nm_zombie.init_velocity
			nm_zombie.instances[zcn].not_moved_iterations = 0
		else
			nm_zombie.instances[zcn].not_moved_iterations = nm_zombie.instances[zcn].not_moved_iterations + 1
		end
	end
end

function nm_zombie.interpolate_position(zcn, vel)
--	local next_pos = {}
--	for i = 1, 3, 1 do
--		next_pos[i] = nm_zombie.instances[zcn].last_pos[i] + vel[i]
--	end
	nm_zombie.instances[zcn].pos = nm_zombie.get_next_vcube(nm_zombie.instances[zcn].last_pos, vel)
end

function nm_zombie.set_actual_velocity(zcn)
	local vel = {}
	for i = 1, 3, 1 do
		vel[i] = nm_zombie.instances[zcn].pos[i] - nm_zombie.instances[zcn].last_pos[i]
	end
	local vel_length = math.sqrt(vel[1] * vel[1] + vel[2] * vel[2] + vel[3] * vel[3])
	if math.abs(vel_length) > 0.01 then
		for i = 1, 3, 1 do
			nm_zombie.instances[zcn].vel[i] = vel[i] / vel_length
		end
	end
end

function nm_zombie.pos_update(zcn)
	server.npos_pos_x = nm_zombie.instances[zcn].pos[1]
	server.npos_pos_y = nm_zombie.instances[zcn].pos[2]
	server.npos_pos_z = nm_zombie.instances[zcn].pos[3] + maphack.distance
	local vel = nm_zombie.instances[zcn].vel
	local magnitude = math.sqrt(vel[1] * vel[1] + vel[2] * vel[2] + vel[3] * vel[3])
	server.npos_vel_x = vel[1]
	server.npos_vel_y = vel[2]
	server.npos_vel_z = vel[3]
	server.npos_yaw = -math.atan2(vel[1], vel[2]) / nm_zombie.RAD;
	if magnitude > 0.01 then
		server.npos_pitch = math.asin(vel[3] / magnitude) / nm_zombie.RAD
	else
		server.npos_pitch = 0
	end
	server.npos_roll = 0
	if nm_zombie.instances[zcn].state == nm_zombie.states.regenerate then
		server.npos_move = 0
	else
		server.npos_move = 1
	end
	server.npos_strafe = 0
	for _, view_cn in ipairs(players.all()) do
		server.player_send_fake_npos(view_cn, zcn)
	end
	for i = 1, 3, 1 do nm_zombie.instances[zcn].last_pos[i] = nm_zombie.instances[zcn].pos[i] end
end

function nm_zombie.attack(zcn)
	nm_zombie.instances[zcn].attack_iterations = nm_zombie.instances[zcn].attack_iterations + 1
	if nm_zombie.instances[zcn].attack_iterations > nm_zombie.max_attack_iterations then
		nm_zombie.instances[zcn].attack_iterations = 0
		nm_zombie.instances[zcn].state = nm_zombie.states.search
	end
	-- calculate distance to target
	local x, y, z = server.player_pos(nm_zombie.instances[zcn].target_cn)
	local pos_to_target = { x - nm_zombie.instances[zcn].pos[1], y - nm_zombie.instances[zcn].pos[2], z - nm_zombie.instances[zcn].pos[3] }
	local dist_to_target = math.sqrt(pos_to_target[1] * pos_to_target[1] + pos_to_target[2] * pos_to_target[2] + pos_to_target[3] * pos_to_target[3])
	if dist_to_target < nm_zombie.bite_dist then
		nm_zombie.bite(zcn)
	else
		-- calculate new velocity vector to follow a player
		local next_pos = {}
		for i = 1, 3, 1 do
			next_pos[i] = nm_zombie.instances[zcn].last_pos[i] + nm_zombie.instances[zcn].vel[i]
		end
		local next_pos_to_target = { x - next_pos[1], y - next_pos[2], z - next_pos[3] }
		local changed_vel = {}
		for i = 1, 3, 1 do
			changed_vel[i] = nm_zombie.instances[zcn].vel[i] + (next_pos_to_target[i] / nm_zombie.path_change)
		end

		-- interpolate next position
		nm_zombie.interpolate_position(zcn, changed_vel)

		-- set actual velocity
		nm_zombie.set_actual_velocity(zcn)

		-- accelerate
		nm_zombie.accelerate(zcn, nm_zombie.attack_acceleration)
	end
end

function nm_zombie.search(zcn)
	if nm_zombie.find_nearest_target(zcn) then
		-- found target; attack state is effective at the next iteration
		nm_zombie.instances[zcn].state = nm_zombie.states.attack
	end
	-- stupid walk "forward" if possible, accelerate if nessesary
	
	-- interpolate next position
	nm_zombie.interpolate_position(zcn, nm_zombie.instances[zcn].vel)
	
	-- set actual velocity
	nm_zombie.set_actual_velocity(zcn)

	-- accelerate
	nm_zombie.accelerate(zcn, nm_zombie.search_acceleration)
end

function nm_zombie.regenerate(zcn)
	nm_zombie.instances[zcn].health = nm_zombie.instances[zcn].health + nm_zombie.regenerate_rate
	if nm_zombie.instances[zcn].health >= nm_zombie.regenerated_min_health then
		nm_zombie.instances[zcn].state = nm_zombie.states.search
	end
end

nm_zombie.actions = { nm_zombie.search, nm_zombie.attack, nm_zombie.regenerate }

function nm_zombie.init()
	if nm_zombie.enabled == 1 and nm_zombie.running == 0 then
		for i = 1, nm_zombie.initial_number_of_zombies, 1 do
			nm_zombie.create_zombie()
		end
		nm_zombie.running = 1
	end
end

function nm_zombie.destroy()
	if nm_zombie.running == 1 then
		for zcn,instance in ipairs(nm_zombie.instances) do
			nm_zombie.destroy_zombie(instance.zcn)
		end
		for _, player_cn in ipairs(players.all()) do
			spectator.funspec(player_cn, nm_zombie.lock_reason, nm_zombie.module)
		end
		nm_zombie.running = 0
	end
end

function nm_zombie.update()
	if nm_zombie.enabled == 1 and nm_zombie.running == 1 then
		for zcn,instance in ipairs(nm_zombie.instances) do
			nm_zombie.actions[instance.state](instance.zcn)
			nm_zombie.pos_update(instance.zcn)
		end
	end
end

function nm_zombie.update_action()
	if nm_zombie.enabled == 1 and nm_zombie.running == 1 then
		for zcn,instance in ipairs(nm_zombie.instances) do
			nm_zombie.actions[instance.state](instance.zcn)
		end
	end
end

function nm_zombie.update_pos()
	if nm_zombie.enabled == 1 and nm_zombie.running == 1 then
		for zcn,instance in ipairs(nm_zombie.instances) do
			nm_zombie.pos_update(instance.zcn)
		end
	end
end

function nm_zombie.print_debug(zcn)
	if nm_zombie.enabled == 1 and nm_zombie.running == 1 and nm_zombie.debug == 1 then
		for zcn,instance in ipairs(nm_zombie.instances) do
			local s
			if instance.state == nm_zombie.states.attack then
				s = "a"
			elseif instance.state == nm_zombie.states.search then
				s = "s"
			elseif instance.state == nm_zombie.states.regenerate then
				s = "r"
			else
				s = "-"
			end
			local name = string.format("%s|%i|%i|%i|%i", s, instance.target_cn, math.floor(instance.vel[1]*10), math.floor(instance.vel[2]*10), math.floor(instance.vel[3]*10))
			server.player_send_fake_rename(-1, instance.zcn, name)
		end
	end
end



--[[
		EVENTS
]]

event_listener.add("started", function()
	server.interval(30, nm_zombie.update)
	server.interval(500, nm_zombie.print_debug)
end)

event_listener.add("try_frag", nm_zombie.hit)

event_listener.add("intermission", nm_zombie.destroy)
event_listener.add("mapchange", nm_zombie.destroy)

-- server.event_handler("frag", function(target_cn, actor_cn, gun)
