params ["_savedMines", "_layer"];

private _mineClasses = createHashMap;

{
    private _mineCfg = createHashMapFromArray _x;
    private _ammoT = _mineCfg get "type";
    private _posRot = _mineCfg get "pos";

    if (!(_ammoT in _mineClasses)) then {
        // Resolve armed mine type into <another> type so it can be created in 3den.
        private _c = (format ["(getText (_x >> 'ammo') == '%1') && (getText (_x >> 'vehicleClass') == 'Mines')", _ammoT]) configClasses (configFile >> "CfgVehicles");
        private _t = "";
        if (count _c > 0) then {
            _t = configName (_c select 0);
        };
        _mineClasses set [_ammoT, _t];
    };

    private _mineType = _mineClasses get _ammoT;
    if (!(_mineType isEqualTo "")) then {
        private _o = create3DENEntity ["Object", _mineType, _posRot select 0, true];
        _o set3DENLayer _layer;

        _o set3DENAttribute ["rotation", [_posRot select 1, _posRot select 2] call zdo_persist_editor_fnc_vecDirUpToXyzRotation];
    };
} forEach _savedMines;
