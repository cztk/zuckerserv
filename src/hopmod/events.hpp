#ifndef HOPMOD_EVENTS_HPP
#define HOPMOD_EVENTS_HPP
#include "lua/event.hpp"


extern lua::event< std::tuple<> >                                         event_init;
extern lua::event< std::tuple<int, const char *, const char *, const char *, bool> >  event_connecting;
extern lua::event< std::tuple<int, bool> >                                event_connect;
extern lua::event< std::tuple<int,const char *> >                         event_disconnect;
extern lua::event< std::tuple<const char *,const char *> >                event_failedconnect;
extern lua::event< std::tuple<int> >                                      event_maploaded;
extern lua::event< std::tuple<int,int> >                                  event_renaming;
extern lua::event< std::tuple<int,const char *> >                         event_allow_rename;
extern lua::event< std::tuple<int,const char *,const char *> >            event_rename;
extern lua::event< std::tuple<int,const char *,const char *> >            event_reteam;
extern lua::event< std::tuple<int,const char *,const char *, int> >       event_chteamrequest;
extern lua::event< std::tuple<int,const char *> >                         event_text;
extern lua::event< std::tuple<int,const char *> >                         event_sayteam;
extern lua::event< std::tuple<int,const char *> >                         event_servcmd;
extern lua::event< std::tuple<int,const char *,const char *> >            event_mapvote;
extern lua::event< std::tuple<int, const char *,const char *> >           event_setmastermode;
extern lua::event< std::tuple<int, const char *,const char *> >           event_setmastermode_request;
extern lua::event< std::tuple<int,int> >                                  event_spectator;
extern lua::event< std::tuple<int,int> >                                  event_editmode;
extern lua::event< std::tuple<int> >                                      event_editpacket;
extern lua::event< std::tuple<int,int,int> >                              event_privilege;
extern lua::event< std::tuple<int,int> >                                  event_teamkill;
extern lua::event< std::tuple<int,const char *,const char *, int> >       event_authreq;
extern lua::event< std::tuple<int,int,const char *> >                     event_authrep;
extern lua::event< std::tuple<int,int,int> >                              event_addbot;
extern lua::event< std::tuple<int> >                                      event_delbot;
extern lua::event< std::tuple<int> >                                      event_botleft;
extern lua::event< std::tuple<int, const char *, int> >                   event_modmap;
extern lua::event< std::tuple<int,int> >                                  event_teamkill;
extern lua::event< std::tuple<int,int> >                                  event_frag;
extern lua::event< std::tuple<int,int,int> >                              event_shot;
extern lua::event< std::tuple<int> >                                      event_suicide;
extern lua::event< std::tuple<int> >                                      event_spawn;
extern lua::event< std::tuple<int, int, int, int, double, double, double> >        event_damage;
extern lua::event< std::tuple<int,const char*,bool> >                     event_setmaster;
extern lua::event< std::tuple<int,int> >                                  event_respawnrequest;
extern lua::event< std::tuple<int> >                                      event_clearbans_request;
extern lua::event< std::tuple<int, const char *, int, int, const char *> >  event_kick_request;
extern lua::event< std::tuple<> >                                         event_intermission;
extern lua::event< std::tuple<> >                                         event_finishedgame;
extern lua::event< std::tuple<int,int> >                                  event_timeupdate;
extern lua::event< std::tuple<const char *,const char *> >                event_mapchange;
extern lua::event< std::tuple<> >                                         event_setnextgame;
extern lua::event< std::tuple<> >                                         event_gamepaused;
extern lua::event< std::tuple<> >                                         event_gameresumed;
extern lua::event< std::tuple<int,const char *> >                         event_beginrecord;
extern lua::event< std::tuple<int,int> >                                  event_endrecord;
extern lua::event< std::tuple<const char *,const char *> >                event_votepassed;
extern lua::event< std::tuple<int, const char *> >                        event_takeflag;
extern lua::event< std::tuple<int, const char *> >                        event_dropflag;
extern lua::event< std::tuple<int, const char *, int, int, bool> >        event_scoreflag;
extern lua::event< std::tuple<int, const char *> >                        event_returnflag;
extern lua::event< std::tuple<const char *> >                             event_resetflag;
extern lua::event< std::tuple<const char *, int> >                        event_scoreupdate;
extern lua::event< std::tuple<> >                                         event_started;
extern lua::event< std::tuple<int> >                                      event_shutdown;
extern lua::event< std::tuple<> >                                         event_shutdown_scripting;
extern lua::event< std::tuple<> >                                         event_reloadhopmod;
extern lua::event< std::tuple<const char *> >                             event_varchanged;
extern lua::event< std::tuple<> >                                         event_sleep;
extern lua::event< std::tuple<> >                                         event_interval;
extern lua::event< std::tuple<int, int, int, const char *> >              event_cheat;
extern lua::event< std::tuple<int, int, int> >                          event_passflag; // RUGBY MOD
extern lua::event< std::tuple<int, const char *, int, int, std::vector<rlPlayerCnType>> >        event_creditflaghelpers; // RUGBY MOD

// NoobMOD ...
//extern lua::event< boost::tuple<int,const char *> >                         event_limbotext;
//extern lua::event< boost::tuple<int,int> >                                  event_extinfo;
//extern lua::event< boost::tuple<int,int,int,long,long,long> >               event_teleport;
//extern lua::event< boost::tuple<int,int,long,long,long> >                   event_jumppad;
//extern lua::event< boost::tuple<int,int> >                                  event_gunselect;
//extern lua::event< boost::tuple<int,int,int> >                              event_pickup;

//extern lua::event< boost::tuple<int, int, int, int, int, int> >             event_editentpos; // cn, id, type, 3x pos == 6
//extern lua::event< boost::tuple<int, int, int, int, int, int, int> >        event_editentattr; // cn, id, 5x attr == 7
extern lua::event< std::tuple<int, int, int, int, int, int, int, int, int, int> > event_loadent; // id, type, 3x pos, 5x attr == 10
//extern lua::event< boost::tuple<int, const char *, int> >                   event_editvari;
//extern lua::event< boost::tuple<int, const char *, lua_Number> >            event_editvarf;
//extern lua::event< boost::tuple<int, const char *, const char *> >          event_editvars;
//extern lua::event< boost::tuple<int, int, int> >                            event_request_spectator;
extern lua::event< std::tuple<int, int, int, int, int, int, int, int, int> > event_try_frag; // target_cn, actor_cn, gun, from.x, from.y, from.z, to.x, to.y, to.z
//extern lua::event< boost::tuple<int> >                                      event_takeflag_request;
//extern lua::event< boost::tuple<int> >                                      event_scoreflag_request;
//extern lua::event< boost::tuple<int> >                                      event_try_spawn;
//extern lua::event< boost::tuple<int, int, int> >                            event_sending_map;
// ... NoobMOD

void register_event_idents(lua::event_environment &);

#endif

