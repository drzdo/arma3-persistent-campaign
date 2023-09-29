params ["_o"];

private _objs = ((typeOf _o) allObjects 0) + ((typeOf _o) allObjects 1);
{
	if (_x != _o) then {
		deleteVehicle _x;
	};
} forEach _objs;
