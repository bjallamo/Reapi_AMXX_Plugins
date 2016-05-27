#include <amxmodx>
#include <reapi>


new const PLUGIN[] = "No Team Flash"
new const VERSION[] = "1.0"
new const AUTHOR[] = "mforce"


public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);

	RegisterHookChain(RG_PlayerBlind, "fwdPlayerBlind");
}

public fwdPlayerBlind(id, inflictor, attacker) {
	if(id == attacker || get_member(id, m_iTeam) != get_member(attacker, m_iTeam))
		return HC_CONTINUE;

	return HC_SUPERCEDE;
}