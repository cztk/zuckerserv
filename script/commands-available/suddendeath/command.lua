-- #suddendeath [0|off|1|on]
-- #sd
-- #nosd

local help ="Enables or disables suddendeath on ties"
local usage = "[0|off|1|on]"
local permission = 1
local enabled = true
local aliases = {"sd"}

local init = function()
    if(true == enabled and not server.suddendeath) then
        server.log(string.format("WARN: command #suddendeath is enabled but suddendeath module not loaded!"))
        enabled = false
    end
end


local function run(cn, option)
  if false == enabled then
    return false
  end
  
  if not option  then
    return false, usage
  end
  
  if option == "0" or option == "off" then
    server.suddendeath()
    server.player_msg(cn, "Suddendeath mode disabled. There may be ties.")
  elseif option == "1" or option == "on" then
    server.suddendeath(true)
    server.player_msg(cn, "Suddendeath mode enabled. There will be no ties.")
  else
    return false, usage
  end
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        help_message = help,
        help_parameters = usage,
        aliases = aliases
}
