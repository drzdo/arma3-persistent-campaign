params ["_objectToTeleport", "_targetPositionObject"];

private _pos = getPosATL _targetPositionObject;

[
	"teleportToObject %1 %2 -> %3 %4",
	_objectToTeleport,
	getPosATL _objectToTeleport,
	_targetPositionObject,
	getPosATL _targetPositionObject
] call zdo_log_fnc_write;

_targetPositionObject hideObjectGlobal true;
_targetPositionObject enableSimulationGlobal false;
_targetPositionObject allowDamage false;

// Shift slightly above the placed position to avoid physics glitches.
_pos set [2, (_pos select 2) + 0.2];

_objectToTeleport setPosATL _pos;
_objectToTeleport setDir (getDir _targetPositionObject);
_targetPositionObject;
