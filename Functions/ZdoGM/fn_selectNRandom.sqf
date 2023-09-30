params ["_objs", "_count"];

private _res = [];

if ((_count > 0) && (_count < (count _objs))) then {
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
} else {
	_res = _objs;
};

_res;
