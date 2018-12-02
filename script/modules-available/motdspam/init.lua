local spam_motd = function(cn)
  server.msg( server.motdspam[math.random(#server.motdspam)] )
end

server.interval(164300, spam_motd)
