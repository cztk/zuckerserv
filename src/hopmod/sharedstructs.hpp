// RUGBY MOD quick hack, dunno what happens if I reference clientinfo in flag and client
// disconnects. Now I can check if cn exists && cn.playername still name == probably good enough
struct rlPlayerCnType {
    char name[160];
    int cn;
    int owntimems;
    int lastowntime;
    int passcount;
    bool stoleflagfirst;
};

