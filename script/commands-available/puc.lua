local permission = 0
local enabled = true
local message = ""
local usage = ""
local help = ""
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
        help_message = help,
        help_parameters = usage
}

