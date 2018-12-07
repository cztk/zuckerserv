package.path = package.path .. ";script/package/?.lua;"
package.cpath = package.cpath .. ";lib/lib?.so"

local fsutils = require "filesystem_utils"

add_exec_search_path = fsutils.add_exec_search_path
find_script = fsutils.find_script
exec = fsutils.exec
pexec = fsutils.pexec
exec_if_found = fsutils.exec_if_found
eval_lua = fsutils.eval_lua

add_exec_search_path("conf")
add_exec_search_path("script")
add_exec_search_path("script/module")
script_base_dir = "script/base"

exec(script_base_dir .. "/pcall.lua")
exec(script_base_dir.."/core_function_overloads.lua")
exec(script_base_dir.."/event.lua")
exec(script_base_dir.."/server.lua")
exec(script_base_dir.."/globals.lua")
exec(script_base_dir.."/serverexec.lua")


exec(script_base_dir.."/config.lua")
exec(script_base_dir.."/utils.lua")
exec(script_base_dir.."/tables.lua")


exec_if_found("conf/server_conf.lua")
exec("base/saveconf.lua")


-- noobmod
exec(script_base_dir .. "/db.lua")
exec(script_base_dir .. "/nm_messages.lua")
exec(script_base_dir .. "/players.lua")
exec(script_base_dir .. "/entities.lua")
-- --

exec(script_base_dir.."/module.lua")
exec(script_base_dir.."/logging.lua")
exec(script_base_dir.."/restart.lua")
exec(script_base_dir.."/player/utils.lua")
exec(script_base_dir.."/player/vars.lua")
exec(script_base_dir.."/player/object.lua")
exec(script_base_dir.."/player/iterators.lua")
exec(script_base_dir.."/player/private_vars.lua")
exec_if_found("conf/commands.lua")

exec(script_base_dir.."/player/command.lua")
exec(script_base_dir.."/team/utils.lua")
exec(script_base_dir.."/setmaster.lua")
exec(script_base_dir.."/kickban.lua")
exec(script_base_dir.."/server_message.lua")
exec(script_base_dir.."/cheat_detection.lua")



--server.event_handler("started", function()
--    server.reload_maprotation()

--    server.log_status(messages[messages.languages.default].server_start_message)
--end)

server.event_handler("shutdown", function()
    server.log_status("Server shutting down.")
end)

