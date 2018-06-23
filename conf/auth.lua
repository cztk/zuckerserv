auth.directory.server{
    id = "tbmc.party",
    hostname = "to.tbmc.party",
    port = 28787
}

auth.directory.domain{
    id = "tbmc",
    server = "tbmc.party"
}

auth.directory.domain{
    id = "tbmc:master",
    server = "tbmc.party"
}

auth.directory.domain{
    id = "tbmc:admin",
    server = "tbmc.party"
}

