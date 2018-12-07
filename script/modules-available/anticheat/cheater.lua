--[[
	Script:			noobmod/cheater.lua
	Authors:		Hanack (Andreas Schaeffer)
	Created:		24-Okt-2010
	Last Modified:	09-Apr-2013
	License:		GPL3

	Description:
		Framework for anti cheats
		Detection of anonymous proxies
		Detection of same ips
		Name bans
		IP bans
		Recording sessions
		
	TODO:
		Move ip ban and name ban to nl_kick

]]



require "geoip"



--[[
		API
]]

cheater = {}
cheater.label = "ANTICHEAT"
cheater.rename = 0
cheater.pbox = {}
cheater.pbox.time = 120
cheater.kick = {}
cheater.kick.time = 60*60
cheater.ban = {}
cheater.ban.time = 24*60*60
cheater.ban.delay = 30000
cheater.nameban = {}
cheater.ipban = {}
cheater.recordings = {}
cheater.kill = 0
cheater.takeflag = 1
cheater.RENAME_NAME = "CHEATER"
cheater.timeoverwarning_interval = 5000
cheater.min_timeoverwarning = 45 -- warning 45 seconds before intermission
cheater.map_states = {}
cheater.map_states.recording = {}
cheater.map_states.recording.NEW = 1
cheater.map_states.recording.ONLY_WARNINGS = 3
cheater.map_states.recording.READY = 5
cheater.undercover = {}
cheater.undercover_agents = { -- TODO: remove
	"Hanack",
	"-NC-Istha",
	"westernheld",
	"antiprecision",
	"-NC-Andreas",
	"-NC-Panda",
	"-NC-Nuster",
	"{GSTF}micha",
	"{GSTF}Laslo69",
	"{GSTF}Hanni",
	"superTUX",
	"-NC-mozn",
	"KeksDrache",
	"ShadowDragon",
	"Shaun",
	"Braten",
	"Hankus",
	"-NC-Punky",
	"SomeLady",
	"-NC-angst",
	"elPresidente",
	"nothing",
	"PeterPenacka",
	"-NC-Cerez",
	"Morphix",
	"BanShee",
	"Charlotte",
	"Nick",
	"-NC-Amaiur",
	"ToP|Rexus",
	"Flo",
	"DaveX",
	"NuckChorris",
	"|SK|boulax",
	"TheAssassin"
}
cheater.profile_key = {}
cheater.profile_key['ffa'] = 'efficiency'
cheater.profile_key['coop edit'] = nil
cheater.profile_key['teamplay'] = 'efficiency'
cheater.profile_key['instagib'] = 'insta ctf'
cheater.profile_key['instagib team'] = 'insta ctf'
cheater.profile_key['efficiency'] = 'efficiency'
cheater.profile_key['efficiency team'] = 'efficiency'
cheater.profile_key['tactics'] = 'efficiency'
cheater.profile_key['tactics team'] = 'efficiency'
cheater.profile_key['capture'] = 'efficiency'
cheater.profile_key['regen capture'] = 'efficiency'
cheater.profile_key['ctf'] = 'efficiency'
cheater.profile_key['insta ctf'] = 'insta ctf'
cheater.profile_key['collect'] = 'efficiency'
cheater.profile_key['insta collect'] = 'insta ctf'
cheater.profile_key['protect'] = 'efficiency'
cheater.profile_key['insta protect'] = 'insta ctf'
cheater.profile_key['hold'] = 'efficiency'
cheater.profile_key['insta hold'] = 'insta ctf'
cheater.profile_key['efficiency ctf'] = 'efficiency'
cheater.profile_key['efficiency collect'] = 'efficiency'
cheater.profile_key['efficiency protect'] = 'efficiency'
cheater.profile_key['efficiency hold'] = 'efficiency'



function cheater.set_map_state(map, statename, state)
	db.insert_or_update("mapstate", { map=map, statename=statename, state=state }, string.format("map='%s' and statename='%s'", map, statename))
end

function cheater.get_map_state(map, statename)
	local result = db.select("mapstate", { "state" }, string.format("map='%s' and statename='%s'", map, statename) )
	if #result == 0 then
		nm_messages.msg(-1, players.admins(), cheater.label, string.format("No red<%s> state found for map %s. Set state: orange<#cheater mapstate %s %s value>", statename, map, map, statename), "red", {"debug"})
		return 0
	else
		return tonumber(result[1]['state'])
	end
end

-- checks if a player (cn) has the same ip as other players
function cheater.check_same_ip(cn)
	for _, player_cn in ipairs(players.all()) do
		if cn ~= player_cn and server.player_ip(cn) == server.player_ip(player_cn) then
			nm_messages.msg(-1, players.admins(), cheater.label, string.format("displayname<%i> has same ip as displayname<%i>.", cn, player_cn), "red", {"warn", "log" } )
		end
	end
end

-- checks if a player (cn) has been connected via an anonymous proxy
function cheater.check_ap(cn)
--	local country = geoip.ip_to_country(server.player_ip(cn))
--	if country == "Anonymous Proxy" then
--		cheater.autokick(cn, "ap", "Anonymous Proxy")
--	end
end

-- checks if a player (cn) got a permanent name ban
function cheater.check_nameban(cn)
--	for k, player_name in pairs(cheater.nameban) do
--		if server.player_name(cn) == player_name then
--			cheater.autokick(cn, "nameban", "Name was banned.")
--		end 
--	end
end

-- checks if a player (cn) got a permanent ip ban
function cheater.check_ipban(cn)
--	for k, player_ip in pairs(cheater.ipban) do
--		if server.player_ip(cn) == player_ip then
--			cheater.autokick(cn, "ipban", "IP was banned.")
--		end 
--	end
end

-- procedure for automatic kicks:
-- log, database, (rename), kick
function cheater.autokick(cn, who, reason, full_reason)
--	cn = tonumber(cn)
--	if utils.valid_cn(cn) then
--		if full_reason == nil then
--			full_reason = reason
--		end
--		if cheater.rename == 1 then
--			server.player_rename(cn, cheater.RENAME_NAME, false)
--			server.sleep(100, function()
--				kickban.kick(cn, cheater.ban.time, -1, reason)
--			end)
--		else
--			kickban.kick(cn, cheater.ban.time, -1, reason)
--		end
--		local ip = server.player_ip(cn)
--		nm_messages.msg(-1, {}, cheater.label, string.format("Automatically kicked %s (CN: %i IP: %s) for %s", who, cn, ip, reason), "grey", {"log", "irc" } )
--	else
--		if cn ~= nil then
--			nm_messages.msg(-1, players.admins(), cheater.label, string.format("red<%s caused a problem in cheater.autokick()>: Invalid cn %i. Autokick reason was: %s", who, cn, reason), "red", {"error"})
--		else
--			nm_messages.msg(-1, players.admins(), cheater.label, string.format("red<%s caused a problem in cheater.autokick()>: cn was nil. Autokick reason was: %s", who, reason), "red", {"error"})
--		end
--	end
end

-- starts recording sessions
function cheater.start_recording(name)
	if not cheater.is_recording() then
		nm_messages.msg(-1, players.all(), cheater.label, "red<=========== RECORDING STARTED ===========>", "red", {"info", "log" })
	end
	cheater.recordings[name] = 1
end

-- stops recording sessions
function cheater.stop_recording(name)
	local is_already_recording = cheater.is_recording()
	cheater.recordings[name] = nil
	if is_already_recording and not cheater.is_recording() then
		nm_messages.msg(-1, players.all(), cheater.label, "red<=========== RECORDING STOPPED ===========>", "red", {"info", "log" })
	end
end

-- returns true, if a recording session has been started
function cheater.is_recording()
	local is_recording = false
	for k,v in pairs(cheater.recordings) do
		is_recording = true
		break
	end
	return is_recording
end

function cheater.is_undercover(cn)
--	if cheater.undercover[cn] == nil then
--		local player = nmcore.return_player(cn)
--		local user_id = tonumber(player["nm_userid"])
--		if user_id == 0 then return false end -- too early (no user_id available)
--		local result = db.select("nm5_undercover", { "uid" }, string.format("uid='%i'", user_id) )
--		if #result > 0 then
--			cheater.undercover[cn] = 1
--			nm_messages.msg(-1, players.admins(), cheater.label, string.format("  displayname<%i> orange<is starting recording profiles! Thank you for your support!>", cn), "green", { "info", "log" } )
--			return true
--		else
--			cheater.undercover[cn] = 0
--			return false
--		end
--	else
--		if cheater.undercover[cn] == 1 then
--			return true
--		else
--			return false
--		end
--	end
    return true
end

function cheater.add_undercover(cn)
	if cheater.is_undercover(cn) then return end -- already undercover
	cheater.undercover[cn] = 1
--	local player = nmcore.return_player(cn)
--	local user_id = tonumber(player["nm_userid"])
--	db.insert("nm5_undercover", { uid=user_id} )
--	nm_messages.msg(-1, players.admins(), cheater.label, string.format("displayname<%i> has been added to the list of undercover agents! green<Welcome!>", cn), "green", {"info"})
end

function cheater.remove_undercover(cn)
--	if not cheater.is_undercover(cn) then return end -- already not undercover
--	cheater.undercover[cn] = 0
--	local player = nmcore.return_player(cn)
--	local user_id = tonumber(player["nm_userid"])
--	db.delete("nm5_undercover", string.format("uid=%i", user_id))
--	nm_messages.msg(-1, players.admins(), cheater.label, string.format("displayname<%i> has been removed from the list of undercover agents! green<Welcome!>", cn), "green", {"info"})
end

-- TODO: instead of generation this on each request, make a cache in a permanent mutable list
function cheater.get_undercovers()
	local undercovers = {}
	for i,cn in ipairs(players.all()) do
		if cheater.undercover[cn] == 1 then
			table.insert(undercovers, cn)
		end
	end
	return undercovers
end

-- sends a message to all players if the end of a recording session is near (time over)
function cheater.timeoverwarning()
	if cheater.is_recording() then
		local time_left = math.floor((server.gamelimit - server.gamemillis) / 1000)
		if time_left < cheater.min_timeoverwarning and time_left > 0 then
			nm_messages.msg(-1, players.all(), cheater.label, "", "red", {"debug"})
			nm_messages.msg(-1, players.all(), cheater.label, "", "red", {"debug"})
			nm_messages.msg(-1, players.all(), cheater.label, "", "red", {"debug"})
			nm_messages.msg(-1, players.all(), cheater.label, string.format("red<Time is over in> white<%i> red<seconds>", time_left), "red", {"info"})
			nm_messages.msg(-1, players.all(), cheater.label, "", "red", {"debug"})
		end
	end
end



--[[
		EVENTS
]]

event_listener.add("started", function(cn)
	-- send a warning if the time is over (for recording)
	server.interval(cheater.timeoverwarning_interval, cheater.timeoverwarning)
end)

event_listener.add("connect", function(cn, real)
	if real == true then
--		cheater.check_ap(cn)
--		cheater.check_same_ip(cn)
--		cheater.check_nameban(cn)
--		cheater.check_ipban(cn)
	end
end)

event_listener.add("disconnect", function(cn)
	cheater.undercover[cn] = nil
end)

event_listener.add("damage", function(target_cn, actor_cn, damage, gun)
	-- no damage on recording sessions
	if target_cn == nil or actor_cn == nil or target_cn == actor_cn or cheater.kill == 1 then return end
	if cheater.is_recording() then
		nm_messages.msg(-1, {actor_cn}, cheater.label, "red<You cannot damage other players while recording!>", "red", {"debug"})
		return -1
	end
end)

--[[
server.event_handler("takeflag_request", function(cn)
	if cheater.takeflag == 0 then return end
	if cheater.is_recording() then
		nm_messages.msg(-1, {cn}, cheater.label, "red<You cannot take the flag while recording!>", "red", {"debug"})
		return false
	end
end)
]]
