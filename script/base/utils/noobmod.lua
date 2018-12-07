--[[
	script/module/nl_mod/nl_utils.lua
	Andreas Schaeffer
	Created: 23-Okt-2010
	Last Change: 12-Nov-2010
	License: GPL3

	Funktion:
		Stellt verschiedene allgemein gebräuchliche Funktionen zur Verfügung

	API-Methoden:
		utils.is_numeric(x)
			Gibt true oder false zurück, wenn es sich um eine Zahl handelt oder nicht

]]


--[[
		API
]]

utils = {}

function utils.is_numeric(a)
    return type(tonumber(a)) == "number"
end


function utils.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function utils.table_val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and utils.table_tostring( v ) or
      tostring( v )
  end
end

function utils.table_key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. utils.table_val_to_str( k ) .. "]"
  end
end

function utils.table_tostring(tbl)
  if tbl == nil then return "{}" end
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, utils.table_val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        utils.table_key_to_str( k ) .. "=" .. utils.table_val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function utils.table_copy(t)
  local u = { }
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t))
end

function utils.table_size(t)
	local count = 0
	for k, v in pairs(t) do count=count+1 end
	return count
end


function utils.starts(String,Start)
	return string.sub(String,1,string.len(Start))==Start
end

function utils.ends(String,End)
	return End=='' or string.sub(String,-string.len(End))==End
end

function utils.timeString(timeDiff)
	local dateFormat = {
		{"d", timeDiff / 60 / 60 / 24},
		{"h", timeDiff / 60 / 60 % 24},
		{"m", timeDiff / 60 % 60},
		{"s", timeDiff % 60}
	}
 
	local out = {}
	for k, t in ipairs(dateFormat) do
		local v = math.floor(t[2])
		if(v > 0) then
			table.insert(out, tostring(v) .. t[1])
			--table.insert(out, (k < #dateFormat and (#out > 0 and ', ' or '') or ' and ') .. v .. ' ' .. t[1] .. (v ~= 1 and 's' or ''))
		end
	end
 
	return table.concat(out, " ")
end

function server.eval_lua(str)
    local func, err = loadstring(str)
    if not func then error(err) end
    return func()
end

function server.cmd_split(text)
	local tmp1 = {}
	local tmp2 = {}
	local ret = {}
	local l = 0
	local ll = 0
	local lmatch = false
	local inner = ""
	if not text then return nil end
	if string.len(text) > 0 then
		if string.find(text," ",0,true) then
			while true do
				text, ll = string.gsub(text, "%s%s", " ")
				if ll == 0 then break end
			end
			ll = 0
			while true do
				l = string.find(text," ",ll,true)
				if l~=nil then
					table.insert(tmp1, string.sub(text,ll,l-1))
					ll=l+1
				else
					table.insert(tmp1, string.sub(text,ll))
					break
				end
			end
			for i,v in ipairs(tmp1) do
				if string.sub(v,0,1) == "\"" and lmatch ~= true then
					inner = string.sub(v,2)
					--table.insert(ret,string.sub(v,2))
					lmatch = true
					if string.sub(v,-1) == "\"" and lmatch == true then
						inner = string.sub(inner,0,string.len(inner)-1)
						table.insert(tmp2, inner)
						lmatch = false
					end
				elseif string.sub(v,-1) == "\"" and lmatch == true then
					inner = inner .. " " .. string.sub(v,0,string.len(v)-1)
					table.insert(tmp2, inner)
					lmatch = false
				elseif lmatch == true then
					inner = inner .. " " .. v
				else
					table.insert(tmp2, v)
				end
			end
			for i,v in ipairs(tmp2) do
				if string.sub(v,0,1) == " " then v = string.sub(v,2) end
				if string.sub(v,-1) == " " then v = string.sub(v,0,string.len(v)-1) end
				table.insert(ret,v)
			end
		else
			ret = { text }
		end
	else
		ret = nil
	end
	return ret
end

function catch_error(chunk, ...)
    
    local pcall_results = {pcall(chunk, ...)}
    
    if not pcall_results[1] then
        server.log_error(pcall_results[2])
    end
    
    return pcall_results
end

function utils.hashpassword(cn, password)
    return crypto.tigersum(string.format("%i %i %s", cn, server.player_sessionid(cn), password))
end

function _if(expr, true_value, false_value)
    if expr then
        return true_value
    else
        return false_value
    end
end

function utils.is_teamkill(player1, player2)
    if not gamemodeinfo.teams then 
        return false
    end
    if server.player_team(player1) == server.player_team(player2) then 
        return true
    end
    return false
end

function utils.valid_cn(cn)
    local cn = tonumber(cn)
    return server.player_sessionid(cn or -1) ~= -1 and not server.player_is_spy(cn or -1)
    --return server.player_sessionid(cn or -1) ~= -1
    --return server.player_id(tonumber(cn) or -1) ~= -1
end

function utils.used_cn(cn)
    local cn = tonumber(cn)
    return server.player_sessionid(cn or -1) ~= -1
    --return server.player_sessionid(cn or -1) ~= -1
    --return server.player_id(tonumber(cn) or -1) ~= -1
end

function utils.table_find(tbl, value)
	for _, v in pairs(tbl) do
		if value == v then return true end
	end
	return false
end


