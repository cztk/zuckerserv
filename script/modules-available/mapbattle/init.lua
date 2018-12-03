--[[
    Vote for map at intermission 
    By piernov
]]

mapbattle = {}
mapbattle.delay = 1000 -- Time to wait before starting mapbattle
mapbattle.timeout = server.intermission_time -- Time to wait for votes
mapbattle.first = true
mapbattle.lastindex = 1

math.randomseed(os.time())
math.random(); math.random(); math.random()

function mapbattle.clean()
    mapbattle.votes = { {}, {}, {} }
    mapbattle.maps = {}
    mapbattle.map_changed = false
    mapbattle.running = false
end

function mapbattle.max(t, fn)
    if #t == 0 then return nil, nil end
    local key, value = 1, t[1]
    for i = 2, #t do
        if fn(value, t[i]) then
            key, value = i, t[i]
        end
    end
    return key, value
end

function mapbattle.get_random_map(mode)

    local maps= {}
    local hay = map_rotation.get_map_rotation(mode)[mode]
    for k,v in pairs(hay) do
        if v ~= server.map then        
          table.insert(maps, k)
        end
    end
    -- now you can reliably return a random key
    local result = hay[maps[math.random(#maps)]]
        
    return result
end

function mapbattle.get_next(mode)
    local maps= {}
    local hay = map_rotation.get_map_rotation(mode)[mode]
    for k,v in pairs(hay) do
        if v ~= server.map then
          table.insert(maps, k)
        end
    end
    mapbattle.lastindex = mapbattle.lastindex + 1
    if mapbattle.lastindex > #maps then
        mapbattle.lastindex = 1
    end
    local result = hay[maps[mapbattle.lastindex]]
    return result

--    local maps = map_rotation.get_map_rotation(mode)[mode]
--	local playing = 1
--    for k,v in ipairs(maps) do
--        if v == server.map then 
--            playing = k
--        end
--    end
--    if playing > (table_size(maps)-num) then playing = 1 end
--    return maps[playing+num]
end

function mapbattle.winner()
    local winindex, winvalue = mapbattle.max({table_size(mapbattle.votes[1]), table_size(mapbattle.votes[2]), table_size(mapbattle.votes[3])}, function(a,b) return a < b end)
    return mapbattle.maps[winindex]
    --[[
    if table_size(mapbattle.votes[1]) >= table_size(mapbattle.votes[2]) then
        return mapbattle.maps[1]
    else
        return mapbattle.maps[2]
    end
    ]]--
end

function mapbattle.process_vote(cn, vote)
    if vote ~= "1" and vote ~= "2" and vote ~= "3" then return end
    vote = tonumber(vote)

    if table_count(server.players(), cn) ~= 1 then
        server.player_msg(cn, "mapbattle_cant_vote")
        return false
    else
        if mapbattle.votes[1][cn] == true or mapbattle.votes[2][cn] == true or mapbattle.votes[3][cn] then
            server.player_msg(cn, "mapbattle_vote_already")
            return false
        end
        mapbattle.votes[vote][cn] = true
        server.msg("mapbattle_vote_ok", { name = server.player_displayname(cn), mapname = mapbattle.maps[vote] })
        return true
    end
end

function mapbattle.start(map1, map2, map3, mode)
    mapbattle.clean()
    mapbattle.first = false
    mapbattle.maps = { map1, map2, map3 }
        if map1 == map2 then
            map2 = mapbattle.get_next(mode)
        end
        while map3 == map1 or map3 == map2 do
            map3 = mapbattle.get_random_map(mode)
        end
	server.msg("mapbattle_vote", {map1 = mapbattle.maps[1], map2 = mapbattle.maps[2], map3 = mapbattle.maps[3]})
	mapbattle.running = true
	server.sleep(mapbattle.timeout, function()
        mapbattle.running = false
		if not mapbattle.map_changed then
                    server.msg("mapbattle_winner", { mapbattle_winner = mapbattle.winner()})
                    server.next_map = mapbattle.winner()
                    mapbattle.map_changed = true
		end
	end)
end

server.event_handler("setnextgame", function()
    if true == mapbattle.first then
        server.next_map = "reissen"
        mapbattle.start(map_rotation.get_map_name(server.gamemode), mapbattle.get_next(server.gamemode), mapbattle.get_random_map(server.gamemode), server.gamemode)
    else
        server.next_mode = server.gamemode
        server.next_map = mapbattle.winner()
    end
    return -1
end)

server.event_handler("intermission", function() 
    server.sleep(mapbattle.delay, function()
        local s = server.votedbestmap()
        if s == nil or s == '' then
            s = map_rotation.get_map_name(server.gamemode)
        end
        mapbattle.start(s, mapbattle.get_next(server.gamemode), mapbattle.get_random_map(server.gamemode), server.gamemode)
    end)
end)

server.event_handler("mapchange", function()
    mapbattle.map_changed = true
end)

server.event_handler("text", function(cn, text)
    if mapbattle.map_changed or not mapbattle.running then return end
    if mapbattle.process_vote(cn, text) then return -1 end
end)
