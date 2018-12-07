--[[
	Script:			noobmod/nm_messages.lua
	Authors:		Hanack (Andreas Schaeffer)
					Hankus (Derk Haendel)
	Created:		17-Oct-2010
	Last Change:	20-May-2013
	License:		GPL3
	
	Description:
		This module is a central hub for ingame nm_messages. You can use
		different log levels like the logging API's known in other
		programming languages.
		
		The user can set the *log level* to append. For example to disable
		all the normal output, just set the log level to error or warn.
		Instead, setting the log level to debug or verbose will pass you
		more messages, which are not always nessessary.
		
		Additionally, there are different *channels* to address, for example
		log files or IRC bots.
		
		Another addressing issue handled by this module is which players
		will get the message. We expect a table of client numbers. The table
		can be empty in the case you only want to log to IRC or log files.
		
	API:
		nm_messages.msg(from, to, module, message, ll_and_channels}
		
	Commands:
		#loglevel
			Prints out the log level
		#loglevel <LEVEL>
			Sets the log level
		#lv
			Sets the log level to verbose
		#ld
			Sets the log level to debug
		#li
			Sets the log level to info
		#lw
			Sets the log level to warn
		#le
			Sets the log level to error
		#logmod [<module> [<level>] ]
			Lists all logmod levels
			Prints the logmod level of a given module
			Sets the logmod level of a given module

]]



--[[
		API
]]

nm_messages = {}
nm_messages.label = "MESSAGES"
nm_messages.am_label = "ADMINMESSAGE"
nm_messages.providers = {}
nm_messages.formaters = {}
nm_messages.loglevels = { "debug", "info", "warn", "error" }
nm_messages.loglevels[0] = "verbose"
nm_messages.logmod = {}
nm_messages.LOGLEVEL_VERBOSE = 0
nm_messages.LOGLEVEL_DEBUG = 1
nm_messages.LOGLEVEL_INFO = 2
nm_messages.LOGLEVEL_WARN = 3
nm_messages.LOGLEVEL_ERROR = 4
nm_messages.LOGLEVEL_DEFAULT = nm_messages.LOGLEVEL_INFO
nm_messages.repeated_millis = 2000
nm_messages.repeated_strings = {}
-- TODO: store irc word filter in database
nm_messages.irc_word_filter = { "gg", "np", "sorry", "osrry", "sry", "sorry mate!", "gg!" }
nm_messages.map_file_channels = {
	log = server.log,
	elog = server.log_error,
	dlog = server.log_debug,
	hankus = server.log_debug,
	hanack = server.log_debug
}
nm_messages.map_irc_channels = {}



function nm_messages.register_file_channel(channel_name, channel_func)
	nm_messages.map_file_channels[channel_name] = channel_func
end

function nm_messages.register_irc_channel(channel_name, channel_func)
	nm_messages.map_irc_channels[channel_name] = channel_func
end

function nm_messages.get_loglevel_num(level)
	if not level then return nm_messages.LOGLEVEL_DEFAULT end
	if utils.is_numeric(level) then
		if level >= 0 and level < 5 then
			return level
		else
			return nm_messages.LOGLEVEL_DEFAULT
		end
	else
		local llevel = string.lower(level)
		if llevel == nm_messages.loglevels[nm_messages.LOGLEVEL_VERBOSE] then
			return nm_messages.LOGLEVEL_VERBOSE
		elseif llevel == nm_messages.loglevels[nm_messages.LOGLEVEL_DEBUG] then
			return nm_messages.LOGLEVEL_DEBUG
		elseif llevel == nm_messages.loglevels[nm_messages.LOGLEVEL_INFO] then
			return nm_messages.LOGLEVEL_INFO
		elseif llevel == nm_messages.loglevels[nm_messages.LOGLEVEL_WARN] then
			return nm_messages.LOGLEVEL_WARN
		elseif llevel == nm_messages.loglevels[nm_messages.LOGLEVEL_ERROR] then
			return nm_messages.LOGLEVEL_ERROR
		else
			return nm_messages.LOGLEVEL_DEFAULT
		end
	end
end

function nm_messages.get_loglevel_string(level)
	if utils.is_numeric(level) then
		return nm_messages.loglevels[level]
	else
		return nm_messages.loglevels[nm_messages.LOGLEVEL_DEFAULT]
	end
end

function nm_messages.get_loglevel(cn)
--	local player = nmcore.return_player(cn)
--	return player.loglevel
    return nm_messages.LOGLEVEL_VERBOSE
end

function nm_messages.set_loglevel(cn, loglevel)
--	local player = nmcore.return_player(cn)
--	player.loglevel = loglevel
--	nm_messages.msg(cn, cn, nm_messages.label, string.format("Loglevel has been set to: %s", nm_messages.get_loglevel_string(loglevel)), "green", { "info" })
end

function nm_messages.get_logmod(module)
	if nm_messages.logmod[module] ~= nil then
		return tonumber(nm_messages.logmod[module])
	else
		return tonumber(nm_messages.LOGLEVEL_DEFAULT)
	end
end

function nm_messages.set_logmod(module, level)
	nm_messages.logmod[module] = level
	db.insert_or_update('logmod', {module=module, level=level}, string.format("module='%s'", module))
end

function nm_messages.load_logmod()
	nm_messages.logmod = {}
	local result = db.select('logmod', { 'module', 'level' }, 'level >= 0')
	for i,row in pairs(result) do
		nm_messages.logmod[ row['module'] ] = tonumber(row['level'])
	end
end

function nm_messages.list_logmod(cn)
	nm_messages.msg(cn, {cn}, nm_messages.label, "List of module logmod levels:", "green", { "info" })
--	for module, loglevel in pairs(nm_messages.logmod) do
--		nm_messages.msg(cn, {cn}, nm_messages.label, string.format("  %s: %s", module, nm_messages.get_loglevel_string(loglevel)), "green", { "info" })
--	end
end

function nm_messages.log_irc_chat_messages(cn, msg, module)
	local lmsg = string.lower(msg)
    -- Hide player commands
    if string.match(msg, "^#.*") or string.match(msg, "^!.*") then return end
	-- Filter all extracted commands
	for _,rule in pairs(extractcommand.rules) do
		if lmsg == rule['text'] then return end
	end
	-- Filter additional words
	for _,filter_word in pairs(nm_messages.irc_word_filter) do
		if lmsg == filter_word then return end
	end
	-- Add mute tag if muted
    local mute_tag = ""
    if mute.is_muted(cn) then
    	mute_tag = " (muted)"
    end
	nm_messages.msg(-1, {}, module, string.format("displayname<%i>%s: green<%s>", cn, mute_tag, msg), "green", {"ircchat", "log"})
end

function nm_messages.is_repeated(message)
	local found = false
	for _, a_message in ipairs(nm_messages.repeated_strings) do
		if message == a_message then
			found = true
			break
		end
	end
	if not found then
		table.insert(nm_messages.repeated_strings, message)
	end
	return found
end

function nm_messages.clear_repeated()
	nm_messages.repeated_strings = {}
end



--[[
		FORMATTERS
]]

function nm_messages.formaters.console(input)
	local output = input
	local function formatcol(col, text)
	    if text then return "\fs\f" .. col .. text .. "\fr" else return "\f" ..col end
	end
	local function green(text) return formatcol(0, text) end
	local function blue(text) return formatcol(1, text) end
	local function yellow(text) return formatcol(2, text) end
	local function red(text) return formatcol(3,text) end
	local function grey(text) return formatcol(4, text) end
	local function magenta(text) return formatcol(5, text) end
	local function orange(text) return formatcol(6, text) end
	local function white(text) return formatcol(9, text) end
	output = string.gsub(output, "displayname<(.-)>", function(cn)
		local cn = tonumber(cn)
		if cn == nil then return "" end
		return string.format(blue("%s (%i)"), server.player_name(cn), cn)
	end)
	-- for sauerbraten console output the name<cn> just outputs the player name (without cn)
	output = string.gsub(output,"name<(.-)>",function(cn)
		local cn = tonumber(cn)
		if cn == nil then return "" end
		return string.format(blue("%s"), server.player_name(cn))
	end)
	output = string.gsub(output,"white<(.-)>",function(word) return white(word) end)
	output = string.gsub(output,"red<(.-)>",function(word) return red(word) end)
	output = string.gsub(output,"orange<(.-)>",function(word) return orange(word) end)
	output = string.gsub(output,"green<(.-)>",function(word) return green(word) end)
	output = string.gsub(output,"yellow<(.-)>",function(word) return yellow(word) end)
	output = string.gsub(output,"magenta<(.-)>",function(word) return magenta(word) end)
	output = string.gsub(output,"blue<(.-)>",function(word) return blue(word) end)
	output = string.gsub(output,"grey<(.-)>",function(word) return grey(word) end)
	return output
end

function nm_messages.formaters.irc(input)
	local output = input
	output = string.gsub(output, "displayname<(.-)>", function(cn)
		local cn = tonumber(cn)
		if cn == nil then return "" end
		return string.format("\0032%s (cn: %i)\003", server.player_name(cn), cn)
	end)
	output = string.gsub(output, "name<(.-)>", function(cn)
		local cn = tonumber(cn)
		if cn == nil then return "" end
		return string.format("\0032%s (cn: %i)\003", server.player_name(cn), cn)
	end)
	output = string.gsub(output,"white<(.-)>",function(word) return string.format("%s", word) end)
	output = string.gsub(output,"black<(.-)>",function(word) return string.format("\0031%s\003", word) end)
	output = string.gsub(output,"green<(.-)>",function(word) return string.format("\0033%s\003", word) end)
	output = string.gsub(output,"red<(.-)>",function(word) return string.format("\0034%s\003", word) end)
	output = string.gsub(output,"magenta<(.-)>",function(word) return string.format("\0036%s\003", word) end)
	output = string.gsub(output,"orange<(.-)>",function(word) return string.format("\0037%s\003", word) end)
	output = string.gsub(output,"yellow<(.-)>",function(word) return string.format("\0037%s\003", word) end) --0038
	output = string.gsub(output,"blue<(.-)>",function(word) return string.format("\0032%s\003", word) end)
	output = string.gsub(output,"grey<(.-)>",function(word) return string.format("\00314%s\003", word) end)
	return output
end

function nm_messages.formaters.file(input)
	local output = input;
	output = string.gsub(output, "displayname<(.-)>", function(cn)
		local cn = tonumber(cn)
		if cn == nil then return "" end
		return string.format("%s (cn: %i ip: %s)", server.player_name(cn), cn, server.player_ip(cn))
	end)
	output = string.gsub(output, "name<(.-)>", function(cn)
		local cn = tonumber(cn)
		if cn == nil then return "" end
		return string.format("%s (cn: %i)", server.player_name(cn), cn)
	end)
	output = string.gsub(output,"white<(.-)>",function(word) return word end)
	output = string.gsub(output,"green<(.-)>",function(word) return word end)
	output = string.gsub(output,"red<(.-)>",function(word) return word end)
	output = string.gsub(output,"magenta<(.-)>",function(word) return word end)
	output = string.gsub(output,"orange<(.-)>",function(word) return word end)
	output = string.gsub(output,"yellow<(.-)>",function(word) return word end)
	output = string.gsub(output,"blue<(.-)>",function(word) return word end)
	output = string.gsub(output,"grey<(.-)>",function(word) return word end)
	return output
end



--[[
		PROVIDERS
]]

function nm_messages.providers.console(target_cn, module, message, labelcolor, func)
	func(target_cn, nm_messages.formaters.console(string.format("%s<[ %s ]> %s", labelcolor, module, message)))
end

function nm_messages.providers.irc(module, message, labelcolor, channel_func)
--	if nm_messages.is_repeated(message) then return end
--	channel_func(nm_messages.formaters.irc(string.format("%s<[%s]> %s", labelcolor, module, nm_messages.formaters.irc(message.." "))))
end

function nm_messages.providers.file(module, message, channel_func)
	if module == nil or message == nil then return end
	channel_func(string.format("[ %s ]  %s", module, nm_messages.formaters.file(message)))
end

function nm_messages.tbl_find(tbl, value)
	for _, v in pairs(tbl) do
		if value == v then return true end
	end
	return false
end

function nm_messages.msg(from, to, module, message, labelcolor, channels)
	if from == nil or to == nil or module == nil or message == nil then return end
	if not labelcolor then labelcolor = "orange" end
	if not channels then channels = { "info" } end
	local module = string.upper(module)

	-- sauerbraten console / handles all loglevel channels (verbose...)
	for loglevel = nm_messages.LOGLEVEL_ERROR, nm_messages.get_logmod(module), -1 do -- ignores lower loglevels as early as possible
		if nm_messages.tbl_find(channels, nm_messages.loglevels[loglevel]) then
			if utils.is_numeric(to) then
--				local player = nmcore.return_player(to)
--				if tonumber(player.loglevel) <= loglevel then
					nm_messages.providers.console(tonumber(to), module, message, labelcolor, server.player_msg)
--				end
			else
				for _, cn in pairs(to) do
--					local player = nmcore.return_player(cn)
--					if tonumber(player.loglevel) <= loglevel then
						nm_messages.providers.console(tonumber(cn), module, message, labelcolor, server.player_msg)
--					end
				end
			end
			break -- no need for checking lower loglevels anymore (break as fast as possible)
		end
	end

	-- irc channels
--	for irc_channel, provider_func in pairs(nm_messages.map_irc_channels) do
--		if nm_messages.tbl_find(channels, irc_channel) then
--			nm_messages.providers.irc(module, message, labelcolor, provider_func)
--		end
--	end

	-- file channels
	for file_channel, provider_func in pairs(nm_messages.map_file_channels) do
		if nm_messages.tbl_find(channels, file_channel) then
			nm_messages.providers.file(module, message, provider_func)
		end
	end
	
end



--[[
		COMMANDS
]]
--[[
function commands.loglevel(cn, level)
	if level ~= nil then
		if string.lower(level) == "reset" then
			nm_messages.set_loglevel(cn, nm_messages.LOGLEVEL_DEFAULT)
		else
			nm_messages.set_loglevel(cn, nm_messages.get_loglevel_num(level))
		end
	else
		nm_messages.msg(cn, cn, nm_messages.label, string.format("Your current log level is: %s", nm_messages.get_loglevel_string(nm_messages.get_loglevel(cn))), "green", { "info" })
	end
end

function commands.lv(cn)
	nm_messages.set_loglevel(cn, nm_messages.LOGLEVEL_VERBOSE)
end

function commands.ld(cn)
	nm_messages.set_loglevel(cn, nm_messages.LOGLEVEL_DEBUG)
end

function commands.li(cn)
	nm_messages.set_loglevel(cn, nm_messages.LOGLEVEL_INFO)
end

function commands.lw(cn)
	nm_messages.set_loglevel(cn, nm_messages.LOGLEVEL_WARN)
end

function commands.le(cn)
	nm_messages.set_loglevel(cn, nm_messages.LOGLEVEL_ERROR)
end

function commands.logmod(cn, module, level)
	if not commands.access(cn, admin_access) then return end
	if not module then
		nm_messages.list_logmod(cn)
	else
		if module == "reload" then
			nm_messages.load_logmod()
			nm_messages.list_logmod(cn)
		else
			if not level then
				nm_messages.msg(cn, {cn}, nm_messages.label, string.format("Loglevel for module %s is red<%s>", module, nm_messages.get_loglevel_string(nm_messages.get_logmod(module))), "green", { "info" })
			else
				nm_messages.set_logmod(module, nm_messages.get_loglevel_num(level))
				nm_messages.msg(cn, {cn}, nm_messages.label, string.format("Loglevel for module %s has been set to red<%s>", module, nm_messages.get_loglevel_string(nm_messages.get_logmod(module))), "green", { "info" })
			end
		end
	end
end
]]



--[[
		EVENTS
]]

event_listener.add("started", function()
	-- load logmod
	nm_messages.load_logmod()
	-- clear repeated messages periodically
--	eventmanager.register_interval(nm_messages.repeated_millis, nm_messages.clear_repeated)
end)

--event_listener.add("text", function(cn, msg)
--	nm_messages.log_irc_chat_messages(cn, msg, "CHAT")
--end)

--event_listener.add("sayteam", function(cn, msg)
--	nm_messages.log_irc_chat_messages(cn, msg, "TEAMCHAT")
--end)
