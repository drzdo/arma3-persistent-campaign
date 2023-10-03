params ["_box"];

_box setMaxLoad 1000000;

if (_box getVariable ["_arsenal_actions_created", false]) exitWith {
    // Do not make it arsenal again.
    0;
};

[_box, true] call ace_arsenal_fnc_removeBox;

_box setVariable ["zdo_arsenal", true, true];
_box setVariable ["_arsenal_actions_created", true];

private _actionOpen = ["zdo_openArsenal", "Open ACE Arsenal","",{
    private _box = _target;

    [_box, false] call ace_arsenal_fnc_initBox;

    private _container = [_box] call zdo_util_fnc_serializeContainer;
    private _playerLoadout = (flatten (getUnitLoadout player)) select { (typeName _x == "STRING") && !(_x isEqualTo "") };
    private _virtualWeapons = _container + _playerLoadout;

    [_box, _virtualWeapons, true] call ace_arsenal_fnc_addVirtualItems;

    [_box, player] call ace_arsenal_fnc_openBox;
    [_box, true] call ace_arsenal_fnc_removeBox;

    private _missingItemsInContainer = _playerLoadout select { !(_x in _container) };
    {
        if ([_x] call zdo_util_fnc_isBackpack) then {
            _box addBackpackCargoGlobal [_x, 1];
        } else {
            _box addItemCargoGlobal [_x, 1];
        };
    } forEach _missingItemsInContainer;
},{true}] call ace_interact_menu_fnc_createAction;
[_box, 0, ["ACE_MainActions"], _actionOpen, true] call ace_interact_menu_fnc_addActionToObject;

private _actionMove = ["zdo_moveFromVehicle", "Take items from vehicles (&lt;10m)","",{
    private _box = _target;
    private _nearCars = (getPos _box) nearEntities [["Air", "Car", "Armored", "Motorcycle", "Tank"], 10];

    private _existingIds = [_box] call zdo_util_fnc_serializeContainer;
    private _idsToAdd = [];
    {
        private _idsInCar = [_x] call zdo_util_fnc_serializeContainer;
        {
            if (!(_x in _existingIds) && !(_x in _idsToAdd)) then {
                _idsToAdd pushBack _x;
            };
        } forEach _idsInCar;
    } forEach _nearCars;

    {
        if ([_x] call zdo_util_fnc_isBackpack) then {
            this addBackpackCargoGlobal [_x, 1];
        } else {
            this addItemCargoGlobal [_x, 1];
        };
    } forEach _idsToAdd;

    if ((count _idsToAdd) > 0) then {
        private _carNames = _nearCars apply {
            getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName")
        } joinString ", ";
        hint (format ["Loot gathered from %1 (%2 items)", _carNames, count _idsToAdd]);
        playSound3D ["a3\sounds_f\vehicles2\soft\offroad_01\sfx_offroad_01_covered_backdoor_open_01.wss", player];
    } else {
        if ((count _nearCars) > 0) then {
            hint "No loot found in vehicles";
        } else {
            hint "No vehicles nearby";
        };
    };

    {
        clearItemCargoGlobal _x;
        clearBackpackCargoGlobal _x;
        clearMagazineCargoGlobal _x;
        clearWeaponCargoGlobal _x;
    } forEach _nearCars;
},{true}] call ace_interact_menu_fnc_createAction;
[_box, 0, ["ACE_MainActions"], _actionMove, true] call ace_interact_menu_fnc_addActionToObject;
