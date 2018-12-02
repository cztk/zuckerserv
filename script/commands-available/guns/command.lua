local permission = 0
local enabled = true
local help = "Displays weapon types with their associated number."
local usage = ""

local run = function(cn)
    -- weapons_types
    for key,value in pairs(weapons_types) do
        server.player_msg(cn, red(key) .. white(" - ") .. orange(value))
    end
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
