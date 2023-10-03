private _debug = param [0, false];

private _types = [
	call zdo_sign_fnc_armex,
	call zdo_sign_fnc_blueking,
	call zdo_sign_fnc_burstkoke,
	call zdo_sign_fnc_idap,
	call zdo_sign_fnc_ion,
	call zdo_sign_fnc_larkin,
	call zdo_sign_fnc_quontrol,
	call zdo_sign_fnc_redburger,
	call zdo_sign_fnc_redstone,
	call zdo_sign_fnc_sponsor,
	call zdo_sign_fnc_suatmm,
	call zdo_sign_fnc_vrana
];

{
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
	} forEach _x;
} forEach _types;
