params ["_layerName", "_targetPositionObject", "_randomOffset"];

private _pos = getPosATL _targetPositionObject;

private _objects = (getMissionLayerEntities _layerName) select 0;

{
	private _pos2 = [
		(_pos select 0) + (random _randomOffset/2) - _randomOffset,
		(_pos select 1) + (random _randomOffset/2) - _randomOffset,
		(_pos select 2)
	];
	_x setDir (random 360);
	[_x, _pos2] call ZDOGM_fnc_setAtEmptyPosition;
} forEach _objects;
