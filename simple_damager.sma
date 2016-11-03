#include <amxmodx>
#include <reapi>

new g_msgSyncHud;

#define SPECTATOR_CAN_SEE_DMG

#if AMXX_VERSION_NUM < 183
	new MaxClients;
#endif

public plugin_init() {
	register_plugin("Simple Damager", "1.0", "mforce");	// thanks to neugomon

	RegisterHookChain(RG_CBasePlayer_TakeDamage, "CBasePlayer_TakeDamage_Post", true);
	g_msgSyncHud  = CreateHudSyncObj();
#if AMXX_VERSION_NUM < 183
	MaxClients = get_maxplayers();
#endif
}

public CBasePlayer_TakeDamage_Post(const id, pevInflictor, attacker, Float:flDamage) {
	if(!(1 <= attacker <= MaxClients) || !(1 <= id <= MaxClients) || flDamage < 1.0 || !rg_is_player_can_takedamage(id, attacker))
		return;

	set_hudmessage(.red = 0, .green = 100, .blue = 200, .x = -1.0, .y = 0.55, .holdtime = 2.0, .channel = -1);
	ShowSyncHudMsg(attacker, g_msgSyncHud, "%.0f^n", flDamage);
	
	set_hudmessage(.red = 255, .green = 0, .blue = 0, .x = 0.45, .y = 0.50, .holdtime = 2.0, .channel = -1);
	ShowSyncHudMsg(id, g_msgSyncHud, "%.0f^n", flDamage);

#if defined SPECTATOR_CAN_SEE_DMG
	static i, players[32], pnum, specid, iuser2;
	get_players(players, pnum, "bch");
	for(i = 0; i < pnum; i++) {
		specid = players[i];
		iuser2 = get_entvar(specid, var_iuser2);
		if(iuser2 == attacker) {
			set_hudmessage(.red = 0, .green = 100, .blue = 200, .x = -1.0, .y = 0.55, .holdtime = 2.0, .channel = -1);
			ShowSyncHudMsg(specid, g_msgSyncHud, "%.0f^n", flDamage);
		}
		else if(iuser2 == id) {
			set_hudmessage(.red = 255, .green = 0, .blue = 0, .x = 0.45, .y = 0.50, .holdtime = 2.0, .channel = -1);
			ShowSyncHudMsg(specid, g_msgSyncHud, "%.0f^n", flDamage);
		}
	}
#endif
}