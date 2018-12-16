#ifndef HOPMOD_LUA_NET_RESOLVER_HPP
#define HOPMOD_LUA_NET_RESOLVER_HPP

#include <luajit-2.1/lua.hpp>

namespace lua{

int async_resolve(lua_State  * L);

} //namespace lua

#endif

