-- #suddendeath [0|off|1|on]
-- #sd
-- #nosd

local permission = 1
local enabled = true
local aliases = {"sd"}

local help = function(cn, command)

    server.player_msg(cn, "Enables or disables suddendeath on ties")
    server.player_msg(cn, "#" .. command .. " [0|off|1|on]")

end

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
    help()
    return false
  end
  
  if option == "0" or option == "off" then
    server.suddendeath()
    server.player_msg(cn, "Suddendeath mode disabled. There may be ties.")
  elseif option == "1" or option == "on" then
    server.suddendeath(true)
    server.player_msg(cn, "Suddendeath mode enabled. There will be no ties.")
  else
    help()
    return false
  end
end

return {
        init = init,
        run = run,
        permission = permission,
        enabled = enabled,
        help_function = help,
        aliases = aliases
}
