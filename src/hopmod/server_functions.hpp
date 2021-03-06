#ifndef HOPMOD_EXTAPI_HPP
#define HOPMOD_EXTAPI_HPP

#include "utils/time.hpp"

extern "C"{
#include <luajit-2.1/lua.h>
}

#include <string>
#include <vector>

// NoobMOD ...
extern void setclienttype(int cn, int type);
// ... NoobMOD

namespace server
{
    struct clientinfo;
    
    namespace aiman
    {
        extern int botlimit;
        extern bool botbalance;
        extern bool deleteai();
    }
    
    extern string serverdesc;
    extern string smapname;
    extern string serverpass;
    extern string serverauth;
    extern string adminpass;
    extern string slotpass;
    extern int currentmaster;
    extern int interm;
    extern bool reassignteams;
    extern int gamemillis;
    extern int gamelimit;
    extern bool gamepaused;
    extern int gamemode;
    extern int intermtime;
    extern unsigned int packetdelay;
    extern stream *mapdata;
    
    extern int mastermode;
    extern int mastermode_owner;
    extern string next_gamemode;
    extern string next_mapname;
    extern int next_gametime;
    
    extern int reservedslots;
    extern int reservedslots_use;
    
    extern bool display_open;
    extern bool allow_mm_veto;
    extern bool allow_mm_locked;
    extern bool allow_mm_private;
    extern bool allow_mm_private_reconnect;
    extern bool reset_mm;
    extern bool allow_item[11];

    extern bool restrictpausegame;
    extern bool restrictgamespeed;

    extern bool broadcast_mapmodified;
    extern timer::time_diff_t timer_alarm_threshold;
    
    extern bool enable_extinfo;
    
    extern int spectator_delay;

    // NoobMOD ...
    extern int ent_id;
    extern int ent_x;
    extern int ent_y;
    extern int ent_z;
    extern int ent_type;
    extern int ent_attr1;
    extern int ent_attr2;
    extern int ent_attr3;
    extern int ent_attr4;
    extern int ent_attr5;
    extern int shotfx_from_x;
    extern int shotfx_from_y;
    extern int shotfx_from_z;
    extern int shotfx_to_x;
    extern int shotfx_to_y;
    extern int shotfx_to_z;
    extern int npos_pos_x;
    extern int npos_pos_y;
    extern int npos_pos_z;
    extern int npos_vel_x;
    extern int npos_vel_y;
    extern int npos_vel_z;
    extern int npos_yaw;
    extern int npos_pitch;
    extern int npos_roll;
    extern int npos_move;
    extern int npos_strafe;
    // ... NoobMOD


    
    namespace message{

        extern int disc_msgs;
        extern int disc_window;
        
        namespace resend_time{
            
            extern unsigned text;
            extern unsigned sayteam;
            extern unsigned mapvote;
            extern unsigned switchname;
            extern unsigned switchteam;
            extern unsigned kick;
            extern unsigned remip;
            extern unsigned newmap;
            extern unsigned spec;
            
        } //namespace resend_time
        
        bool limit(clientinfo *, unsigned long long * millis, unsigned long long resend_time, const char * message_type);
        
        extern string set_player_privilege;
        
    } //namespace message
    
    const char *extfiltertext(const char *src);
    
    void started();
    int hasFlag(int); // RUGBY MOD but useful anyway
    const char * votedbestmap();
    void passflag(int a,int b, int d); // RUGBY MOD
    void player_add_flagcount(int cn, int i); // RUGBY MOD
    void set_spawn_state(int health, int armour,int armourtype,int quadmillis,int gunselect);
    void set_spawn_gun(int gun,int ammo);
    int player_sessionid(int);
    int player_id(lua_State * L);
    int player_ownernum(int);
    void player_msg(int,const char *);
    void server_msg(const char *);
    std::string player_name(int);
    void player_rename(int, const char *, bool);
    std::string player_displayname(int);
    std::string player_team(int);
    const char * player_privilege(int);
    int player_privilege_code(int);
    int player_ping(int);
    int player_ping_update(int);
    int player_lag(int);
    int player_real_lag(int);
    int player_maploaded(int);
    int player_deathmillis(int);
    const char * player_ip(int);
    unsigned long player_iplong(int);
    const char * player_status(int);
    int player_status_code(int);
    int player_frags(int);
    int player_score(int);
    int player_real_frags(int);
    int player_deaths(int);
    int player_suicides(int);
    int player_teamkills(int);
    int player_damage(int);
    int player_damagewasted(int);
    int player_maxhealth(int);
    int player_health(int);
    int player_armour(int);
    int player_armour_type(int);
    int player_gun(int);
    int player_hits(int);
    int player_misses(int);
    int player_shots(int);
    int player_accuracy(int);
    int player_accuracy2(int);
    bool player_is_spy(int cn);
    int player_clientmillis(int);
    int player_timetrial(int);
    int player_connection_time(int);
    bool player_has_joined_game(int);
    void player_join_game(int);
    void player_reject_join_game(int);
    int player_timeplayed(int);
    int player_win(int);
    void player_force_spec(int);
    void player_unforce_spec(int);
    void player_spec(int);
    void player_unspec(int);
    void spec_all();
    int player_bots(int);
    int player_pos(lua_State *);
    bool hasmaster();
    void unsetmaster();
    bool set_player_master(int);
    void set_player_auth(int);
    void set_player_admin(int);
    void player_forgive_tk(int);
    void player_slay(int);
    void player_respawn(int);
    void player_nospawn(int, int);
    bool player_changeteam(int,const char *, bool);
    int player_rank(int);
    bool player_isbot(int);
    void set_player_private_admin(int);
    void set_player_private_master(int);
    void unset_player_privilege(int);
    void set_player_privilege(int, int);
    void player_freeze(int);
    void player_unfreeze(int);

    void updateservinfo(int, const char*);
    void editvar(int, const char *, int);
    void sendmap(int, int);
    int hitpush(lua_State * L);
    void player_change_ammo(int, int, int);
    int player_dodamage(lua_State * L);
    void set_spy(int, bool);

    void team_msg(const char *,const char *);
    std::vector<std::string> get_teams();
    int lua_team_list(lua_State * L);
    int get_team_score(const char * );
    std::vector<int> get_team_players(const char * team);
    int lua_team_players(lua_State *);
    int team_win(const char *);
    int team_draw(const char *);
    int team_size(const char *);
    
    void pausegame(bool);
    void pausegame(bool, clientinfo *);
    
    void kick(int cn,int time,const std::string & admin,const std::string & reason);
    void disconnect(int cn, int code, std::string reason);
    void changetime(int remaining);
    int get_minutes_left();
    void set_minutes_left(int);
    int get_seconds_left();
    void set_seconds_left(int);
    void changemap(const char * map,const char * mode,int mins);
    int modecode(const char * modename);
    int getplayercount();
    int getbotcount();
    int getspeccount();
    void addbot(int);
    void deletebot(int);
    void update_mastermask();
    const char * gamemodename();
    int lua_gamemodeinfo(lua_State *);
    void recorddemo(const char *);
    void enddemorecord();
    void calc_player_ranks();
    void set_mastermode_cn(int, int);
    void set_mastermode(int);
    int get_mastermode();
    void add_allowed_ip(const char *);
    bool compare_admin_password(const char *);
    
    int lua_player_list(lua_State *);
    int lua_spec_list(lua_State *);
    int lua_bot_list(lua_State *);
    int lua_client_list(lua_State *);

    bool rotatemap();
    
    void suicide(int);
    void player_servcmd(int cn, const char *string);
    
    extern string ext_admin_pass;
    
    void sendservmsg(const char *);
    
    void send_auth_challenge(int,int,const char *,const char *);
    void send_auth_request(int, const char *);
    
    bool send_item(int item_code, int recipient);
    
    void try_respawn(clientinfo * ci, clientinfo * cq);


    //noobmod
    void block_cn(int cn);
    void unblock_cn(int cn);
    void send_fake_connect(int, int, const char *, const char *);
    void send_fake_disconnect(int, int);
    bool send_entity(int id);
    bool player_send_entity(int cn, int id);
    bool reset_entity(int id);
    bool player_reset_entity(int cn, int id);

    // NoobMOD ...
    void send_fake_connect(int, int, const char *, const char *);
    void send_fake_disconnect(int, int);
//    void send_fake_text(int, int, const char *);
//    int player_disc_reason(int cn, int reason);
//    int player_nm_checkauth(int cn, int reason);
//    unsigned int player_mapcrc(int);
//    int player_lastposupdate(int);
    bool send_entity(int id);
    bool player_send_entity(int cn, int id);
    bool reset_entity(int id);
    bool player_reset_entity(int cn, int id);
    bool send_shotfx(int cn, int gun, int id);
    void player_send_fake_shotfx(int to_cn, int pcn, int gun, int id);
//    void blah(int, const char *);
//    int player_mov(lua_State *);
//    int player_vel(lua_State *);
//    int player_ypr(lua_State *);
//    void set_player_pos(int cn, int x, int y, int z);
//    void set_player_mov(int cn, int move, int strafe);
//    void set_player_vel(int cn, int x, int y, int z);
//    void set_player_ypr(int cn, int yaw, int pitch, int roll);
    void player_send_fake_npos(int to_cn, int pcn);
//    void player_send_fake_spectator(int to_cn, int pcn, int val);
//    bool player_sendmap(int cn);
//        bool player_sendmap_from_file(int cn, const char *filename);
//    void player_editvari(int cn, const char *var, int value);
//    void player_editvarf(int cn, const char *var, lua_Number value);
//    void player_editvars(int cn, const char *var, const char *value);
//    void send_editmode(int cn, int val);
//    void send_fake_editmode(int cn, int ocn, int val);
//    void spawn_player(int cn);
    void player_send_fake_spawn(int to_cn, int pcn, int health, int maxhealth, int gunselect);
//    void player_send_fake_slay(int to_cn, int pcn);
//    void player_send_fake_ping(int to_cn, int pcn, int ping);
//    void player_send_fake_gunselect(int to_cn, int pcn, int gun);
//    void player_hitpush(int pcn, int gun, int x, int y, int z);
    void block_cn(int cn);
    void unblock_cn(int cn);
//    void update_health(int cn);
//    void send_health(int cn, int health, int armour);
//    void player_gamestate_ammo(int cn, int gun, int ammo);
//    void player_gamestate_health(int cn, int health, int maxhealth);
//    void player_gamestate_armour(int cn, int armour, int armourtype);
//    void player_gamestate_gunselect(int cn, int gunselect);
//    void player_send_spawnstate(int to_cn, int cn);
    void send_fake_damage(int cn, int ocn, int damage);
    void player_send_fake_damage(int to_cn, int actor_cn, int target_cn, int damage);
    void do_fake_damage(int actor_cn, int target_cn, int damage, int gun);
    void player_send_fake_rename(int to_cn, int pcn, const char *name);
    void player_send_fake_playermodel(int to_cn, int pcn, int model);
//    void ctf_reset_flags();
//    void ctf_send_flag_update();
//    int ctf_add_flag(int x, int y, int z, int team);
//    bool ctf_set_flag(int id, int x, int y, int z, int team);
//    int ctf_get_flag(lua_State *);
//    void player_changemap(int to_cn, const char * map, const char * mode);
//    void set_gamespeed(int speed);
//    void player_gamespeed(int cn, int speed);
//    void player_force_changeteam(int cn, const char * newteam);
//    void player_fake_changeteam(int to_cn, int cn, const char * newteam);
//    void player_force_specmsg(int cn, int val);
    // ... NoobMOD



    
} //namespace server

#endif
