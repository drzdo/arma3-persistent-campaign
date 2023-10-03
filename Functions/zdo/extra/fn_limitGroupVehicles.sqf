params ["_group", "_min", "_max"];

private _vehicles = [];
{
	private _v = vehicle _x;
	if (!(_v isKindOf "Man")) then {
		_vehicles pushBackUnique _v;
	};
} forEach units _group;

private _limit = [_min, _max] call BIS_fnc_randomInt;
while {(count _vehicles) > _limit} do {
	private _i = floor random count _vehicles;
	private _v = _vehicles select _i;
	_vehicles deleteAt _i;
	["Delete vehicle limit=%1 total=%2 delete=%2", _limit, count _vehicles, typeOf _v] call zdo_log_fnc_write;
	deleteVehicle _v;
};
