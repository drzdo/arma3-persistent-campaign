/**
Saves player's gear, location, etc.
 */

private _tracker = ["zdo_player_info_tracker"] call zdo_persist_game_fnc_getOrCreateMarkedObject;
private _map = createHashMapFromArray (_tracker getVariable ["zdo_players", []]);

{
	_map set [name _x, [
		["pos", getPosATL _x],
		["dir", getDir _x],
		["gear", getUnitLoadout _x],
		["ace_medical", [_x] call ace_medical_fnc_serializeState]
	]];
} forEach allPlayers;

_tracker setVariable ["zdo_players", _map toArray false, true];
