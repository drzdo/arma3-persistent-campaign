params ["_mark"];

private _cacheId = "cached_" + _mark;
private _o = localNamespace getVariable [_cacheId, nil];

if (isNil "_o") then {
	private _candidates = (allMissionObjects "VR_3DSelector_01_default_F") select { _x getVariable [_mark, false] };
	_o = _candidates select 0;

	if (isNil "_o") then {
		_o = "VR_3DSelector_01_default_F" createVehicle [0, 0, 0];

		_o hideObjectGlobal true;
		_o allowDamage false;
		_o enableSimulationGlobal false;

		_o setVariable [_mark, true, true];
	};

	localNamespace setVariable [_cacheId, _o];
};

_o;
