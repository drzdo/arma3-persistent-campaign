private _map = createHashMap;
{
    private _objs = nearestTerrainObjects [getPosATL _x, call zdo_persist_save_fnc_terrainObjectsToTrack, 1000, false];
    {
        private _dmg = damage _x;
        if (_dmg > 0.999) then {
            _map set [netId _x, getPosATL _x];
        };
    } forEach _objs;
} forEach allUnits;

values _map;
