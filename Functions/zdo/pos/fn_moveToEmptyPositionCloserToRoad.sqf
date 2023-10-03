params ["_unit", "_posOrUnit", ["_radius", 50]];

private _pos = if (typeName _posOrUnit == "ARRAY") then {
	_posOrUnit;
} else {
	getPosATL _posOrUnit;
};

private _roads = _pos nearRoads _radius apply { getPosATL _x };
private _posOnRoad = _pos;
if (count _roads > 0) then {
	_posOnRoad = selectRandom _roads;
};
[_unit, _posOnRoad] call zdo_pos_fnc_moveToEmptyPosition;
