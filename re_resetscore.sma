#include <amxmodx>
#include <reapi>
#include <colorchat>

new const PLUGIN[] = "Resetscore";
new const VERSION[] = "1.0";
new const AUTHOR[] = "mforce";


new const PREFIX[] = "ProKillers"

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_clcmd("say /rs","reset")
	register_clcmd("say /resetscore","reset")
	register_clcmd("say !resetscore","reset")
	register_clcmd("say !rs","reset")
	register_clcmd("say_team /rs","reset")
	register_clcmd("say_team /resetscore","reset")
	register_clcmd("say_team !resetscore","reset")
	register_clcmd("say_team !rs","reset")

	set_task(162.0, "rsuzi", _,_,_,"b")
}

public reset(id) {
	if(!is_user_connected(id)) return;
	
	set_entvar(id, var_frags, 0.0);
	set_member(id, m_iDeaths, 0);
	client_print_color(id, print_team_default, "^4[%s]^1 You have successfully reseted your score!", PREFIX)

	static mScoreInfo; if(!mScoreInfo) mScoreInfo = get_user_msgid("ScoreInfo");
	message_begin(MSG_ALL, mScoreInfo);
	write_byte(id);
	write_short(0);
	write_short(0);
	write_short(0);
	write_short(get_member(id, m_iTeam));
	message_end();
}

public rsuzi() {
	client_print_color(0, print_team_default, "^4[%s]^1 To reset your score, type: ^3/rs", PREFIX)
}