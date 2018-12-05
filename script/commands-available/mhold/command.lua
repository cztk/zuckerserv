local enabled = true
local permission = 0

local help = function(cn, command)

    server.player_msg(cn, "define some aspects for hold mode")
    server.player_msg(cn, "#" .. command .. " <key> [<value>]")
    server.player_msg(cn, "HOLDSECS - timer for hold and invisible time on protect mode")


end


local run = function(cn, key, value)

    if key == "HOLDSECS" then
        server.m_hold_HOLDSECS = value * 1000
    end


end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
