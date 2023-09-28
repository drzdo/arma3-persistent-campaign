params ["_box", "_center", "_radiusMeters"];
_box setMaxLoad 1000000;

private _maxDistanceSqr = _radiusMeters * _radiusMeters;

private _collectedItems = createHashMap;
private _usedDead = [];

{
    private _distanceSqr = _center distanceSqr (getPos _x);
    if (_distanceSqr > _maxDistanceSqr) then {
        continue;
    };

    private _items = (flatten (getUnitLoadout player)) select { (typeName _x == "STRING") && !(_x isEqualTo "") };
    _usedDead pushBack _x;
    
    {
        private _count = _collectedItems getOrDefault [_x, 0];
        _collectedItems set [_x, _count + 1];
    } forEach _items;
} forEach allDeadMen;

private _weaponHolders = (nearestObjects [_center, ["WeaponHolder", "WeaponHolderSimulated"], _radiusMeters]);
{
    private _items = [_x] call ZDO_fnc_serializeContainer;
    {
        private _count = _collectedItems getOrDefault [_x, 0];
        _collectedItems set [_x, _count + 1];
    } forEach _items;
} forEach _weaponHolders;

{
    if ([_x] call ZDO_fnc_isBackpack) then {
        _box addBackpackCargoGlobal [_x, _y];
    } else {
        _box addItemCargoGlobal [_x, _y];
    };
} forEach _collectedItems;

{
    deleteVehicle _x;
} forEach _weaponHolders;
{
    _x setUnitLoadout [
        [],
        [],
        [],
        [],
        [],
        [],
        "","",[],["","","","","",""]
    ];
} forEach _usedDead;


if ((count _collectedItems) > 0) then {
    private _boxName = getText (configFile >> "CfgVehicles" >> (typeOf _box) >> "displayName");
    hint (format ["Loot gathered to %1 (%2 items)", _boxName, count _collectedItems]);
    playSound3D ["a3\sounds_f\vehicles2\soft\offroad_01\sfx_offroad_01_covered_backdoor_open_01.wss", player];
} else {
    hint "No loot nearby";
};
_collectedItems;
