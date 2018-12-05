-- (C) 2011 by Thomas

local permission = 3
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "Enter or leave spy mode")
    server.player_msg(cn, "#" .. command .. " [1|0]")

end

local run = function(cn, enter)
    
    if enter == nil or enter == "on" then
        enter = 1 
    end
    
    server.setspy(cn, enter == 1)
    
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
