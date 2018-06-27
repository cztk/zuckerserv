--[[
	A player command to change the current map time
]]

local usage = "<minutes> [<seconds>]"
local help = "A player command to change the current map time"
local permission = 1
local enabled = true
local aliases = {"time"}

local run = function(cn, minutes, seconds)

    if not minutes then
        return false, help
    end

    minutes = tonumber(minutes)
    seconds = tonumber(seconds) or 0
    
    if not minutes or minutes < 0 then
        return false, "invalid minutes value"
    end
    
    if seconds < 0 or seconds > 60 then
        return false, "invalid seconds value"
    end
    
    server.changetime((minutes*60*1000)+(seconds*1000))
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
