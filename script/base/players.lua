--[[
	Script:			noobmod/players.lua
	Authors:		Hanack (Andreas Schaeffer)
					Hankus (Derk Händel)
	Created:		23-Okt-2010
	Last Change:	19-Apr-2013
	License:		GPL3

	Funktion:
		Stellt verschiedene Funktionen zur Verfügung, um auf Spielerlisten
		zu operieren - quasi wie Mengenoperationen auf Spielerlisten

	API-Methoden:
		players.all()
			Gibt eine Liste von CNs von allen verbundenen Clients zurück
		players.active()
			Gibt eine Liste von CNs von aktiv spielenden Clients zurück
		players.spectators()
			Gibt eine Liste von CNs von allen Spectators zurück
		players.bots()
			Gibt eine Liste von CNs von allen Bots zurück
		players.admins()
			Gibt eine Liste von CNs von allen Admins zurück
		players.not_admins()
			Gibt eine Liste von CNs von allen außer Admins zurück
		players.masters()
			Gibt eine Liste von CNs von allen Masters zurück
		players.users()
			Gibt eine Liste von CNs von allen (registrierten) Benutzern zurück
		players.registered()
			Gibt eine Liste von CNs von allen registrierten Spielern (admin und user) zurück
		players.normal()
			Gibt eine Liste von CNs von allen (unregistrierten) Spielern zurück
		players.except(players, except_cn)
			Gibt eine Liste zurück, in der der Spieler mit der angegebenen CN entfernt wurde

]]


--[[
		API
]]

players = {}
players.bots = server.bots
players.fake_cns = {}

--function commands.listall(cn)
--	for _, ocn in pairs(server.clients()) do
--		messages.msg(cn, {cn}, "PLAYERS", string.format("%s", tostring(ocn)), "red", {"info", "irc"})
--	end
--end

players.all = function()
	local newlist = {}
	for _, cn in pairs(server.clients()) do
		table.insert(newlist, cn)
	end
	return newlist
end

-- returns a table containing cns of all admins
players.admins = function()
	local player
	local newlist = {}
	for _, cn in pairs(server.clients()) do
--		player = nmcore.return_player(cn)
--		if player.access >= admin_access then
                table.insert(newlist, cn)
--                end
	end
	return newlist
end

-- returns a table containing cns of all admins
players.not_admins = function()
	local player
	local newlist = {}
	for _, cn in pairs(server.clients()) do
--		player = nmcore.return_player(cn)
--		if player.access < admin_access then table.insert(newlist, cn) end
	end
	return newlist
end

-- returns a table containing cns of all players with adminauthkey
players.authadmins = function()
	local player
	local newlist = {}
--	for _, cn in pairs(server.clients()) do
--		player = nmcore.return_player(cn)
--		if player.kickstatus == 'admin' then table.insert(newlist, cn) end
--	end
	return newlist
end

-- returns a table containing cns of all masters
players.masters = function()
	local player
	local newlist = {}
--	for _, cn in pairs(server.clients()) do
--		player = nmcore.return_player(cn)
--		if player.access < admin_access and player.access >= master_access then table.insert(newlist, cn) end
--	end
	return newlist
end

-- returns a table containing cns of all masters and admins
players.admins_and_masters = function()
	local player
	local newlist = {}
--	for _, cn in pairs(server.clients()) do
--		player = nmcore.return_player(cn)
--		if player.access >= master_access then table.insert(newlist, cn) end
--	end
	return newlist
end

-- returns a table containing cns of all privileged players
players.priv = function()
	local player
	local newlist = {}
	for _, cn in pairs(server.clients()) do
--		player = nmcore.return_player(cn)
--		if 	player.kickstatus == "admin" or
--			player.kickstatus == "auth" then
			table.insert(newlist, cn)
--		end
	end
	return newlist
end

-- returns a table containing cns of all unprivileged players
players.nopriv = function()
	local player
	local newlist = {}
--	for _, cn in pairs(server.clients()) do
--		player = nmcore.return_player(cn)
--		if 	player.kickstatus == "none" then
--			table.insert(newlist, cn)
--		end
--	end
	return newlist
end

-- returns a table containing cns of all users
players.users = function()
	local player
	local newlist = {}
	for _, cn in pairs(server.clients()) do
--		player = nmcore.return_player(cn)
--		if player.access < master_access and player.access >= user_access then 
          table.insert(newlist, cn)
--              end
	end
	return newlist
end

-- returns a table containing cns of all registered players
players.registered = function()
	local player
	local newlist = {}
	for _, cn in pairs(server.clients()) do
--		player = nmcore.return_player(cn)
--		if player.status == "user" or player.status == "serverowner" or player.status == "masteradmin" or player.status == "admin" or player.status == "honoraryadmin" then table.insert(newlist, cn) end
	end
	return newlist
end

-- returns a table containing cns of all users
players.normal = function()
	local player
	local newlist = {}
	for _, cn in pairs(server.clients()) do
		player = nmcore.return_player(cn)
		if player.access < user_access then table.insert(newlist, cn) end
	end
	return newlist
end

-- returns a table containing all players not in limbo and spectator
players.active = function()
	local newlist = {}
	for _, cn in pairs(server.players()) do
		if not server.player_is_spy(cn) then table.insert(newlist, cn) end
	end
	return newlist
end

-- returns a table containing all players not in limbo
players.spectators = function()
	local newlist = {}
	for _, cn in pairs(server.clients()) do
		if server.player_status_code(cn) == server.SPECTATOR then
			if not server.player_is_spy(cn) then
				table.insert(newlist, cn)
			end
		end
	end
	return newlist
end

-- returns a table containing cns of all players in the limbo
players.limbo = function( opt_in, opt_out )
	local player
	local newlist = {}
	local is_in = false
	local is_out = false
	if not opt_in then opt_in = { "ban","name","tag","full" } end
	if not opt_out then opt_out = {} end
	for _, cn in pairs(server.clients()) do
		if server.player_is_spy(cn) == true then
			player = nmcore.return_player(cn)
			local is_in = false
			local is_out = false
			for reason,_ in pairs(player.fspy) do
				if utils.contains(opt_in, reason) then is_in = true end
				if utils.contains(opt_out, reason) then is_out = true end
			end
			--messages.msg(cn, players.all(), "PLAYERS", string.format("is_in=%s, is_out=%s",tostring(is_in),tostring(is_out)), "red", { "info" })
			if is_in==true and is_out==false then
				table.insert(newlist, cn)
			end
		end
	end
	return newlist
end

-- removes a player from a given list
players.except = function(players, except_cn)
	local newlist = {}
	for _, cn in pairs(players) do
		if cn ~= except_cn then table.insert(newlist, cn) end
	end
	return newlist
end

-- returns the next free cn
function players.next_free_cn()
	local fcn = 0
	while used_cn(fcn) and fcn < 127 do fcn = fcn + 1 end
	if fcn < 128 then
		return fcn
	else
		return -1
	end
end

-- returns the highest used cn
function players.highest_cn()
	local fcn = 127
	while not used_cn(fcn) and fcn >= 0 do fcn = fcn - 1 end
	if fcn >= 0 then
		return fcn
	else
		return -1
	end
end

-- returns a random active cn
function players.random_active_cn(team)
	local active = players.active()
	if #active == 0 then return -1 end
	if team == nil then
		return active[math.random(#active)]
	else
		local team_players = {}
		for _, cn in pairs(active) do
			if server.player_team(cn) == team then
				table.insert(team_players, cn)
			end
		end
		if #team_players > 0 then
			return team_players[math.random(#team_players)]
		else
			return -1
		end
	end
end

function players.get_fake_cn()
	local fcn = 0
	while (used_cn(fcn) or players.fake_cns[fcn] ~= nil) and fcn < 127 do fcn = fcn + 1 end
	if fcn < 128 then
		players.fake_cns[fcn] = 1
		server.block_cn(fcn)
		return fcn
	else
		return -1
	end
end

function players.free_fake_cn(fcn)
	if players.fake_cns[fcn] ~= nil then
		players.fake_cns[fcn] = nil
		server.unblock_cn(fcn)
	end
end


