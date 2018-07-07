local permission = 3
local enabled = true
local message = ""
local usage = ""
local help = ""
local run = function(cn, tcn, ...)
    server.unsetpriv(tcn)
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage
}

