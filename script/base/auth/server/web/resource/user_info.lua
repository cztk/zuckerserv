require "http_server"
require "Json"

local function user(domain, name)
    local output = {}
    users = server.listusers(domain)

    output.name = name
    output.domain = domain
    output.pubkey = users[name].pubkey
    output.priv = users[name].privilege

    return output
end

local function list_users(domain)
    local result = {}

    if not internal.domains[domain]
    then
        server.log_error("list_users: Domain, " .. domain .. " does not exist.")
        return {}
    end

    local users, err = server.listusers(domain)
    if err
    then
        server.log_error("list_users (backend): " .. err)
        return {}
    end

    if not next(users)
    then
        server.log("No users in " .. domain .. ".")
    else
        server.log("Users in " .. domain .. ":")

        for name, _ in pairs(users)
        do
            table.insert(result, name)
        end
    end

    return result
end

local function users(domain)
    local result = {}

    if not domain then
        for domain, _ in pairs(internal.domains)
        do
            result[domain] = {}
            for _, name in pairs(list_users(domain))
            do
                table.insert(result[domain], user(domain, name))
            end
        end
    else
        result[domain] = list_users(domain)
    end

    return result
end


http_server_root["users"] = http_server.resource({
    resolve = function(domain)
        return http_server.resource({
            resolve = function(name)
                return http_server.resource({
                    get = function(request)
                        http_response.send_json(request, user(domain, name))
                    end
                })
            end
        })
    end,

    resolve = function(domain)
        return http_server.resource({
            get = function(request)
                http_response.send_json(request, users(domain))
            end
        })
    end,

    get = function(request)
--        local uri_query_params = http_request.parse_query_string(request:uri_query() or "")
        http_response.send_json(request, users(false))
    end
})
