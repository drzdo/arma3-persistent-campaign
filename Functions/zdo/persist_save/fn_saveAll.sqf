/**
Save everything that is tracked to profileNamespace.
Returns an array with all the data.

To be called when game master wants to save the game state.

Local scheduled environment.
 */

call zdo_persist_game_fnc_playerInfoTrackerSaveAll;

// Wait for the variables to sync from server to client.
sleep 5;

private _objects = [];
{
    _saved = [_x] call zdo_persist_save_fnc_saveObjectIfNeeded;
    if ((count _saved) > 0) then {
        _objects pushBack _saved;
    }
} forEach (allMissionObjects "");

private _pit = ["zdo_player_info_tracker"] call zdo_persist_game_fnc_getOrCreateMarkedObject;
private _kt = ["zdo_kill_tracker"] call zdo_persist_game_fnc_getOrCreateMarkedObject;

private _savedData = [
    ["save_time", format (["%1-%2-%3-%4-%5-%6"] + systemTimeUTC)],
    ["player_info_tracker", [_pit] call zdo_persist_save_fnc_saveZdoVariables],
    ["kill_tracker", [_kt] call zdo_persist_save_fnc_saveZdoVariables],
    ["objects", _objects],
    ["mines", call zdo_persist_save_fnc_saveMines],
    ["map", call zdo_persist_save_fnc_copyMapMarkers],
    ["destroyed_terrain_objects", call zdo_persist_save_fnc_saveDestroyedTerrainObjects]
];

profileNamespace setVariable ["zdo_mission", _savedData];
_savedData;
