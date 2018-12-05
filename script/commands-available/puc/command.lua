local permission = 0
local enabled = true
local message = ""

local help = function(cn, command)

    server.player_msg(cn, "#" .. command .. " <cn>")

end

local run = function(cn, tcn, ...)
    server.msg(string.format("%s %s  %s %s  %s %s"
      , white(server.player_displayname(tcn)), green("IS A puC")
      , blue(server.player_displayname(tcn)), yellow("IS A puC")
      , red(server.player_displayname(tcn)), grey("IS A puC")
    ))
    server.msg(string.format("%s %s  %s %s  %s %s"
      , magenta(server.player_displayname(tcn)), orange("IS A puC")
      , white(server.player_displayname(tcn)), green("IS A puC")
      , blue(server.player_displayname(tcn)), yellow("IS A puC")
    ))
    server.msg(string.format("%s %s  %s %s  %s %s"
      , red(server.player_displayname(tcn)), grey("IS A puC")
      , magenta(server.player_displayname(tcn)), orange("IS A puC")
      , white(server.player_displayname(tcn)), green("IS A puC")
    ))


end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}

