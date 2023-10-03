params ["_o"];

private _attrs = allVariables _o;
private _r = [];
{
    private _isCustomAttr = ["zdo_", _x] call BIS_fnc_inString;
    if (!_isCustomAttr) then {
        continue;
    };

    private _v = _o getVariable [_x, ""];
    if (_v isEqualTo "") then {
        continue;
    };
    _r pushBack [_x, _v];
} forEach _attrs;
_r;
