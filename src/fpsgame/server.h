namespace server
{

    #define MM_MODE 0xF
    #define MM_AUTOAPPROVE 0x1000
    #define MM_PRIVSERV (MM_MODE | MM_AUTOAPPROVE)
    #define MM_PUBSERV ((1<<MM_OPEN) | (1<<MM_VETO))
    #define MM_COOPSERV (MM_AUTOAPPROVE | MM_PUBSERV | (1<<MM_LOCKED))
    #define MAXDEMOS 5
    #define MAXSPIES 5
    #define MAXDEMOSIZE (16*1024*1024)


    struct clientinfo;

    struct delayed_sendpacket
    {
        int     time;
        int     channel;
        void *  data;
        int     length;
    };

    #define anticheat_class
    #include "anticheat.h"
    #undef anticheat_class
    
    struct gameevent
    {
        virtual ~gameevent() {}

        virtual bool flush(clientinfo *ci, int fmillis);
        virtual void process(clientinfo *ci) {}

        virtual bool keepable() const { return false; }
    };

    struct timedevent : gameevent
    {
        int millis;

        bool flush(clientinfo *ci, int fmillis);
    };

    struct hitinfo
    {
        int target;
        int lifesequence;
        int rays;
        float dist;
        vec dir;
    };

    struct shotevent : timedevent
    {
        int id, gun;
        vec from, to;
        vector<hitinfo> hits;

        void process(clientinfo *ci);
    };

    struct explodeevent : timedevent
    {
        int id, gun;
        vector<hitinfo> hits;

        bool keepable() const { return true; }

        void process(clientinfo *ci);
    };

    struct suicideevent : gameevent
    {
        void process(clientinfo *ci);
    };

    struct pickupevent : gameevent
    {
        int ent;

        void process(clientinfo *ci);
    };

    template <int N>
    struct projectilestate
    {
        int projs[N];
        int numprojs;

        projectilestate() : numprojs(0) {}

        void reset() { numprojs = 0; }

        void add(int val)
        {
            if(numprojs>=N) numprojs = 0;
            projs[numprojs++] = val;
        }

        bool remove(int val)
        {
            loopi(numprojs) if(projs[i]==val)
            {
                projs[i] = projs[--numprojs];
                return true;
            }
            return false;
        }
    };

    struct gamestate : fpsstate
    {
        vec o, cam;
        int state, editstate;
        int lastdeath, deadflush, lastspawn, lifesequence;
        int lastshot;
        projectilestate<8> rockets, grenades;
        int frags, flags, deaths, suicides, teamkills, shotdamage, damage, explosivedamage, tokens, hits, misses, shots;
        int lasttimeplayed, timeplayed;
        float effectiveness;
        int disconnecttime;
        
        gamestate() : state(CS_DEAD), editstate(CS_DEAD), lifesequence(0), disconnecttime(0) {}
    
        bool isalive(int gamemillis)
        {
            return state==CS_ALIVE || (state==CS_DEAD && gamemillis - lastdeath <= DEATHMILLIS);
        }

        bool waitexpired(int gamemillis)
        {
            return gamemillis - lastshot >= gunwait;
        }

        void reset()
        {
            if(state!=CS_SPECTATOR) state = editstate = CS_DEAD;
            maxhealth = 100;
            rockets.reset();
            grenades.reset();

            timeplayed = 0;
            effectiveness = 0;
            frags = flags = deaths = suicides = teamkills = shotdamage = explosivedamage = damage = hits = misses = shots = tokens = 0;
            
            lastdeath = 0;

            respawn();
        }

        void respawn()
        {
            fpsstate::respawn();
            o = vec(-1e10f, -1e10f, -1e10f);
            deadflush = 0;
            lastspawn = -1;
            lastshot = 0;
            tokens = 0;
        }

        void reassign()
        {
            respawn();
            rockets.reset();
            grenades.reset();
        }
    };

    struct savedscore
    {
        uint ip;
        string name;
        int maxhealth, frags, flags, deaths, suicides, teamkills, shotdamage, explosivedamage, damage, hits, misses, shots;
        int timeplayed;
        float effectiveness;
        int disconnecttime;
        
        void save(gamestate &gs)
        {
            maxhealth = gs.maxhealth;
            frags = gs.frags;
            flags = gs.flags;
            deaths = gs.deaths;
            suicides = gs.suicides;
            teamkills = gs.teamkills;
            shotdamage = gs.shotdamage;
            explosivedamage = gs.explosivedamage;
            damage = gs.damage;
            timeplayed = gs.timeplayed;
            effectiveness = gs.effectiveness;
            hits = gs.hits;
            misses = gs.misses;
            shots = gs.shots;
            disconnecttime = gs.disconnecttime;
        }

        void restore(gamestate &gs)
        {
            if(gs.health==gs.maxhealth) gs.health = maxhealth;
            gs.maxhealth = maxhealth;
            gs.frags = frags;
            gs.flags = flags;
            gs.deaths = deaths;
            gs.suicides = suicides;
            gs.teamkills = teamkills;
            gs.shotdamage = shotdamage;
            gs.explosivedamage = explosivedamage;
            gs.damage = damage;
            gs.timeplayed = timeplayed;
            gs.effectiveness = effectiveness;
            gs.hits = hits;
            gs.misses = misses;
            gs.shots = shots;
            gs.disconnecttime = disconnecttime;
        }
    };



    struct clientinfo
    {
        int n;
        int clientnum, ownernum, connectmillis, specmillis, sessionid, overflow, playerid;
        string name, team, mapvote;
        int playermodel;
        int modevote;
        int privilege;
        bool hide_privilege;
        bool connected, local, timesync;
        int gameoffset, lastevent, pushed, exceeded;
        gamestate state;
        vector<gameevent *> events;
        vector<uchar> position, messages;
        uchar *wsdata;
        int wslen;
        vector<clientinfo *> bots;
        int ping, lastpingupdate, lastposupdate, lag, aireinit;
        string clientmap;
        int mapcrc;
        int no_spawn;
        bool warned, gameclip;
        ENetPacket *getdemo, *getmap, *clipboard;
        int lastclipboard, needclipboard;
        int connectauth;
        string authname, authdesc;
        int authkickvictim;
        char *authkickreason;

        int clientmillis;
        int timetrial;

        anticheat ac;

        bool spy;
        int last_lag;
        
        ullong n_text_millis;
        ullong n_sayteam_millis;
        ullong n_mapvote_millis;
        ullong n_switchname_millis;
        ullong n_switchteam_millis;
        ullong n_kick_millis;
        ullong n_remip_millis;
        ullong n_newmap_millis;
        ullong n_spec_millis;
        
        std::string disconnect_reason;
        int maploaded;
        int rank;
        bool using_reservedslot;
        bool allow_self_unspec;
        
        clientinfo():
            getdemo(NULL),
            getmap(NULL),
            clipboard(NULL),
            authkickreason(NULL),
            n_text_millis(0),
            n_sayteam_millis(0),
            n_mapvote_millis(0),
            n_switchname_millis(0),
            n_switchteam_millis(0),
            n_kick_millis(0),
            n_remip_millis(0),
            n_newmap_millis(0),
            n_spec_millis(0) 
            
        { reset(); }
        
        ~clientinfo() { events.deletecontents(); cleanclipboard(); }
        
        void addevent(gameevent *e)
        {
            if(state.state==CS_SPECTATOR || events.length()>100) delete e;
            else events.add(e);
        }

        enum
        {
            PUSHMILLIS = 3000
        };
        
        int calcpushrange()
        {
            ENetPeer *peer = getclientpeer(ownernum);
            return PUSHMILLIS + (peer ? peer->roundTripTime + peer->roundTripTimeVariance : ENET_PEER_DEFAULT_ROUND_TRIP_TIME);
        }

        bool checkpushed(int millis, int range)
        {
            return millis >= pushed - range && millis <= pushed + range;
        }

        void scheduleexceeded()
        {
            if(state.state!=CS_ALIVE || !exceeded) return;
            int range = calcpushrange();
            if(!nextexceeded || exceeded + range < nextexceeded) nextexceeded = exceeded + range;
        }

        void setexceeded()
        {
            if(state.state==CS_ALIVE && !exceeded && !checkpushed(gamemillis, calcpushrange())) exceeded = gamemillis;
            scheduleexceeded(); 
        }
            
        void setpushed()
        {
            pushed = max(pushed, gamemillis);
            if(exceeded && checkpushed(exceeded, calcpushrange())) exceeded = 0;
        }
        
        bool checkexceeded()
        {
            return state.state==CS_ALIVE && exceeded && gamemillis > exceeded + calcpushrange();
        }
        
        void mapchange()
        {
            mapvote[0] = 0;
            modevote = INT_MAX;
            state.reset();
            events.deletecontents();
            overflow = 0;
            timesync = false;
            lastevent = 0;
            exceeded = 0;
            pushed = 0;
            maploaded = 0;
            clientmap[0] = '\0';
            mapcrc = 0;
            warned = false;
            gameclip = false;
        }

        void reassign()
        {
            state.reassign();
            events.deletecontents();
            timesync = false;
            lastevent = 0;
        }
        
        void cleanclipboard(bool fullclean = true)
        {
            if(clipboard) { if(--clipboard->referenceCount <= 0) enet_packet_destroy(clipboard); clipboard = NULL; }
            if(fullclean) lastclipboard = 0;
        }
        
        void cleanauth(bool full = true)
        {
            //authreq = 0;
            //if(authchallenge) { freechallenge(authchallenge); authchallenge = NULL; }
            if(full) cleanauthkick();
        }

        void cleanauthkick()
        {
            authkickvictim = -1;
            DELETEA(authkickreason);
        }
        
        void reset()
        {
            name[0] = team[0] = 0;
            playermodel = -1;
            privilege = PRIV_NONE;
            hide_privilege = false;
            connected = local = false;
            connectauth = 0;
            position.setsize(0);
            messages.setsize(0);
            ping = 0;
            lastpingupdate = 0;
            lastposupdate = 0;
            lag = 0;

            ac.reset();

            clientmillis = 0;
            last_lag = 0;
            spy = false;
            timetrial = 0;
            no_spawn = 0;

            aireinit = 0;
            using_reservedslot = false;
            needclipboard = 0;
            cleanclipboard();
            cleanauth();
            mapchange();
        }
        
        int geteventmillis(int servmillis, int clientmillis)
        {
            if(!timesync || (events.empty() && state.waitexpired(servmillis)))
            {
                timesync = true;
                gameoffset = servmillis - clientmillis;
                return servmillis;
            }
            else return gameoffset + clientmillis;
        }

        void sendprivtext(const char * text)
        {
            if(state.aitype != AI_NONE) return;//TODO assert(false) to catch bugs
            sendf(clientnum, 1, "ris", N_SERVMSG, text);
        }
        
        const char * hostname()const
        {
            static char hostname_buffer[16];            
            ENetAddress addr;
            addr.host = getclientip(clientnum);
            return ((enet_address_get_host_ip(&addr, hostname_buffer, sizeof(hostname_buffer)) == 0) ? hostname_buffer : "unknown");
        }
        
        bool is_delayed_spectator()const
        {
            return spectator_delay && state.state == CS_SPECTATOR && privilege != PRIV_ADMIN;
        }
    };
    
    struct worldstate
    {
        int uses, len;
        uchar *data;

        worldstate() : uses(0), len(0), data(NULL) {}

        void setup(int n) { len = n; data = new uchar[n]; }
        void cleanup() { DELETEA(data); len = 0; }
        bool contains(const uchar *p) const { return p >= data && p < &data[len]; }
    };

    struct ban
    {
        int time, expire;
        uint ip;
    };

    namespace aiman 
    {
        extern bool dorefresh, botbalance;
        extern int botlimit;
        extern void removeai(clientinfo *ci);
        extern void clearai();
        extern void checkai();
        extern void reqadd(clientinfo *ci, int skill);
        extern void reqdel(clientinfo *ci);
        extern void setbotlimit(clientinfo *ci, int limit);
        extern void setbotbalance(clientinfo *ci, bool balance);
        extern void changemap();
        extern void addclient(clientinfo *ci);
        extern void changeteam(clientinfo *ci);
        extern clientinfo * addai(int skill, int limit);
        extern bool deleteai();
        extern void deleteai(clientinfo *);
    };

    struct demofile
    {
        string info;
        uchar *data;
        int len;
    };

    struct servmode
    {
        virtual ~servmode() {}

        virtual void entergame(clientinfo *ci) {}
        virtual void leavegame(clientinfo *ci, bool disconnecting = false) {}

        virtual void moved(clientinfo *ci, const vec &oldpos, bool oldclip, const vec &newpos, bool newclip) {}
        virtual bool canspawn(clientinfo *ci, bool connecting = false) { return true; }
        virtual void spawned(clientinfo *ci) {}
        virtual int fragvalue(clientinfo *victim, clientinfo *actor)
        {
            if(victim==actor || isteam(victim->team, actor->team)) return -1;
            return 1;
        }
        virtual void died(clientinfo *victim, clientinfo *actor) {}
        virtual bool canchangeteam(clientinfo *ci, const char *oldteam, const char *newteam) { return true; }
        virtual void changeteam(clientinfo *ci, const char *oldteam, const char *newteam) {}
        virtual void initclient(clientinfo *ci, packetbuf &p, bool connecting) {}
        virtual void update() {}
        virtual void cleanup() {}
        virtual void setup() {}
        virtual void newmap() {}
        virtual void intermission() {}
        virtual bool hidefrags() { return false; }
        virtual int getteamscore(const char *team) { return 0; }
        virtual void getteamscores(vector<teamscore> &scores) {}
        virtual bool extinfoteam(const char *team, ucharbuf &p) { return false; }
    };

    struct teamrank
    {
        const char *name;
        float rank;
        int clients;

        teamrank(const char *name) : name(name), rank(0), clients(0) {}
    };

    static struct msgfilter
    {
        uchar msgmask[NUMMSG];

        msgfilter(int msg, ...)
        {
            memset(msgmask, 0, sizeof(msgmask));
            va_list msgs;
            va_start(msgs, msg);
            for(uchar val = 1; msg < NUMMSG; msg = va_arg(msgs, int))
            {
                if(msg < 0) val = uchar(-msg);
                else msgmask[msg] = val;
            }
            va_end(msgs);
        }
        uchar operator[](int msg) const { return msg >= 0 && msg < NUMMSG ? msgmask[msg] : 0; }
    #if PROTOCOL_VERSION < 260
    } msgfilter(-1, N_CONNECT, N_SERVINFO, N_INITCLIENT, N_WELCOME, N_MAPCHANGE, N_SERVMSG, N_DAMAGE, N_HITPUSH, N_SHOTFX, N_EXPLODEFX, N_DIED, N_SPAWNSTATE, N_FORCEDEATH, N_TEAMINFO, N_ITEMACC, N_ITEMSPAWN, N_TIMEUP, N_CDIS, N_CURRENTMASTER, N_PONG, N_RESUME, N_BASESCORE, N_BASEINFO, N_BASEREGEN, N_ANNOUNCE, N_SENDDEMOLIST, N_SENDDEMO, N_DEMOPLAYBACK, N_SENDMAP, N_DROPFLAG, N_SCOREFLAG, N_RETURNFLAG, N_RESETFLAG, N_INVISFLAG, N_CLIENT, N_AUTHCHAL, N_INITAI, N_EXPIRETOKENS, N_DROPTOKENS, N_STEALTOKENS, N_DEMOPACKET, -2, N_REMIP, N_NEWMAP, N_GETMAP, N_SENDMAP, N_CLIPBOARD, -3, N_EDITENT, N_EDITF, N_EDITT, N_EDITM, N_FLIP, N_COPY, N_PASTE, N_ROTATE, N_REPLACE, N_DELCUBE, N_EDITVAR, -4, N_POS, NUMMSG),
      connectfilter(-1, N_CONNECT, -2, N_AUTHANS, -3, N_PING, NUMMSG);

    #else
    } msgfilter(-1, N_CONNECT, N_SERVINFO, N_INITCLIENT, N_WELCOME, N_MAPCHANGE, N_SERVMSG, N_DAMAGE, N_HITPUSH, N_SHOTFX, N_EXPLODEFX, N_DIED, N_SPAWNSTATE, N_FORCEDEATH, N_TEAMINFO, N_ITEMACC, N_ITEMSPAWN, N_TIMEUP, N_CDIS, N_CURRENTMASTER, N_PONG, N_RESUME, N_BASESCORE, N_BASEINFO, N_BASEREGEN, N_ANNOUNCE, N_SENDDEMOLIST, N_SENDDEMO, N_DEMOPLAYBACK, N_SENDMAP, N_DROPFLAG, N_SCOREFLAG, N_RETURNFLAG, N_RESETFLAG, N_INVISFLAG, N_CLIENT, N_AUTHCHAL, N_INITAI, N_EXPIRETOKENS, N_DROPTOKENS, N_STEALTOKENS, N_DEMOPACKET, -2, N_REMIP, N_NEWMAP, N_GETMAP, N_SENDMAP, N_CLIPBOARD, -3, N_EDITENT, N_EDITF, N_EDITT, N_EDITM, N_FLIP, N_COPY, N_PASTE, N_ROTATE, N_REPLACE, N_DELCUBE, N_EDITVAR, N_EDITVSLOT, N_UNDO, N_REDO, -4, N_POS, NUMMSG),
      connectfilter(-1, N_CONNECT, -2, N_AUTHANS, -3, N_PING, NUMMSG);
    #endif

    struct votecount
    {
        char *map;
        int mode, count;
        votecount() {}
        votecount(char *s, int n) : map(s), mode(n), count(0) {}
    };

    struct crcinfo
    {
        int crc, matches;

        crcinfo() {}
        crcinfo(int crc, int matches) : crc(crc), matches(matches) {}

        static bool compare(const crcinfo &x, const crcinfo &y) { return x.matches > y.matches; }
    };

    void *newclientinfo();
    void deleteclientinfo(void *ci);
    clientinfo *getinfo(int n);
    clientinfo * get_ci(int cn);
    void real_cn(int &n);
    void set_spy(int cn, bool val);
    inline int spy_cn(clientinfo *ci)
    {
        if(ci && ci->spy) return ci->clientnum;
        return -1;
    }
    int spec_count();
    // capture, ctf, collect stuff
    // skip pass  has flag
    inline bool canspawnitem(int type){ return !m_noitems && (type>=I_SHELLS && type<=I_QUAD && (!m_noammo || type<I_SHELLS || type>I_CARTRIDGES)); }
    int spawntime(int type);
    bool delayspawn(int type);
    int msgsizelookup(int msg);
    const char *modename(int n, const char *unknown);
    int modecode(const char * modename);
    const char *mastermodename(int n, const char *unknown);
    const char *privname(int type);
    void sendservmsg(const char *s);
    void sendservmsgf(const char *fmt, ...);
    void resetitems();
    bool serveroption(const char *arg);
    void cleanup_fpsgame(int shutdown_type);
    void serverinit();
    int numclients(int exclude = -1, bool nospec = true, bool noai = true, bool priv = false);
    bool duplicatename(clientinfo *ci, const char *name);
    const char *colorname(clientinfo *ci, const char *name = NULL);
    bool pickup(int i, int sender);         // server side item pickup, acknowledge first client that gets it
    void clearteaminfo();
    bool teamhasplayers(const char *team);
    bool pruneteaminfo();
    teaminfo *addteaminfo(const char *team);
    clientinfo *choosebestclient(float &bestrank);
    void autoteam();
    
    extern void setspectator(clientinfo * spinfo, bool val, bool broadcast=true);
    void sendresume(clientinfo *ci);
    void sendinitclient(clientinfo *ci);
    void sendservinfo(clientinfo *ci);
    bool restorescore(clientinfo *ci);
    const char *chooseworstteam(const char *suggest = NULL, clientinfo *exclude = NULL);
    void writedemo(int chan, void *data, int len);
    void write_delayed_broadcast(int chan, void * data, int len);
    void recordpacket(int chan, void *data, int len);
    void enddemorecord();
    int welcomepacket(packetbuf &p, clientinfo *ci);
    void sendwelcome(clientinfo *ci);
    void setupdemorecord(bool broadcast = true, const char * filename = NULL);
    void listdemos(int cn);
    void cleardemos(int n);
    static void freegetmap(ENetPacket *packet);
    static void freegetdemo(ENetPacket *packet);
    void senddemo(clientinfo *ci, int num);
    void enddemoplayback();
    void setupdemoplayback();
    void readdemo();
    void stopdemo();
    void pausegame(bool val);
    void pausegame(bool val, clientinfo * ci);
    void checkpausegame();
    void forcepaused(bool paused);
    void changegamespeed(int val, clientinfo *ci = NULL);
    void forcegamespeed(int speed);
    void hashpassword(int cn, int sessionid, const char *pwd, char *result, int maxlen);
    bool checkpassword(clientinfo *ci, const char *wanted, const char *given);
    void revokemaster(clientinfo *ci);
    bool setmaster(clientinfo *ci, bool request_claim_master, const char * hashed_password = "", const char *authname = NULL);
    bool trykick(clientinfo *ci, int victim, const char *reason = NULL, const char *authname = NULL, const char *authdesc = NULL, int authpriv = PRIV_NONE, bool trial = false);
    savedscore *findscore(clientinfo *ci, bool insert);
    void savescore(clientinfo *ci);
    int checktype(int type, clientinfo *ci, clientinfo *cq, packetbuf &p); //NEW (thomas): clientinfo *cq, packetbuf &p)
    void cleanworldstate(ENetPacket *packet);
    void flushclientposition(clientinfo &ci);
    static void sendpositions(worldstate &ws, ucharbuf &wsbuf);
    static void addposition(worldstate &ws, ucharbuf &wsbuf, int mtu, clientinfo &bi, clientinfo &ci);
    static void sendmessages(worldstate &ws, ucharbuf &wsbuf);
    static void addmessages(worldstate &ws, ucharbuf &wsbuf, int mtu, clientinfo &bi, clientinfo &ci);
    bool buildworldstate();
    inline void free_packet_data(ENetPacket * packet)
    {
        free(packet->data);
    }
    bool sendpackets(bool force);
    template<class T>
    void sendstate(gamestate &gs, T &p);
    void spawnstate(clientinfo *ci);
    void sendspawn(clientinfo *ci);
    void sendwelcome(clientinfo *ci);
    void putinitclient(clientinfo *ci, packetbuf &p);
    void welcomeinitclient(packetbuf &p, int exclude = -1);
    bool hasmap(clientinfo *ci);
    int welcomepacket(packetbuf &p, clientinfo *ci);
    bool restorescore(clientinfo *ci);
    void sendresume(clientinfo *ci);
    void sendinitclient(clientinfo *ci);
    void loaditems();
    void changemap(const char *s, int mode,int mins = -1);
    bool rotatemap();
    const char *votedbestmap();
    void checkvotes(bool force = false);
    void forcemap(const char *map, int mode);
    void vote(const char *map, int reqmode, int sender);
    void checkintermission();
    void startintermission();
    void dodamage(clientinfo *target, clientinfo *actor, int damage, int gun, const vec &hitpush = vec(0, 0, 0));
    void suicide(clientinfo *ci);
    void clearevent(clientinfo *ci);
    void flushevents(clientinfo *ci, int millis);
    void processevents();
    void cleartimedevents(clientinfo *ci);
    void serverupdate();
    void sendservinfo(clientinfo *ci);
    void noclients();
    void localconnect(int n);
    void localdisconnect(int n);
    int clientconnect(int n, uint ip);
    void clientdisconnect(int n,int reason);
    int allowconnect(clientinfo *ci, const char *pwd);
    bool allowbroadcast(int n);
    bool tryauth(clientinfo *ci, const char * user, const char * domain, int kickcn = -1);
    void answerchallenge(clientinfo *ci, uint id, char *val, const char * desc);
    void receivefile(int sender, uchar *data, int len);
    void sendclipboard(clientinfo *ci);
    void setspectator(clientinfo * spinfo, bool val, bool broadcast);
    void connected(clientinfo *ci);
    void parsepacket(int sender, int chan, packetbuf &p);
    //extinfo skipped
    void serverinforeply(ucharbuf &req, ucharbuf &p);
    bool servercompatible(char *name, char *sdec, char *map, int ping, const vector<int> &attr, int np);
    // hopmod
    // aiman
};
