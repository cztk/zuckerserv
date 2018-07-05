#ifndef SUCK_SHSTR_HEADER_FILE_IS_INCLUDED

#define SUCK_SHSTR_HEADER_FILE_IS_INCLUDED

// RUGBY MOD quick hack, dunno what happens if I reference clientinfo in flag and client
// disconnects. Now I can check if cn exists && cn.playername still name == probably good enough
struct rlPlayerCnType {
    char name[160];
    int cn;
    int owntimems;
    int lastowntime;
    int passcount;
    bool stoleflagfirst;
    int distance;
};

struct spawn_mode_struct {
 int health;
 int armour;
 int armourtype;
 int quadmillis;
 int gunselect;
 std::array<int, 12> guns{ {0,0,0,0,0,0,0,0,0,0,0,0} };
};
#endif 
