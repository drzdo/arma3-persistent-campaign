_this spawn {
	params ["_interval", "_args", "_fn"];

	while {true} do {
		private _r = _args call _fn;
		if (!_r) then {
			break;
		};
		sleep _interval;
	};
};
