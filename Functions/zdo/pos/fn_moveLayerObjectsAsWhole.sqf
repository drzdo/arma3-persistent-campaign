params ["_layerName", "_targetPositionObject", "_randomOffset"];

private _targetOriginal = getPosATL _targetPositionObject;

private _targetShifted = [
	(_targetOriginal select 0) + (random _randomOffset/2) - _randomOffset,
	(_targetOriginal select 1) + (random _randomOffset/2) - _randomOffset,
	(_targetOriginal select 2)
];

private _objects = (getMissionLayerEntities _layerName) select 0;
if ((count _objects) > 0) then {
	// `array select 0` does not work inside `forEach array` :(
	private _base = getPosATL (_objects select 0);
	{
		private _thisPos = getPosATL _x;
		private _delta = [
			(_thisPos select 0) - (_base select 0),
			(_thisPos select 1) - (_base select 1),
			(_thisPos select 2) - (_base select 2)
		];

		private _posFinal = [
			(_targetShifted select 0) + (_delta select 0),
			(_targetShifted select 1) + (_delta select 1),
			(_targetShifted select 2) + (_delta select 2) + 0.05
		];

		_x setPosATL _posFinal;
	} forEach _objects;
};