params ["_group", "_posOrUnit", ["_delay", 0]];

private _units = units _group;

private _leader = leader _group;
private _leaderVehicle = vehicle _leader;
[_leaderVehicle, _posOrUnit] call zdo_pos_fnc_moveToEmptyPosition;

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
		[_x, formationPosition _x] call zdo_pos_fnc_moveToEmptyPosition;

		if (_delay > 0) then {
			// Delay is needed when multiple vehicles are being moved so they are not placed on the same spot and do not blow up.
			sleep _delay;
		};
	};
} forEach (_unitsToMove);
