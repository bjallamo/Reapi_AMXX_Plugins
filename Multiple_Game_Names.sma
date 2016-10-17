#include <amxmodx>
#include <reapi>

new const GAME_NAMES[][] = {"ProKillers", "AntiCheat", "ReHLDS", "by mforce"};

new iGameName;

public plugin_init() {
	register_plugin("Multiple Game Names", "1.0", "mforce");	// & ReHLDS Team
	set_task(1.0, "re_gamename", .flags="b");
}

public re_gamename() {
	set_member_game(m_GameDesc, GAME_NAMES[iGameName > charsmax(GAME_NAMES) ? (iGameName = 0):iGameName++]);
}