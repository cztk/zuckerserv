local permission = 3
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "takes privileges from a player")
    server.player_msg(cn, "#" .. command .. " <cn>")

end

local run = function(cn, tcn, ...)
    server.unsetpriv(tcn)
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}

