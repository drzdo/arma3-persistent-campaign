params ["_group", "_targetPositionOrObject", ["_deleteCrew", false]];

private _pos = if (typeName _targetPositionOrObject == "ARRAY") then {_targetPositionOrObject} else {getPosATL _targetPositionOrObject};

private _objects = [];
{
	_objects pushBackUnique (vehicle _x);
} forEach (units _group select { ((vehicle _x) call BIS_fnc_objectType select 0) isEqualTo "Vehicle" });

if (_deleteCrew) then {
	{
		deleteVehicleCrew _x;
	} forEach _objects;
};

{
	_x setDir (random 360);
	[_x, _pos] call zdo_pos_fnc_moveToEmptyPosition;

	sleep 2;
} forEach _objects;
