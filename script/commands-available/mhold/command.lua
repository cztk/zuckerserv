local help = "HOLDSECS,"
local usage = "<key> [<value>]"
local enabled = true
local permission = 0

local run = function(cn, key, value)

    if key == "HOLDSECS" then
        server.m_hold_HOLDSECS = value * 1000
    end


end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
