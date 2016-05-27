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
	
	register_event("HLTV",     "eRoundStart", "a", "1=0", "2=0");
	register_event("DeathMsg", "eDeathMsg", "a", "1>0");
	register_event("Damage",   "eDamage", "be", "2!0", "3=0", "4!0");
}

public client_disconnect(id)
	ResetAssist(id);

public eRoundStart()
{
	new pl[32], pnum; get_players(pl, pnum);
	for(new i; i < pnum; i++)
		ResetAssist(pl[i]);
}
	
public eDeathMsg()
{
	new pKiller = read_data(1);
	new pVictim = read_data(2);
	if(pKiller == pVictim || pKiller == g_iAssist[pVictim] || !is_user_connected(g_iAssist[pVictim])) return;
	
	rg_add_account(g_iAssist[pVictim], 300, true);
	new Float:iFrags = (get_entvar(g_iAssist[pVictim], var_frags) + 1.0);
	set_entvar(g_iAssist[pVictim], var_frags, iFrags);
#if defined LIVE_UPDATE
	static mScoreInfo; if(!mScoreInfo) mScoreInfo = get_user_msgid("ScoreInfo");
	message_begin(MSG_ALL, mScoreInfo);
	write_byte(g_iAssist[pVictim]);
	write_short(floatround(iFrags));
	write_short(get_member(g_iAssist[pVictim], m_iDeaths));
	write_short(0);
	write_short(get_member(g_iAssist[pVictim], m_iTeam));
	message_end();
#endif
	new victim[32];
	get_user_name(pVictim, victim, charsmax(victim));
	client_print_color(g_iAssist[pVictim], print_team_default, "^4[%s]^1 Kaptál ^4+1^1 fraget, mert segítettél^3 %s ^1megölésében.", PREFIX, victim);	
	ResetAssist(pVictim);
}

public eDamage(id)
{
	static pAttacker; pAttacker = get_user_attacker(id);
	if(id == pAttacker || !IsValidPlayers(id, pAttacker)) return;
	g_iAssDamage[id][pAttacker] += read_data(2);
	if(!g_iAssist[id] && g_iAssDamage[id][pAttacker] >= 50)
		g_iAssist[id] = pAttacker;
}

ResetAssist(id)
{
	g_iAssist[id] = 0;
	arrayset(g_iAssDamage[id], 0, sizeof g_iAssDamage[]);
}