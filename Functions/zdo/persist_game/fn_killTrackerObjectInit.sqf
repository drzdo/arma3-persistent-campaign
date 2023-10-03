/**
Server-only.
Create object that tracks kills.
 */

private _tracker = ["zdo_kill_tracker"] call zdo_persist_game_fnc_getOrCreateMarkedObject;

addMissionEventHandler ["EntityKilled", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	_thisArgs params ["_tracker"];

	private _list = _tracker getVariable ["zdo_kills", []];
	private _newKillPos = [
		["pos", getPosWorld _unit],
		["man", (_unit isKindOf "Man")]
	];
	_list pushBack _newKillPos;

	private _maxCount = 200;
	private _maxThreshold = 20;
	if ((count _list) > (_maxCount + _maxThreshold)) then {
		_list = _list select [_maxThreshold, _maxCount];
	};

	_tracker setVariable ["zdo_kills", _list, true];

	[_newKillPos] call zdo_persist_game_fnc_killTrackerObjectCreateSprite;
}, [_tracker]];

call zdo_persist_game_fnc_killTrackerObjectCreateSprites;
