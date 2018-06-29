#include "sharedstructs.hpp"
#include "lua/push.hpp"
#include <vector>

namespace lua{

nil_type nil;

void push(lua_State  * L, nil_type)
{
    lua_pushnil(L);
}

void push(lua_State  * L, bool value)
{
    lua_pushboolean(L, static_cast<int>(value));
}

void push(lua_State  * L, int value)
{
    lua_pushinteger(L, value);
}

void push(lua_State  * L, lua_Number value)
{
    lua_pushnumber(L, value);
}

void push(lua_State  * L, lua_CFunction value)
{
    lua_pushcfunction(L, value);
}

void push(lua_State  * L, const char * value)
{
    lua_pushstring(L, value);
}

void push(lua_State  * L, const char * value, std::size_t length)
{
    lua_pushlstring(L, value, length);
}

void push(lua_State  * L, const std::string & value)
{
    lua_pushlstring(L, value.data(), value.length());
}

void push(lua_State* L, std::vector<rlPlayerCnType> const& vec)
{
    lua_createtable(L,0, 2);
    for (unsigned int j = 0; j < vec.size(); j++)
    {
        // table index
        lua_pushnumber(L, j+1);
        lua_createtable(L,0,6);

        lua_pushstring(L, vec[j].name);
        lua_setfield(L, -2, "name");

        lua_pushnumber(L, vec[j].cn);
        lua_setfield(L, -2, "cn");

        lua_pushnumber(L, vec[j].owntimems);
        lua_setfield(L, -2, "owntimems");

        lua_pushnumber(L, vec[j].lastowntime);
        lua_setfield(L, -2, "lastowntime");

        lua_pushnumber(L, vec[j].passcount);
        lua_setfield(L, -2, "passcount");

        lua_pushboolean(L, vec[j].stoleflagfirst);
        lua_setfield(L, -2, "stoleflagfirst");

        lua_pushnumber(L, vec[j].passcount);
        lua_setfield(L, -2, "distance");

        lua_settable(L, -3);
    }
}

} //namespace lua

