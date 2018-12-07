--[[

ztk note: please don't use / rely on this, it is just here for quick compat mode to some noobish files
some stuff is indeed win but this for example is fail
- insert ignore by default is bad
- db. and only mysql? bad
- db let alone bad
- more stuff but yeah more arguments and I could rewrite this :D

]]

--[[
	Script:			noobmod/db.lua
	Authors:		Hanack (Andreas Schaeffer)
	Created:		23-Oct-2010
	Last Modified:	01-Jun-2013
	License: GPL3

	Description:
		Database abstraction layer for mysql.

	API:
		db.insert(db_table, data)
			Inserts a row into table db_table; data is a table which contains
			key-value pairs.
			Example: db.insert("users", { id=1, name="Peter", pass="***" })
		db.update(db_table, data, where)
			Updates the table db_table; data is a table which contains key-
			value pairs. The where clause specifies which rows will be
			updated.
		db.insert_or_update(db_table, data, where)
			Inserts a row into db_table if the where clause didn't returned a
			result (see db.insert). Otherwise db_table gets updates (see
			db.update).
		db.select(db_table, keys, where)
			Selects data from table db_table; keys is a list of columns
			which should appear in the result; where is a table containing
			key-value pairs. The function returns a table which contains
			the resulting rows and can be iterated by ipairs(). Each row
			entry contains key-value pairs. 
			Example: result = db.select("users", {"id"}, { name="Peter", pass="***" })
		db.select_and(db_table, keys, where)
		db.select_or(db_table, keys, where)
		db.delete(db_table, where)
			Deletes row(s) from db_table. The where clause specifies which
			rows will be deleted.
		db.escape(string)
			Returns the escaped string
]]



require "luasql_mysql"
luasql = require("luasql_mysql")
--[[
		API
]]

db = {}
db.debug = 0
db.keep_alive_interval = 6000
db.env = assert(luasql.mysql())
db.con = assert(db.env:connect(server.stats_mysql_database, server.stats_mysql_username, server.stats_mysql_password, server.stats_mysql_hostname, server.stats_mysql_port))
db.templates = {}
db.templates.select = [[SELECT %s FROM %s]]
db.templates.selectWhere = [[SELECT %s FROM %s WHERE %s]]
db.templates.selectOrderBy = [[SELECT %s FROM %s WHERE %s ORDER BY %s]]
db.templates.insert = [[INSERT IGNORE INTO %s (%s) VALUES (%s)]]
db.templates.update = [[UPDATE %s SET %s WHERE %s]]
db.templates.delete = [[DELETE FROM %s WHERE %s]]

function db.parseDateTime(str)
	--"2011-10-25T00:29:55.503-04:00"
	local pattern = "(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)"
	local xyear, xmonth, xday, xhour, xminute, xseconds = str:match(pattern)
	return os.time({year = xyear, month = xmonth, day = xday, hour = xhour, min = xminute, sec = xseconds})
end

function db.escape(s)
	if s ~= nil then
		return db.con:escape(s) -- Note: We use the inofficial escape method of luasql
	end
	return nil
end

function db.insert(db_table, data)
	local keys = {}
	local values = {}
	for key, value in pairs(data) do
		table.insert(keys, key)
		if utils.is_numeric(value) then 
			table.insert(values, value)
		else
			table.insert(values, string.format("'%s'", db.escape(value)))
		end
	end
	local keys_string = table.concat(keys, ", ")
	local values_string = table.concat(values, ", ")
	local sql = string.format(db.templates.insert, db_table, keys_string, values_string)
	local cur = assert (db.con:execute(sql))
    local cur = assert (db.con:execute("SELECT last_insert_id()"))
    if not cur then return nil end
    return cur:fetch()
end

function db.update(db_table, data, where)
	local sql = string.format(db.templates.update, db_table, db.get_fields_string(data), where)
	local cur = assert (db.con:execute(sql))
end

function db.insert_or_update(db_table, data, where)
	local data2 = db.select(db_table, {"*"}, where)
	if #data2 > 0 then
		db.update(db_table, data, where)
	else
		return db.insert(db_table, data)
	end
end

function db.delete(db_table, where)
	local sql = string.format(db.templates.delete, db_table, where)
	local cur = assert (db.con:execute(sql))
end

-- like db.select() but formats and escapes the where clause
function db.select_and(db_table, keys, where)
	return db.select(db_table, keys, db.get_where(where, " AND "), orderBy)
end

-- like db.select() but formats and escapes the where clause
function db.select_or(db_table, keys, where)
	return db.select(db_table, keys, db.get_where(where, " OR "), orderBy)
end

function db.select(db_table, keys, where, orderBy)
	local data = {}
	local keys_string = table.concat(keys, ", ")
	local sql = ""
	if where ~= nil then
		if orderBy ~= nil then
			sql = string.format(db.templates.selectOrderBy, keys_string, db_table, where, orderBy)
		else
			sql = string.format(db.templates.selectWhere, keys_string, db_table, where)
		end
	else
		sql = string.format(db.templates.select, keys_string, db_table)
	end
	assert(db.con:execute("SET NAMES 'utf8'"))
	local cur = assert (db.con:execute(sql))
	if cur:numrows() > 0 then
		local row = cur:fetch ({}, "a")
		while row do
			table.insert(data, utils.table_copy(row))
			row = cur:fetch (row, "a")
		end
	end
	return data
end

function db.select_raw(sql)
	local data = {}
	assert(db.con:execute("SET NAMES 'utf8'"))
	local cur = assert (db.con:execute(sql))
	if cur:numrows() > 0 then
		local row = cur:fetch ({}, "a")
		while row do
			table.insert(data, utils.table_copy(row))
			row = cur:fetch (row, "a")
		end
	end
	return data
end

function db.get_where(where, op)
	local where_values = {}
	for key, value in pairs(where) do
		if utils.is_numeric(value) then 
			table.insert(where_values, string.format("%s = %i", key, value))
		else
			table.insert(where_values, string.format("%s = '%s'", key, db.escape(value)))
		end
	end
	return table.concat(where_values, op)
end

function db.get_fields_string(data)
	local fields_values = {}
	for key, value in pairs(data) do
		if utils.is_numeric(value) then 
			table.insert(fields_values, string.format("%s = %i", key, value))
		else
			table.insert(fields_values, string.format("%s = '%s'", key, db.escape(value)))
		end
	end
	return table.concat(fields_values, ", ")
end

function db.create_table(db_table, schema)
	local sql = ""
	for key, value in pairs(schema) do
		-- TODO
	end
end

function db.keep_alive()
--	local sql = string.format(db.templates.select, "nmsrvid", "nm5_servers")
--	local cur = assert (db.con:execute(sql))
end



--[[
		EVENTS
]]

--server.event_handler("started", function()
	-- refreshing database connection periodically
--	eventmanager.register_interval(db.keep_alive_interval, db.keep_alive)
--end)
