/**
Launches tracker of player's gear, location, etc.
Server-only, scheduled environment.
 */

["zdo_player_info_tracker"] call zdo_persist_game_fnc_getOrCreateMarkedObject;

[] spawn {
	while {true} do {
		call zdo_persist_game_fnc_playerInfoTrackerSaveAll;
		sleep 30;
	};
};
