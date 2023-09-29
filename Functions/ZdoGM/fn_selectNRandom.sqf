params ["_objs", "_count"];

private _res = [];

private _i = 0;
while {_i < _count} do {
	if ((count _objs) > 0) then {
		private _iRandom = floor random (count _objs);
		private _obj = _objs select _iRandom;
		_res pushBack _obj;
		_objs deleteAt _iRandom;
	};

	_i = _i + 1;
};

_res;
