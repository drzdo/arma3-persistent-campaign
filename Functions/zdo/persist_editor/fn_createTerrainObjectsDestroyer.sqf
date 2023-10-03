params ["_savedData", "_layer"];

private _dtoTypes = call zdo_persist_save_fnc_terrainObjectsToTrack;

private _o = [[], _layer] call zdo_persist_editor_fnc_createMarkedObjectWithZdoVariables;
private _initServer = [];

_initServer pushBack format ["private _typesToCheck = %1;", str _dtoTypes];
_initServer pushBack "private _objs = [];";
{
    private _pos = _x;
    _initServer pushBack (format ["_objs = nearestTerrainObjects [%1, _typesToCheck, 1, false];", _pos]);
    _initServer pushBack (format ["{_x setDamage [1, false];} forEach _objs;", _x, _dtoTypes]);
} forEach _savedData;

[_o, _initServer] call zdo_persist_editor_fnc_appendInitServerAttribute;

_o;
