-- [[ based on a player command written by Thomas ]] --

local permission = 3
local enabled=true

local help = function(cn, command)

    server.player_msg(cn, "reload_lua")

end

local run = function()
  server.reload_lua()
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
