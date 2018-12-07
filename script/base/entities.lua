--[[
	noobmod/entities.lua
	
	Author:			Hanack (Andreas Schaeffer)
	Created:		12-Mai-2012
	Last Modified:	11-Apr-2013
	License:		GPL3

	Functionalities:
		This module is a framework for map entities. It
		provides an easy API for creation and modification
		of entities. Also, it acts like a registry, so
		we can handle previously created entities because
		all values are stored.

]]



--[[
		API
]]

entities = {}
entities.default_slot_min = 2500 -- first 2500 slots are reserved by maps (siberia has > 2000 entities)
entities.slot_min = entities.default_slot_min
entities.slot_max = 8500 -- max slot number is 10000, but we leave some space for the maphack visualisation
entities.slots = {}
entities.map_slots = {}
entities.dirty = {}
entities.update_interval = 50
entities.max_updates = 50
entities.types = {}
entities.types['light'] = 1
entities.types['mapmodel'] = 2
entities.types['playerstart'] = 3 
entities.types['envmap'] = 4
entities.types['particles'] = 5
entities.types['mapsound'] = 6
entities.types['spotlight'] = 7
entities.types['shells'] = 8
entities.types['bullets'] = 9
entities.types['rockets'] = 10
entities.types['rounds'] = 11
entities.types['grenades'] = 12
entities.types['cartridges'] = 13
entities.types['health'] = 14
entities.types['health boost'] = 15
entities.types['green armour'] = 16
entities.types['yellow armour'] = 17
entities.types['quad'] = 18
entities.types['teleport'] = 19
entities.types['teledest'] = 20
entities.types['monster'] = 21
entities.types['carrot'] = 22
entities.types['jumppad'] = 23
entities.types['base'] = 24
entities.types['respawnpoint'] = 25
entities.types['box'] = 26
entities.types['barrel'] = 27
entities.types['platform'] = 28
entities.types['elevator'] = 29
entities.types['flag'] = 30
entities.names = {
	'light',
	'mapmodel',
	'playerstart',
	'envmap',
	'particles',
	'mapsound',
	'spotlight',
	'shells',
	'bullets',
	'rockets',
	'rounds',
	'grenades',
	'cartridges',
	'health',
	'health boost',
	'green armour',
	'yellow armour',
	'quad',
	'teleport',
	'teledest',
	'monster',
	'carrot',
	'jumppad',
	'base',
	'respawnpoint',
	'box',
	'barrel',
	'platform',
	'elevator',
	'flag'
}


-- registers the next free slot
function entities.register()
	for slot = entities.slot_min, entities.slot_max, 1 do
		if entities.slots[slot] == nil then
			entities.slots[slot] = {}
			return slot
		end
	end
end

-- frees a slot
function entities.free(slot)
	entities.slots[slot] = nil
	server.reset_entity(slot)
end

function entities.send_raw(slot, x, y, z, type, attr1, attr2, attr3, attr4, attr5)
	if slot == nil or x == nil or y == nil or z == nil or type == nil then return end
	server.ent_x = math.floor(tonumber(x))
	server.ent_y = math.floor(tonumber(y))
	server.ent_z = math.floor(tonumber(z))
	server.ent_type = math.floor(tonumber(type))
	server.ent_attr1 = math.floor(tonumber(attr1))
	server.ent_attr2 = math.floor(tonumber(attr2))
	server.ent_attr3 = math.floor(tonumber(attr3))
	server.ent_attr4 = math.floor(tonumber(attr4))
	server.ent_attr5 = math.floor(tonumber(attr5))
	server.send_entity(slot)
end

function entities.player_send_raw(cn, slot, x, y, z, type, attr1, attr2, attr3, attr4, attr5)
	if slot == nil or x == nil or y == nil or z == nil or type == nil then return end
	server.ent_x = math.floor(tonumber(x))
	server.ent_y = math.floor(tonumber(y))
	server.ent_z = math.floor(tonumber(z))
	server.ent_type = math.floor(tonumber(type))
	server.ent_attr1 = math.floor(tonumber(attr1))
	server.ent_attr2 = math.floor(tonumber(attr2))
	server.ent_attr3 = math.floor(tonumber(attr3))
	server.ent_attr4 = math.floor(tonumber(attr4))
	server.ent_attr5 = math.floor(tonumber(attr5))
	server.player_send_entity(cn, slot)
end

-- sends an entity to all clients
function entities.refresh(slot)
	if slot == nil or entities.slots[slot] == nil then return end
	server.ent_x = math.floor(entities.slots[slot]['pos'][1])
	server.ent_y = math.floor(entities.slots[slot]['pos'][2])
	server.ent_z = math.floor(entities.slots[slot]['pos'][3])
	server.ent_type = entities.slots[slot]['type']
	server.ent_attr1 = math.floor(entities.slots[slot]['attrs'][1])
	server.ent_attr2 = math.floor(entities.slots[slot]['attrs'][2])
	server.ent_attr3 = math.floor(entities.slots[slot]['attrs'][3])
	server.ent_attr4 = math.floor(entities.slots[slot]['attrs'][4])
	server.ent_attr5 = math.floor(entities.slots[slot]['attrs'][5])
	server.send_entity(slot)
end

-- sends an entity to a single client
-- Also, we have to ensure, that the values are int!
function entities.player_refresh(cn, slot)
	if entities.slots[slot] == nil then return end
	server.ent_x = math.floor(entities.slots[slot]['pos'][1])
	server.ent_y = math.floor(entities.slots[slot]['pos'][2])
	server.ent_z = math.floor(entities.slots[slot]['pos'][3])
	server.ent_type = entities.slots[slot]['type']
	server.ent_attr1 = math.floor(entities.slots[slot]['attrs'][1])
	server.ent_attr2 = math.floor(entities.slots[slot]['attrs'][2])
	server.ent_attr3 = math.floor(entities.slots[slot]['attrs'][3])
	server.ent_attr4 = math.floor(entities.slots[slot]['attrs'][4])
	server.ent_attr5 = math.floor(entities.slots[slot]['attrs'][5])
	server.player_send_entity(cn, slot)
end

-- adds regular map entities (don't mark as dirty)
function entities.add_map_entity(slot, type, x, y, z, attr1, attr2, attr3, attr4, attr5)
	if entities.slots[slot] ~= nil then return end
	entities.slots[slot] = {}
	entities.slots[slot]['type'] = type
	entities.slots[slot]['pos'] = { x, y, z }
	entities.slots[slot]['attrs'] = { attr1, attr2, attr3, attr4, attr5 }
	table.insert(entities.map_slots, slot)
end

-- removes regular map entities of the given type
function entities.remove_map_entities(type)
	for i, slot in ipairs(entities.map_slots) do
		if entities.get_type(slot) == type then
			entities.free(slot)
		end
	end
end

-- set slot values
function entities.set(slot, type, x, y, z, attr1, attr2, attr3, attr4, attr5)
	if entities.slots[slot] == nil then
		entities.slots[slot] = {}
	end
	entities.slots[slot]['type'] = type
	entities.slots[slot]['pos'] = { x, y, z }
	entities.slots[slot]['attrs'] = { attr1, attr2, attr3, attr4, attr5 }
	table.insert(entities.dirty, slot)
end

function entities.set_pos(slot, x, y, z)
	entities.slots[slot]['pos'] = { x, y, z }
	table.insert(entities.dirty, slot)
end

function entities.set_x(slot, x)
	entities.slots[slot]['pos'] = {
		x,
		entities.slots[slot]['pos'][2],
		entities.slots[slot]['pos'][3]
	}
	table.insert(entities.dirty, slot)
end

function entities.set_y(slot, y)
	entities.slots[slot]['pos'] = {
		entities.slots[slot]['pos'][1],
		y,
		entities.slots[slot]['pos'][3]
	}
	table.insert(entities.dirty, slot)
end

function entities.set_z(slot, z)
	entities.slots[slot]['pos'] = {
		entities.slots[slot]['pos'][1],
		entities.slots[slot]['pos'][2],
		z
	}
	table.insert(entities.dirty, slot)
end

function entities.get_pos(slot)
	if entities.slots[slot] == nil then return end
	return entities.slots[slot]['pos']
end

function entities.set_type(slot, type)
	entities.slots[slot]['type'] = type
	table.insert(entities.dirty, slot)
end

function entities.get_type(slot)
	if entities.slots[slot] == nil then return end
	return entities.slots[slot]['type']
end

function entities.set_attrs(slot, attr1, attr2, attr3, attr4, attr5)
	entities.slots[slot]['attrs'] = { attr1, attr2, attr3, attr4, attr5 }
	table.insert(entities.dirty, slot)
end

function entities.set_attr1(slot, attr1)
	entities.slots[slot]['attrs'] = {
		attr1,
		entities.slots[slot]['attrs'][2],
		entities.slots[slot]['attrs'][3],
		entities.slots[slot]['attrs'][4],
		entities.slots[slot]['attrs'][5]
	}
	table.insert(entities.dirty, slot)
end

function entities.set_attr2(slot, attr2)
	entities.slots[slot]['attrs'] = {
		entities.slots[slot]['attrs'][1],
		attr2,
		entities.slots[slot]['attrs'][3],
		entities.slots[slot]['attrs'][4],
		entities.slots[slot]['attrs'][5]
	}
	table.insert(entities.dirty, slot)
end

function entities.set_attr3(slot, attr3)
	entities.slots[slot]['attrs'] = {
		entities.slots[slot]['attrs'][1],
		entities.slots[slot]['attrs'][2],
		attr3,
		entities.slots[slot]['attrs'][4],
		entities.slots[slot]['attrs'][5]
	}
	table.insert(entities.dirty, slot)
end

function entities.set_attr4(slot, attr4)
	entities.slots[slot]['attrs'] = {
		entities.slots[slot]['attrs'][1],
		entities.slots[slot]['attrs'][2],
		entities.slots[slot]['attrs'][3],
		attr4,
		entities.slots[slot]['attrs'][5]
	}
	table.insert(entities.dirty, slot)
end

function entities.set_attr5(slot, attr5)
	entities.slots[slot]['attrs'] = {
		entities.slots[slot]['attrs'][1],
		entities.slots[slot]['attrs'][2],
		entities.slots[slot]['attrs'][3],
		entities.slots[slot]['attrs'][4],
		attr5,
	}
	table.insert(entities.dirty, slot)
end

function entities.get_attrs(slot)
	if entities.slots[slot] == nil then return end
	return entities.slots[slot]['attrs']
end

function entities.get_attr1(slot)
	if entities.slots[slot] == nil then return end
	return entities.slots[slot]['attrs'][1]
end

function entities.get_attr2(slot)
	if entities.slots[slot] == nil then return end
	return entities.slots[slot]['attrs'][2]
end

function entities.get_attr3(slot)
	if entities.slots[slot] == nil then return end
	return entities.slots[slot]['attrs'][3]
end

function entities.get_attr4(slot)
	if entities.slots[slot] == nil then return end
	return entities.slots[slot]['attrs'][4]
end

function entities.get_attr5(slot)
	if entities.slots[slot] == nil then return end
	return entities.slots[slot]['attrs'][5]
end

-- clears all entities in a range
-- default: clears all but not the regular map entities
function entities.clear(slot_min, slot_max)
	if slot_min == nil then slot_min = entities.slot_min end
	if slot_max == nil then slot_max = entities.slot_max end
	for slot = slot_min, slot_max, 1 do
		if entities.slots[slot] ~= nil then
			entities.free(slot)
		end
	end
end

-- updates all dirty slots
function entities.update()
	for i, slot in ipairs(entities.dirty) do
		entities.refresh(slot)
	end
	entities.dirty = {}
end

-- updates all slots for a single player
-- This function is limiting to max_updates per update_interval
function entities.player_update(cn, start_index)
	local max_index = start_index + entities.max_updates - 1
	if max_index > entities.slot_max then
		max_index = entities.slot_max
	end
	for slot = start_index, max_index, 1 do
		entities.player_refresh(cn, slot)
	end
	if max_index < entities.slot_max then
		server.sleep(entities.update_interval, function()
			entities.player_update(cn, max_index + 1)
		end)
	end
end

function entities.send_by_type(type)
	for i, slot in ipairs(entities.map_slots) do
		if entities.get_type(slot) == type then
			entities.refresh(slot)
		end
	end
	for slot = entities.slot_min, entities.slot_max do
		if entities.slots[slot] ~= nil and entities.get_type(slot) == type then
			entities.refresh(slot)
		end
	end
end

function entities.player_send_by_type(cn, type)
	for i, slot in ipairs(entities.map_slots) do
		if entities.get_type(slot) == type then
			entities.player_refresh(cn, slot)
		end
	end
	for slot = entities.slot_min, entities.slot_max do
		if entities.slots[slot] ~= nil and entities.get_type(slot) == type then
			entities.player_refresh(cn, slot)
		end
	end
end

function entities.count(type)
	local count = 0
	for i, slot in ipairs(entities.map_slots) do
		if entities.get_type(slot) == type then
			count = count + 1
		end
	end
	for slot = entities.slot_min, entities.slot_max do
		if entities.slots[slot] ~= nil and entities.get_type(slot) == type then
			count = count + 1
		end
	end
	return count
end

function entities.convert(type, target_type, no_dirty)
	for i, slot in ipairs(entities.map_slots) do
		if entities.get_type(slot) == type then
			entities.slots[slot]['type'] = target_type
			if not no_dirty then
				table.insert(entities.dirty, slot)
			end
		end
	end
	for slot = entities.slot_min, entities.slot_max do
		if entities.slots[slot] ~= nil and entities.get_type(slot) == type then
			entities.slots[slot]['type'] = target_type
			if not no_dirty then
				table.insert(entities.dirty, slot)
			end
		end
	end
end



--[[
		EVENTS
]]

local ent_started_handler
ent_started_handler = server.event_handler("started", function()
    -- automatic update of (dirty) entities
    server.interval(entities.update_interval, entities.update)
end)


local ent_finishedgame_handler
ent_finishedgame_handler = server.event_handler("finishedgame", function() -- we need this signal earlier than mapchange
	entities.slots = {}
	entities.dirty = {}
	entities.map_slots = {}
--	nm_messages.msg(-1, players.admins(), "ENTITIES", "================== FINISHEDGAME ====================", "green", {"hanack"})
end)

local ent_connect_handler
ent_connect_handler = server.event_handler("connect", function(cn, real)
	-- update for a single player only
	if real == true then
		entities.player_update(cn, entities.slot_min)
	end
end)

local ent_mapchange_handler
ent_mapchange_handler = server.event_handler("mapchange", function()
	entities.slot_min = entities.default_slot_min
end)


local ent_load_entitity_handler
ent_load_entitity_handler = server.event_handler("load_entitity", function(slot, type, x, y, z, attr1, attr2, attr3, attr4, attr5)
	entities.add_map_entity(slot, type, x, y, z, attr1, attr2, attr3, attr4, attr5)
	server.msg("ENTITIES " .. string.format("loadent slot: %i -- type: %i -- x: %i y: %i z: %i -- attr1: %i attr2: %i attr3: %i attr4: %i attr5: %i", slot, type, x, y, z, attr1, attr2, attr3, attr4, attr5))
        server.log("ENTITIES " .. string.format("loadent slot: %i -- type: %i -- x: %i y: %i z: %i -- attr1: %i attr2: %i attr3: %i attr4: %i attr5: %i", slot, type, x, y, z, attr1, attr2, attr3, attr4, attr5))

	if slot > entities.slot_min then
		entities.slot_min = slot + 100
	end
end)
