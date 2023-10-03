params ["_savedData", "_layer"];

private _o = [[], _layer] call zdo_persist_editor_fnc_createMarkedObjectWithZdoVariables;

private _initServer = [];
_initServer pushBack format ["private _map = %1;", _savedData];
_initServer pushBack format ["_map call zdo_persist_game_fnc_pasteMapMarkers;"];
[_o, _initServer] call zdo_persist_editor_fnc_appendInitServerAttribute;

_o;
