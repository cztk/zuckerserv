local permission = 0
local enabled = true
local help = "Displays version of the server software."
local usage = ""

local run = function(cn)
    local version = server.version()
    local revision = server.revision()
    local uptime = server.format_duration_str(server.uptime)
    local verstr = ""

    if revision > -1 then
        verstr = server.parse_message(cn, "version", {version = version, revision = revision})
    end 

    server.player_msg(cn, "info_command", {uptime = uptime, verstr = verstr})
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}
