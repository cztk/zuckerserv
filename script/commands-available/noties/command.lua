--[[
    A player command to enable/ disable no ties module
]]

local permission = 1
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "enable/ disable no ties module")
    server.player_msg(cn, "#" .. command .. " [0|off|1|on]")

end

local init = function()
    if(true == enabled and not server.no_ties) then
        server.log(string.format("WARN: command #noties is enabled but no_ties module not loaded!"))
        enabled = false
    end
end


local run = function(cn, option)
    if false == enabled then
        return false, "no_tie module is not loaded."
    end
    
    if not option then
        help()
        return false
    end
    
    if (option == "0") or (option == "off") then
        server.no_ties()
        server.player_msg(cn, "no ties module disabled.")
    elseif option == "1" or option == "on" then
        server.no_ties(true)
        server.player_msg(cn, "no ties module enabled.")
    else
        help()
        return false
    end
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
