params ["_group", "_posOrUnit"];

private _units = units _group;

private _leader = leader _group;
private _leaderVehicle = vehicle _leader;
[_leaderVehicle, _posOrUnit] call ZDOGM_fnc_setAtEmptyPosition;

private _unitsToMove = [];
{
	if (_x == _leader) then {
		continue;
	};
	if ((vehicle _x) == _leaderVehicle) then {
		continue;
	};
	if ((vehicle _x) == _x) then {
		// Outside of vehicle.
		_unitsToMove pushBack _x;
	} else {
		_unitsToMove pushBackUnique (vehicle _x);
	};
} forEach (_units);

{
	if (_x != _leader) then {
		[_x, formationPosition _x] call ZDOGM_fnc_setAtEmptyPosition;
	};
} forEach (_unitsToMove);
