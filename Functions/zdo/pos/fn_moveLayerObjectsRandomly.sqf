params ["_layerName", "_targetPositionOrObject", "_randomOffset", ["_delay", 0]];

private _pos = if (typeName _targetPositionOrObject == "ARRAY") then {_targetPositionOrObject} else {getPosATL _targetPositionOrObject};

private _objects = (getMissionLayerEntities _layerName) select 0;

{
	private _pos2 = [
		(_pos select 0) + (random _randomOffset/2) - _randomOffset,
		(_pos select 1) + (random _randomOffset/2) - _randomOffset,
		(_pos select 2)
	];
	_x setDir (random 360);
	[_x, _pos2] call zdo_pos_fnc_moveToEmptyPosition;

	if (_delay > 0) then {
		sleep _delay;
	};
} forEach _objects;
