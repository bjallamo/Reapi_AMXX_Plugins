#include <amxmodx>
#include <reapi>
#include <colorchat>

#define LIVE_UPDATE 	// Azonnali frissítés

#define IsValidPlayers(%1,%2) ((1 <= %1 <= 32) && (1 <= %2 <= 32))

new g_iAssist[33];
new g_iAssDamage[33][33];

new const PREFIX[] = "ProKillers";

public plugin_init()
{
#define VERSION "1.17"
	register_plugin("Lite Kill Assist", VERSION, "neygomon");	// Reapi modification by mforce
	register_cvar("lite_assist", VERSION, FCVAR_SERVER | FCVAR_SPONLY);
	
	register_event("HLTV", "eRoundStart", "a", "1=0", "2=0");
	RegisterHookChain(RG_CBasePlayer_Killed, "eDeathMsg", 1);
	RegisterHookChain(RG_CBasePlayer_TakeDamage, "eDamage", 1);
}

public client_disconnect(id) ResetAssist(id);

public eRoundStart()
{
	new pl[32], pnum; get_players(pl, pnum);
	for(new i; i < pnum; i++) ResetAssist(pl[i]);
}
	
public eDeathMsg(const this, pevAttacker, iGib)
{
	if(pevAttacker == this || pevAttacker == g_iAssist[this] || !is_user_connected(g_iAssist[this])) return;
	
	rg_add_account(g_iAssist[this], 300, true);
	new iFrags = get_user_frags(g_iAssist[this]) + 1;
	set_entvar(g_iAssist[this], var_frags, float(iFrags));
#if defined LIVE_UPDATE
	static mScoreInfo; if(!mScoreInfo) mScoreInfo = get_user_msgid("ScoreInfo");
	message_begin(MSG_ALL, mScoreInfo);
	write_byte(g_iAssist[this]);
	write_short(iFrags);
	write_short(get_member(g_iAssist[this], m_iDeaths));
	write_short(0);
	write_short(get_member(g_iAssist[this], m_iTeam));
	message_end();
#endif
	new victim[32]; get_user_name(this, victim, charsmax(victim));
	client_print_color(g_iAssist[this], print_team_default, "^4[%s]^1 Kaptál ^4+1^1 fraget, mert segítettél^3 %s ^1megölésében.", PREFIX, victim);	
	ResetAssist(this);
}

public eDamage(const this, pevInflictor, pevAttacker, Float:flDamage, bitsDamageType)
{
	if(this == pevAttacker || !IsValidPlayers(this, pevAttacker)) return;
	if(!GetHookChainReturn()) return; // TakeDamage is not get damage from teammate more if "mp_friendlyfire" is "0"
	g_iAssDamage[this][pevAttacker] += flDamage;
	if(!g_iAssist[this] && g_iAssDamage[this][pevAttacker] >= 50) g_iAssist[this] = pevAttacker;
}

ResetAssist(id)
{
	g_iAssist[id] = 0;
	arrayset(g_iAssDamage[id], 0, sizeof g_iAssDamage[]);
}
