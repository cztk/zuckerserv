local permission = 0
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "Displays weapon types with their associated number.")

end

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
        help_function = help
}
