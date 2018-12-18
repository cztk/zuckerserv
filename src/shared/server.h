#define SAUERBRATEN_LANINFO_PORT 28784
#define SAUERBRATEN_SERVER_PORT 28785
#define SAUERBRATEN_SERVINFO_PORT 28786
#define SAUERBRATEN_MASTER_PORT 28787


namespace server {


    extern int gamemode;
    extern int DEATHMILLIS;

    extern int nextexceeded;
    extern int gamemillis;

    extern int spectator_delay;

    extern bool gamepaused;
    extern int gamespeed;

    inline int reserveclients() { return 3; }
    inline int laninfoport() { return SAUERBRATEN_LANINFO_PORT; }
    inline int serverinfoport(int servport = -1) { return servport < 0 ? SAUERBRATEN_SERVINFO_PORT : servport+1; }
    inline int serverport(int infoport = -1) { return infoport < 0 ? SAUERBRATEN_SERVER_PORT : infoport-1; }
    inline const char *defaultmaster() { return "master.sauerbraten.org"; }
    inline int masterport() { return SAUERBRATEN_MASTER_PORT; }
    inline int numchannels() { return 4; }
    inline int scaletime(int t) { return t*gamespeed; }
    inline bool ispaused() { return gamepaused; }
}
