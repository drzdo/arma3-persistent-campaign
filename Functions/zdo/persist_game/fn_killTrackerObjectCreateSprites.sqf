/**
Create blood sprites on all kill positions.
To be called on initServer.
 */

private _tracker = ["zdo_kill_tracker"] call zdo_persist_game_fnc_getOrCreateMarkedObject;
private _killPositions = _tracker getVariable ["zdo_kills", []];

{
	[_x] call zdo_persist_game_fnc_killTrackerObjectCreateSprite;
} forEach _killPositions;
