params ["_unit", "_posOrUnit"];

private _bbox = boundingBox _unit;
private _diameter = 1 max (_bbox select 2);

if (!(_unit isKindOf "Man")) then {
	// Add more spacing for the vehicles.
	_diameter = _diameter * 1.5;
};

private _pos = if (typeName _posOrUnit == "ARRAY") then {
	_posOrUnit;
} else {
	getPosATL _posOrUnit;
};
private _targetPos = _pos findEmptyPosition [_diameter / 2, 100];

if ((count _targetPos) == 0) then {
	_targetPos = _pos;
};

_targetPos set [2, (_targetPos select 2) + 0.2];

_unit setPos _targetPos;
