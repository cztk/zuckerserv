--[[
	Script:			noobmod/maphack.lua
	Authors:		Hanack (Andreas Schaeffer)
	Created:		24-Apr-2012
	Last Change:	11-Apr-2013
	License:		GPL3

	Funktion:
		Erkennt MapHacker anhand von ungueltigen Positionen. Es werden (wie bei
		der Speedhack-Detection und der Minmax-Detection) pro Map Profile gebildet.
		
		* Ein Profil enthaelt gueltige Punkte, die ueber die Map zerstreut liegen.
		* Entfernung von einem Punkt zu einem anderen Punkt (Rastergroesse): 2 Einheiten in x, y und z
		* Ein Spieler bekommt Maluspunkte, wenn er eine Zeitlang keinen der Punkte ueberlaufen hat

	API-Methoden:
		maphack.clear_malus(cn)
			Malus Punkte des Spielers zuruecksetzen
		maphack.add_malus(cn)
			Spieler bekommt einen Malus Punkt
		
	Commands:
		#maphack recording 1
			Aufnahme starten
		#maphack recording 0
			Aufnahme stoppen
		#maphack delete
			Profil fuer die Map und den Mode loeschen
		#maphack clear
			Profilwerte aus dem Speicher entfernen (nutzlos)
		#maphack distance <value>
			Groesse der Profil-Wuerfel
			

]]



--[[
		API
]]

maphack = {}
maphack.label = "MAPHACK"
maphack.enabled = 1
maphack.protected = 1 -- change this, if you want to do bad things like deleting the profiles
maphack.only_warnings = 1
maphack.silent = 0
maphack.distance = 10
maphack.recording = 0
maphack.testing = 0
maphack.visualisation = 0 -- TODO: change this if entities are ready
maphack.check_interval = 100
maphack.record_interval = 50
maphack.visualisation_interval = 50
maphack.pointleader_interval = 3000
maphack.pointleader_interval2 = 30000
maphack.reverse = 1
maphack.vxdist = 2
maphack.vydist = 2
maphack.vzdist = 2
maphack.above_dist = 12
maphack.above_dist_z = 15
maphack.default_warnmalus = 10
maphack.default_banmalus = 20
maphack.warnmalus = 10
maphack.banmalus = 20
maphack.profile = {} -- tree: z -> y -> x
maphack.profile_size = 0
maphack.load_carrots = 0
maphack.warn_level = {}
maphack.carrots = {}
maphack.carrots_id = {}
maphack.carrots_min = 8501
maphack.carrots_max = 9999
maphack.carrots_cur = maphack.carrots_min
maphack.carrots_x = 5
maphack.carrots_y = 5
maphack.carrots_z = 10
maphack.carrots_enttype = 22 -- 22: carrot; 2: mapmodel
maphack.carrots_entattr2 = 0 -- 23: carrot
maphack.malus = {}
maphack.falling = {}
maphack.undercover = 1
maphack.points = {}
maphack.pointleader = -1
maphack.startpoints = 0



function maphack.set_malus(warnmalus, banmalus)
	db.insert_or_update("maphack_malus", { map=server.map, mode=cheater.profile_key[server.gamemode], warn=warnmalus, kick=banmalus }, string.format("map='%s' and mode='%s'",server.map, cheater.profile_key[server.gamemode]))
end

function maphack.reset_malus()
	maphack.warnmalus = 3
	maphack.banmalus = 6
	maphack.set_malus(maphack.warnmalus, maphack.banmalus)
end

-- maluspunkte zuruecksetzen
function maphack.clear_malus(cn)
	cn = tonumber(cn)
	maphack.malus[cn] = 0
end

-- maluspunkt hinzufuegen
function maphack.add_malus(cn)
	cn = tonumber(cn)
	if maphack.malus[cn] == nil then
		maphack.malus[cn] = 0
	end
	local add_points = 1
	if maphack.falling[cn] ~= nil then
		add_points = 1 / (maphack.falling[cn][2] + 1)
	end
	local last_malus_points = math.floor(maphack.malus[cn])
	maphack.malus[cn] = maphack.malus[cn] + add_points
	malus_points = math.floor(maphack.malus[cn])
	if malus_points > 1 and malus_points > last_malus_points then
		nm_messages.msg(-1, players.admins(), maphack.label, string.format("%s (%i) has %i malus points", server.player_name(cn), cn, malus_points), "grey", {"verbose"})
	end
	
	if maphack.testing == 1 and malus_points >= maphack.warnmalus then
		maphack.warnmalus = malus_points + 1
		maphack.banmalus = malus_points * 2
		maphack.set_malus(maphack.warnmalus, maphack.banmalus)
		nm_messages.msg(-1, players.admins(), maphack.label, string.format("%s (%i) set new maphack malus limits! white<warn malus:> %i white<ban malus:> %i", server.player_name(cn), cn, maphack.warnmalus, maphack.banmalus), "grey", {"debug"})
		return
	end
	
	if malus_points == maphack.warnmalus then
		if maphack.silent == 0 then
			nm_messages.msg(-1, players.admins(), maphack.label, string.format("%s (%i) is *possibly* map hacking", server.player_name(cn), cn), "orange", {"warn"})
		end
	else
		if malus_points >= maphack.banmalus then
			if maphack.only_warnings == 1 then
				if maphack.warn_level[cn] == nil then
					maphack.warn_level[cn] = 1
				else
					maphack.warn_level[cn] = maphack.warn_level[cn] + 1
					if maphack.warn_level[cn] % 20 == 0 and maphack.silent == 0 then
						nm_messages.msg(-1, players.admins(), maphack.label, string.format("%s (%i) is *possibly* map hacking", server.player_name(cn), cn), "orange", {"warn"})
					end
				end
			else
				nm_messages.msg(-1, players.admins(), "CHEATER", string.format("Automatically kicked %s (%i) because of map hacking", server.player_name(cn), cn), "red", { "error", "log", "irc" })
--TODO				cheater.autokick(cn, "maphack", "Maphacking/Flyhacking")
			end
		end
	end
	
end

function maphack.set_falling_state(cn, z)
	if maphack.falling[cn] == nil then
		maphack.falling[cn] = {}
		maphack.falling[cn][1] = z
		maphack.falling[cn][2] = 0
		return
	end
	if maphack.falling[cn][1] > z then
		maphack.falling[cn][2] = maphack.falling[cn][2] + 1
	else
		maphack.falling[cn][2] = 0
	end
	maphack.falling[cn][1] = z
end

-- setzt profil zurueck
function maphack.clear_profile()
	maphack.profile_size = 0
	maphack.profile = {}
	maphack.malus = {}
end

-- loescht ein profil
function maphack.delete_profile()
	if maphack.protected ~= 0 then return end
	maphack.clear_profile()
	db.delete("maphack", string.format("map='%s' and mode='%s'", server.map, cheater.profile_key[server.gamemode]))
end

-- laedt profil aus der datenbank
function maphack.load_profile(force)
	if maphack.enabled == 0 and force ~= nil then return end -- do not load maphack profile if maphack is disabled
	if cheater.profile_key[server.gamemode] == nil then
		nm_messages.msg(-1, players.admins(), maphack.label, string.format("Not loading maphack profile for game mode %s", server.gamemode), "grey", {"debug"})
		return
	end
	
	-- nm_messages.verbose(-1, players.admins(), maphack.label, string.format("Loading maphack profile for map %s and mode %s", maprotation.map, maprotation.game_mode))
	maphack.clear_profile()
	local t = os.clock()
	local mappositions = db.select("maphack", { "x", "y", "z" }, string.format("map='%s' and mode='%s'", server.map, cheater.profile_key[server.gamemode]) )
	if #mappositions == 0 then
		nm_messages.msg(-1, players.admins(), maphack.label, string.format("Could not load maphack profile for map %s and mode %s", server.map, server.gamemode), "grey", { "debug"})
	else
		for i, mapposition in pairs(mappositions) do
			x = tonumber(mapposition.x)
			y = tonumber(mapposition.y)
			z = tonumber(mapposition.z)
			if maphack.profile[z] == nil then
				maphack.profile[z] = {}
			end
			if maphack.profile[z][y] == nil then
				maphack.profile[z][y] = {}
			end
			if maphack.profile[z][y][x] == nil then
				maphack.profile[z][y][x] = 1
				maphack.profile_size = maphack.profile_size + 1
			end
		end

		-- also loading insta points for efficiency
		if cheater.profile_key[server.gamemode] == 'efficiency' then
			local mappositions_insta = db.select("maphack", { "x", "y", "z" }, string.format("map='%s' and mode='%s'", server.map, 'insta ctf') )
			if #mappositions_insta > 0 then
				for i, mapposition in pairs(mappositions_insta) do
					x = tonumber(mapposition.x)
					y = tonumber(mapposition.y)
					z = tonumber(mapposition.z)
					if maphack.profile[z] == nil then
						maphack.profile[z] = {}
					end
					if maphack.profile[z][y] == nil then
						maphack.profile[z][y] = {}
					end
					if maphack.profile[z][y][x] == nil then
						maphack.profile[z][y][x] = 1
						maphack.profile_size = maphack.profile_size + 1
					end
				end
			end
		end

		maphack.startpoints = maphack.profile_size
		nm_messages.msg(-1, players.admins(), maphack.label, string.format("Successfully loaded maphack profile for map %s and mode %s with %i valid positions (in %i s)", server.map, server.gamemode, maphack.profile_size, os.clock() - t), "grey", {"debug"})

		-- load max malus
		local result = db.select("maphack_malus", { "warn", "kick" }, string.format("map='%s' and mode='%s'", server.map, cheater.profile_key[server.gamemode]) )
		if #result > 0 then
			maphack.warnmalus = tonumber(result[1].warn)
			maphack.banmalus = tonumber(result[1].kick)
		else
			maphack.warnmalus = maphack.default_warnmalus
			maphack.banmalus = maphack.default_banmalus
		end

		if maphack.load_carrots == 1 then
			maphack.send_carrots()
		end
	end
end

-- speichert profil in die datenbank
function maphack.save_profile()
	nm_messages.msg(-1, players.admins(), maphack.label, string.format("Saving maphack profile for map %s and mode %s", server.map, server.gamemode), "grey", {"debug"})
	db.delete("maphack", string.format("map='%s' and mode='%s'", server.map, cheater.profile_key[server.gamemode]))
	for z,zv in pairs(maphack.profile) do
		for y,yv in pairs(zv) do
			for x,xv in pairs(yv) do
				-- nm_messages.msg(-1, players.admins(), maphack.label, string.format("x=%i, y=%i, z=%i, map=%s, mode=%s", x, y, z, maprotation.map, maprotation.game_mode))
				db.insert("maphack", { map=server.map, mode=cheater.profile_key[server.gamemode], x=x, y=y, z=z })
			end
		end
	end
	nm_messages.msg(-1, players.admins(), maphack.label, string.format("Successfully saved maphack profile for map %s and mode %s with %i valid positions", server.map, server.gamemode, maphack.profile_size), "grey", {"debug"})
end

-- eine carrot senden (innerhalb von grenzen
function maphack.clear_carrots()
	maphack.carrots_cur = maphack.carrots_min - 1
	while maphack.carrots_cur <= maphack.carrots_max do
		maphack.carrots_cur = maphack.carrots_cur + 1
		server.reset_entity(maphack.carrots_cur)
	end
	maphack.carrots = {}
	maphack.carrots_id = {}
end

function maphack.get_carrot_id(x, y, z)
	if maphack.carrots[z] ~= nil and maphack.carrots[z][y] ~= nil and maphack.carrots[z][y][x] ~= nil then
		return maphack.carrots[z][y][x]
	end
	return -1
end

function maphack.remove_carrot(x, y, z)
	local id = maphack.get_carrot_id(x2, y2, z2)
	maphack.carrots_id[id] = nil
	if maphack.carrots ~= nil and maphack.carrots[z] ~= nil and maphack.carrots[z][y] ~= nil and maphack.carrots[z][y][x] ~= nil then
		maphack.carrots[z][y][x] = nil
	end
	server.reset_entity(id)
end

-- eine carrot senden (innerhalb von grenzen)
function maphack.send_carrot(x, y, z)
	if maphack.get_carrot_id(x, y, z) > 0 then return end
	maphack.carrots_cur = maphack.carrots_cur + 1
	if maphack.carrots_cur > maphack.carrots_max then
		maphack.carrots_cur = maphack.carrots_min
			end
	-- clear old
	if maphack.carrots_id[maphack.carrots_cur] ~= nil then
		if maphack.carrots_id[maphack.carrots_cur][1] ~= nil and maphack.carrots_id[maphack.carrots_cur][1] ~= nil and maphack.carrots_id[maphack.carrots_cur][1] ~= nil then
			maphack.carrots[maphack.carrots_id[maphack.carrots_cur][1]][maphack.carrots_id[maphack.carrots_cur][2]][maphack.carrots_id[maphack.carrots_cur][3]] = nil
		end
	end
	-- set new
	if maphack.carrots[z] == nil then maphack.carrots[z] = {} end
	if maphack.carrots[z][y] == nil then maphack.carrots[z][y] = {} end
	maphack.carrots[z][y][x] = maphack.carrots_cur
	maphack.carrots_id[maphack.carrots_cur] = { z, y, x }
	-- send entity
	server.ent_x = x + maphack.carrots_x
	server.ent_y = y + maphack.carrots_y
	server.ent_z = z + maphack.carrots_z
	server.ent_type = maphack.carrots_enttype
	server.ent_attr1 = 0
	server.ent_attr2 = maphack.carrots_entattr2
	server.ent_attr3 = 0
	server.ent_attr4 = 0
	server.ent_attr5 = 0
	server.send_entity(maphack.carrots_cur)
end

-- laedt carrots
function maphack.send_carrots()
	if maphack.visualisation ~= 1 then
		nm_messages.msg(-1, players.admins(), maphack.label, "Carrots are currently disabled!", "red", {"error"})
		return
	end 
	for z,zv in pairs(maphack.profile) do
		for y,yv in pairs(zv) do
			for x,xv in pairs(yv) do
				maphack.send_carrot(x, y, z)
			end
		end
	end
end


-- check if a player (which is not at a valid position) stands above an other player (which has to be at a valid position)
function maphack.player_is_above_other_player(above_cn, x, y, z)
	for i,below_cn in ipairs(players.all()) do
		local b_x, b_y, b_z = server.player_pos(below_cn)
		if math.abs(x - b_x) < maphack.above_dist and math.abs(y - b_y) < maphack.above_dist and math.floor(z - b_z) == maphack.above_dist_z then -- player is above other player
			if maphack.check_pos(b_x, b_y, b_z) then return true end -- other player has an valid position, so everything is fine
		end
	end
	return false
end

-- eine einzelne position aufnehmen
function maphack.record_pos(cn, x, y, z)
	x1 = math.floor(x)
	y1 = math.floor(y)
	z1 = math.floor(z)
	x2 = x1 - (x1 % maphack.distance)
	y2 = y1 - (y1 % maphack.distance)
	z2 = z1 - (z1 % maphack.distance)
	if maphack.profile[z2] == nil then maphack.profile[z2] = {} end
	if maphack.profile[z2][y2] == nil then maphack.profile[z2][y2] = {} end
	if maphack.profile[z2][y2][x2] == nil then
		maphack.profile[z2][y2][x2] = 1
		if maphack.visualisation == 1 then
			if maphack.reverse == 1 then
				maphack.remove_carrot(x2, y2, z2)
			else
				maphack.send_carrot(x2, y2, z2)
			end
		end
		db.insert("maphack", { map=server.map, mode=cheater.profile_key[server.gamemode], x=x2, y=y2, z=z2 })
		if maphack.recording == 1 then
			nm_messages.msg(-1, players.all(), maphack.label, string.format("%s added a new position x: %i y: %i z: %i", server.player_name(cn), x2, y2, z2), "grey", {"debug"})
		elseif maphack.undercover == 1 then
			local undercovers = cheater.get_undercovers()
			nm_messages.msg(-1, undercovers, maphack.label, string.format("%s added a new position x: %i y: %i z: %i", server.player_name(cn), x2, y2, z2), "grey", {"debug"})
		end
		maphack.profile_size = maphack.profile_size + 1
		if maphack.points[cn] == nil then
			maphack.points[cn] = 1
		else
			maphack.points[cn] = maphack.points[cn] + 1
		end
	else
		nm_messages.msg(-1, players.admins(), maphack.label, "Position x:" .. x2 .. " y:" .. y2 .. " z:" .. z2 .. " was already recorded!", "grey", {"debug"})
	end
end

-- eine einzelne position pruefen
function maphack.check_pos(x, y, z)
	x1 = math.floor(x)
	y1 = math.floor(y)
	z1 = math.floor(z)
	x2 = x1 - (x1 % maphack.distance)
	y2 = y1 - (y1 % maphack.distance)
	z2 = z1 - (z1 % maphack.distance)
	if maphack.profile[z2] == nil then
		-- nm_messages.verbose(players.admins(), maphack.label, "Position x:" .. x2 .. " y:" .. y2 .. " z:" .. z2 .. " is NOT valid")
		return false
	else
		if maphack.profile[z2][y2] == nil then
			-- nm_messages.verbose(players.admins(), maphack.label, "Position x:" .. x2 .. " y:" .. y2 .. " z:" .. z2 .. " is NOT valid")
			return false
		else
			if maphack.profile[z2][y2][x2] == nil then
				-- nm_messages.verbose(players.admins(), maphack.label, "Position x:" .. x2 .. " y:" .. y2 .. " z:" .. z2 .. " is NOT valid")
				return false
			end
		end
	end
	-- nm_messages.verbose(players.admins(), maphack.label, "Position x:" .. x2 .. " y:" .. y2 .. " z:" .. z2 .. " is valid")
	return true
end

-- aufnahme von positionen
function maphack.record()
	if server.paused == 1 or server.timeleft <= 0 or maphack.enabled == 0 or (maphack.recording == 0 and maphack.undercover == 0) or server.gamemode == "coop edit" or server.gamemillis < 10000 then return end
	for i,cn in ipairs(players.all()) do
		if maphack.recording == 1 or cheater.is_undercover(cn) then
			if server.player_status(cn) ~= "spectator" and server.player_status_code(cn) == server.ALIVE then
				local x, y, z = server.player_pos(cn)
				if not maphack.check_pos(x, y, z) then
					maphack.record_pos(cn, x, y, z)
				end
			end
		end
	end
end

-- pruefen der positionen der spieler
function maphack.check()
	if server.paused == 1 or server.timeleft <= 0 or maphack.enabled == 0 or maphack.recording == 1 or maphack.profile_size == 0 or server.gamemode == "coop edit" then return end
	for i,cn in ipairs(players.all()) do
		if server.player_status(cn) ~= "spectator" and server.player_status_code(cn) == server.ALIVE and not cheater.is_undercover(cn) then
			local x, y, z = server.player_pos(cn)
			maphack.set_falling_state(cn, z)
			if maphack.check_pos(x, y, z) then
				maphack.clear_malus(cn)
			else
				if not maphack.player_is_above_other_player(cn, x, y, z) then
					maphack.add_malus(cn)
				end
			end
		end		
	end
end

-- visualisiert den spieler umgebende carrots
function maphack.visualize()
	if server.paused == 1 or server.timeleft <= 0 or maphack.enabled == 0 or maphack.recording ~= 1 or maphack.visualisation ~= 1 or maphack.profile_size == 0 then return end
	local n = #players.active()
	if n == 0 then return end
	local cn = players.active()[ math.random(n) ] 
	local mxdist = maphack.vxdist * maphack.distance
	local mydist = maphack.vydist * maphack.distance
	local mzdist = maphack.vzdist * maphack.distance
	local x, y, z = server.player_pos(cn)
	x1 = math.floor(x)
	y1 = math.floor(y)
	z1 = math.floor(z)
	x2 = x1 - (x1 % maphack.distance)
	y2 = y1 - (y1 % maphack.distance)
	z2 = z1 - (z1 % maphack.distance)
	xmin = x2 - mxdist
	xmax = x2 + mxdist
	ymin = y2 - mydist
	ymax = y2 + mydist
	zmin = z2 - mzdist
	zmax = z2 + mzdist
	for z3 = zmin, zmax, maphack.distance do
		for y3 = ymin, ymax, maphack.distance do
			for x3 = xmin, xmax, maphack.distance do
				if maphack.reverse == 0 and maphack.profile[z3] ~= nil and maphack.profile[z3][y3] ~= nil and maphack.profile[z3][y3][x3] ~= nil then
					maphack.send_carrot(x3, y3, z3)
				end
				if maphack.reverse == 1 and (maphack.profile[z3] == nil or maphack.profile[z3][y3] == nil or maphack.profile[z3][y3][x3] == nil) then
					maphack.send_carrot(x3, y3, z3)
				end
			end
		end
	end
end

function maphack.check_pointleader()
	if maphack.enabled == 0 then return end
	if maphack.recording == 1 then
		local most = -1
		local pointleader = -1
		for i,cn in ipairs(players.all()) do
			if server.player_status(cn) ~= "spectator" and maphack.points[cn] ~= nil then -- and server.player_status_code(cn) == server.ALIVE
				if maphack.points[cn] > most then
					most = maphack.points[cn]
					pointleader = cn
				end
			end
		end
		if most > -1 and pointleader > -1 and pointleader ~= maphack.pointleader then
			maphack.pointleader = pointleader
			nm_messages.msg(-1, players.all(), maphack.label, string.format("name<%i> is the new point leader (%i positions)", maphack.pointleader, most), "green", {"info"})
			for i,cn in ipairs(players.all()) do
				if maphack.points[cn] ~= nil and maphack.pointleader ~= cn then
					local behind = most - maphack.points[cn]
					nm_messages.msg(-1, {cn}, maphack.label, string.format(">> You have recorded %i positions (%i points behind name<%i>)", maphack.points[cn], behind, maphack.pointleader), "green", {"info"})
				end
			end
		end
	end
end

function maphack.check_pointleader2()
	if maphack.enabled == 0 then return end
	if maphack.recording == 1 then
		if maphack.pointleader ~= nil and maphack.points[maphack.pointleader] ~= nil and utils.valid_cn(maphack.pointleader) then
			nm_messages.msg(-1, players.all(), maphack.label, string.format("Current point leader: name<%i> (%i positions)", maphack.pointleader, maphack.points[maphack.pointleader]), "green", {"info"})
		end
		for i,cn in ipairs(players.all()) do
			if maphack.pointleader ~= nil and maphack.points[cn] ~= nil and maphack.points[maphack.pointleader] ~= nil and maphack.pointleader ~= cn then
				local behind = maphack.points[maphack.pointleader] - maphack.points[cn]
				nm_messages.msg(-1, {cn}, maphack.label, string.format(">> You have recorded %i positions (%i points behind name<%i>)", maphack.points[cn], behind, maphack.pointleader), "green", {"info"})
			end
		end
	end
end



--[[
		EVENTS
]]

event_listener.add("started", function()
	server.interval(maphack.check_interval, maphack.check)
	server.interval(maphack.record_interval, maphack.record)
	server.interval(maphack.visualisation_interval, maphack.visualize)
	server.interval(maphack.pointleader_interval, maphack.check_pointleader)
	server.interval(maphack.pointleader_interval2, maphack.check_pointleader2)
end)

event_listener.add("intermission", function()
	if maphack.enabled == 0 or maphack.recording == 0 then
		if maphack.undercover == 1 and maphack.startpoints < maphack.profile_size then
			local undercovers = cheater.get_undercovers()
			local new_positions = maphack.profile_size - maphack.startpoints
			nm_messages.msg(-1, undercovers, maphack.label, string.format("Recording stats: red<%i> new positions recorded by red<%i> undercover agents. Thank you for your support!", new_positions, #undercovers), "green", {"debug"})
		end
	else
		local most = -1
		local most_cn = -1
		for i,cn in ipairs(players.all()) do
			if server.player_status(cn) ~= "spectator" and maphack.points[cn] ~= nil then -- and server.player_status_code(cn) == server.ALIVE
				if maphack.points[cn] > most then
					most = maphack.points[cn]
					most_cn = cn
				end
				nm_messages.msg(-1, players.all(), maphack.label, string.format("  name<%i>: yellow<%i positions>", cn, maphack.points[cn]), "green", {"info"})
			end
		end
		if most_cn >= 0 then
			nm_messages.msg(-1, players.all(), maphack.label, string.format("orange<WINNER:> name<%i>", most_cn), "green", {"info"})
		end
	end
end)

event_listener.add("mapchange", function(map, mode)
	maphack.warn_level = {}
	maphack.startpoints = 0
	maphack.load_profile()
	if maphack.recording == 1 then
		maphack.recording = 0
		maphack.undercover = 1
	end
	maphack.carrots_cur = maphack.carrots_min
	maphack.carrots = {}
	maphack.carrots_id = {}
	maphack.points = {}
	maphack.pointleader = -1
	cheater.stop_recording("maphack")
	-- automatically changes only_warnings and silent states by stored map states
	local state = cheater.get_map_state(map, "maphack")
	if state < cheater.map_states.recording.NEW then
		maphack.only_warnings = 1
		maphack.silent = 1
		cheater.set_map_state(server.map, "maphack", cheater.map_states.recording.NEW) -- initially set state to new
		nm_messages.msg(-1, players.admins(), maphack.label, string.format("The recorded profile for this map is marked as red<new>. Mark it as only_warnings: orange<#maphack state only_warnings>"), "grey", {"debug", "log"})
	elseif state < cheater.map_states.recording.ONLY_WARNINGS then
		maphack.only_warnings = 1
		maphack.silent = 1
		nm_messages.msg(-1, players.admins(), maphack.label, string.format("The recorded profile for this map is marked as red<new>. Mark it as only_warnings: orange<#maphack state only_warnings>"), "grey", {"debug", "log"})
	elseif state < cheater.map_states.recording.READY then
		maphack.only_warnings = 1
		maphack.silent = 0
		nm_messages.msg(-1, players.admins(), maphack.label, string.format("The recorded profile for this map is marked as yellow<only_warnings>. Mark it ready: orange<#maphack state ready>"), "grey", {"debug", "log"})
	else
		maphack.only_warnings = 0
		maphack.silent = 0
		nm_messages.msg(-1, players.admins(), maphack.label, string.format("The recorded profile for this map is marked as green<ready>. Detected maphackers will be kicked!"), "grey", {"verbose", "log"})
	end
end)
