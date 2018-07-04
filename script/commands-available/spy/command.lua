-- (C) 2011 by Thomas

local permission = 3
local enabled = true
local help = "Enter or leave spy mode"
local usage ="[1|0]"

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
        help_message = help,
        help_parameters = usage
}
