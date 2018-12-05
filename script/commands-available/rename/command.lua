--[[

    	A command to rename a player
	By piernov — <piernov@piernov.org>

]]

local permission = 3
local enabled = true

local help = function(cn, command)

    server.player_msg(cn, "rename a player, he will get notified")
    server.player_msg(cn, "#" .. command .. "<cn> <newName>")

end

local run = function(cn,player_cn,new_name)
    if not player_cn or not new_name then
        help()
        return false
    elseif not server.valid_cn(player_cn) then
        return false, "Invalid CN"
    end

    server.player_rename(player_cn, new_name, true)
    server.player_msg(player_cn, "player_renamed", {newname= new_name, dispname = server.player_displayname(cn)})
    server.admin_log(string.format("RENAME: Player renamed to %s by %s", new_name, server.player_displayname(cn))) 
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help
}
