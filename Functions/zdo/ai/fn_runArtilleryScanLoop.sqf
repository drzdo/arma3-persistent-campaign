/**
Run check each "_interval" seconds.
If any unit from side "_side" saw any player
- at least "_minDtSinceContactToAskArtillery" ago
- but not longer than "_maxDtSinceContactToAskArtillery" ago

and the distance from any unit of side "_side" to the last seen player's position is more than "_minDistanceToFriendly"

then fire an artillery on this position with error "_errorPer100m".

Unit of side cannot report player if they are dead or handcuffed.
Possible scenario: enemy civilians reporting players to enemy mortars.
 */

params [
	["_interval", 15],
	["_side", east],
	["_minDtSinceContactToAskArtillery", 5],
	["_maxDtSinceContactToAskArtillery", 120],
	["_minDistanceToFriendly", 5],

	// targetKnowledge gives pretty good error already, therefore error range here is so small.
	["_errorPer100mMinMax", [0, 3]],

	["_roundsPerIterationMinMax", [0,6]]
];

private _iter = 0;

while {true} do {
	private _bestPerson = 0;
	private _bestKnownLocationDt = 10000;
	private _bestKnownLocation = [];

	private _targets = allPlayers;
	{
		if !(alive _x) then {
			continue;
		};

		private _target = _x;
		{
			{
				if (!(alive _x) || (_x getVariable ["ace_captives_ishandcuffed", false])) then {
					continue;
				};
				private _o = _x targetKnowledge _target;
				private _knownLocation = _o select 6;
				private _dt = time - (_o select 2);

				private _isTimingGood = (_dt > _minDtSinceContactToAskArtillery && _dt < _maxDtSinceContactToAskArtillery);
				if (!_isTimingGood) then {
					continue;
				};

				if (_dt < _bestKnownLocationDt) then {
					_bestKnownLocationDt = _dt;
					_bestKnownLocation = _knownLocation;
					_bestPerson = _x;
				};
			} forEach units _x;
		} forEach groups _side;
	} forEach _targets;

	if (count _bestKnownLocation isEqualTo 3) then {
		private _canFire = true;
		private _minDistanceToFriendlySqr = _minDistanceToFriendly * _minDistanceToFriendly;
		{
			{
				private _d = [_x, _bestKnownLocation] call BIS_fnc_distance2Dsqr;
				if (_d < _minDistanceToFriendlySqr) then {
					_canFire = false;
					break;
				};
			} forEach units _x;

			if (!_canFire) then {
				break;
			};
		} forEach groups _side;

		if (_canFire) then {
			private _artillery = [];
			{
				{
					private _v = vehicle _x;
					if (count (getArtilleryAmmo [_v]) > 0) then {
						_artillery pushBack _v;
					};
				} forEach units _x;
			} forEach groups _side;

			playSound3D [
				selectRandom [
					"a3\dubbing_f_epb\b_m05\08_sabotage_request\b_m05_08_sabotage_request_ker_0.ogg",
					"a3\dubbing_f\modules\supports\artillery_request.ogg"
				],
				_bestPerson
			];

			if (count _artillery > 0) then {
				private _totalRoundsToShoot = _roundsPerIterationMinMax call BIS_fnc_randomInt;
				private _roundsPerArtilleryUnit = round (_totalRoundsToShoot / (count _artillery));
				private _roundsLeft = _totalRoundsToShoot;

				while {_roundsLeft > 0} do {
					{
						if (_roundsLeft <= 0) then {
							break;
						};

						private _distanceToArtilleryUnit = _x distance2D _bestKnownLocation;
						private _errorIterations = ceil (_distanceToArtilleryUnit / 100.0);

						private _error = 0;
						private _i = 0;
						while {_i < _errorIterations} do {
							_error = _error + (_errorPer100mMinMax call BIS_fnc_randomNum);
							_i = _i + 1;
						};
						private _randomAngle = [0, 360] call BIS_fnc_randomNum;
						private _locationWithError = [
							(_bestKnownLocation select 0) + _error * (cos _randomAngle),
							(_bestKnownLocation select 1) + _error * (sin _randomAngle),

							// Z has to be ATL, not ASL. ASL is returned from targetKnowledge.
							0
	 					];

						_roundsLeft = _roundsLeft - 1;

						private _type = (getArtilleryAmmo [_x]) select 0;
						_x doArtilleryFire [_locationWithError, _type, 1];

						["Artillery %1 to %2, error=%3", _type, _locationWithError, _error] call zdo_log_fnc_write;
					} forEach _artillery;

					// Wait until round is fired.
					sleep 5;
				};
			};
		};
	};

	_iter = _iter + 1;
	sleep _interval;
};