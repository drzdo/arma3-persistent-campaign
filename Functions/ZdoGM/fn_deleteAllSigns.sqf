private _debug = param [0, false];

private _types = [
	call ZDOGM_fnc_signArmex,
	call ZDOGM_fnc_signBlueking,
	call ZDOGM_fnc_signBurstkoke,
	call ZDOGM_fnc_signIdap
];

{
	private _objs = (_x allObjects 0);
	{
		if (_debug == true) then {
			_x hideObjectGlobal true;
			_x enableSimulationGlobal false;
			_x allowDamage false;
		} else {
			deleteVehicle _x;
		};
	} forEach _objs;
} forEach _types;
