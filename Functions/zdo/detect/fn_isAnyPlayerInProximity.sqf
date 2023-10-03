params ["_targetUnitOrPos", "_distance"];

private _pos = if (typeName _targetUnitOrPos == "ARRAY") then {
	_targetUnitOrPos;
} else {
	getPosATL _targetUnitOrPos;
};

private _r = false;
{
	private _d = _x distance2D _pos;
	if (_d < _distance) then {
		_r = true;
		break;
	};
} forEach allPlayers;

_r;
