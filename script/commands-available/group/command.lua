--[[
    A player command to group all players matching pattern <tag>
]]

local permission = 1
local enabled = true
local usage = "[all] <tag> [<team>]"
local help = "A player command to group all players matching pattern <tag>"

local group_players = function(...)

    local arg = {...}
    
    if #{...} == 0 then
        return -1
    end
    
    local all_clients
    local tag
    local team
    
    if #arg == 1 then
        tag = arg[1]
    else
        if arg[1] == "all" then
            all_clients = true
            tag = arg[2]
            team = arg[3]
        else
            tag = arg[1]
            team = arg[2]
        end
    end
    
    if not team then
        team = tag
    end
    
    if all_clients then
        for spectator in server.gspectators() do
            if string.find(spectator:name(),tag) then
                spectator:unspec()
            end
        end
    end
    
    for player in server.gplayers() do
        if string.find(player:name(), tag) then
            player:changeteam(team)
        end
    end
end

local run = function(cn, ...)
    
    if not gamemodeinfo.teams then
        return
    end
    
    if #{...} == 0 then
        return false, usage
    end
    
    group_players(unpack({...}))
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
