--[[

	A player command to execute a script on the server

]]
local permission = 3
local enabled = false
local aliases = {"lua"}

local help = function(cn, command)

    server.player_msg(cn, "command for running some lua code")
    server.player_msg(cn, "#" .. command .. "<code>")

end

local run = function(cn, ...)

	local code = ""

	for _, item in ipairs({...}) do
		item = tostring(item)
		if #item > 0 then
			if #code > 0 then
				code = code .. " "
			end
			code = code .. item
		end
	end

	if code == "" then
		return false, "#eval <code>"
	end

	--server.player_msg(cn, server["do"](code) or "")
    
	server.player_msg(cn, eval_lua(code) or "")
end

return {
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help,
        aliases = aliases
}
