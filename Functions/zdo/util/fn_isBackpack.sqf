params ["_type"];

// This function is called quite often, hence the caching.
private _key = (format ["zdo_isbackpackcache_%1", _type]);
private _value = profileNamespace getVariable [_key, ""];

if (_value isEqualTo "") then {
    private _classes = (format ["((configName _x) isEqualTo '%1') && (getText (_x >> 'vehicleClass') == 'Backpacks')", _type]) configClasses (configFile >> "CfgVehicles");
    private _isBackpack = (count _classes) > 0;
    if (_isBackpack) then {
        profileNamespace setVariable [_key, "1"];
    } else {
        profileNamespace setVariable [_key, "0"];
    };
    _isBackpack;
} else {
    _value isEqualTo "1";
};
