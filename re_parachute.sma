#include <amxmodx>
#include <reapi>


new g_bAlive[33];

public plugin_init() {
	register_plugin("Parachute", "1.0", "Vaqtincha")	// Reapi modification by mforce
	
	RegisterHookChain(RG_CBasePlayer_ObjectCaps, "fwd_objectcaps", false);
	RegisterHookChain(RG_CBasePlayer_Spawn, "playerspawn_post", true);
	RegisterHookChain(RG_CBasePlayer_Killed, "playerkilled_post", true);
}

public client_putinserver(id)
	g_bAlive[id] = 0;

public playerspawn_post(id)
	g_bAlive[id] = is_user_alive(id);

public playerkilled_post(id)
	g_bAlive[id] = 0;

public fwd_objectcaps(id) {
	if(!g_bAlive[id] || ~get_entvar(id, var_button) & IN_USE 
	|| get_entvar(id, var_flags) & FL_ONGROUND) {
		return
	}
	static Float:velocity[3]; get_entvar(id, var_velocity, velocity);
	if(velocity[2] < 0) {
		velocity[2] = (velocity[2] + 40.0 < -100) ? velocity[2] + 40.0 : -100.0
		set_entvar(id, var_velocity, velocity);
	}
}