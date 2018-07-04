-- [[ based on a player command written by Thomas ]] --

local permission = 3
local help = "reload_lua"
local usage =""
local enabled=true

local run = function()
  server.reload_lua()
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
