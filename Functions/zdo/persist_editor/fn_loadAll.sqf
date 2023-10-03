params ["_savedData"];

private _h = createHashMapFromArray _savedData;
private _layerRoot = -1 add3DENLayer (format ["Loaded %1", _h get "save_time"]);

private _layers = [
    ["ve", str (_layerRoot add3DENLayer "Vehicles")],
    ["bu", str (_layerRoot add3DENLayer "Buildings")],
    ["th", str (_layerRoot add3DENLayer "Things")],
    ["fl", str (_layerRoot add3DENLayer "Flags")]
];

private _objects = _h get "objects";
{
    [_x, _layers] call zdo_persist_editor_fnc_loadObject;
} forEach _objects;

private _layerMines = _layerRoot add3DENLayer "Mines";
[_h get "mines", _layerMines] call zdo_persist_editor_fnc_loadMines;

private _layerUtil = _layerRoot add3DENLayer "Util";

[_h get "player_info_tracker", _layerUtil] call zdo_persist_editor_fnc_createMarkedObjectWithZdoVariables;
[_h get "kill_tracker", _layerUtil] call zdo_persist_editor_fnc_createMarkedObjectWithZdoVariables;
[_h get "map", _layerUtil] call zdo_persist_editor_fnc_createMapLoader;
[_h get "destroyed_terrain_objects", _layerUtil] call zdo_persist_editor_fnc_createTerrainObjectsDestroyer;

1;
