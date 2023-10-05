private _data = [];

{
	private _group = _x;

	private _units = (units _group) select { alive _x } apply {
		private _unit = _x;
		[
			["name", name _x],
			["type", typeOf _x],
			["isPlayer", isPlayer _x],
			["unitPos", unitPos _x],
			["pos", getPosATL _x],
			["dir", getDir _x],
			["gear", getUnitLoadout _x],
			["ace_medical", [_x] call ace_medical_fnc_serializeState],
			["vehicle", if ((vehicle _x) == _x) then {
				[]
			} else {
				private _v = vehicle _x;
				private _crew = fullCrew _v select {
					_x params ["_crewUnit"];
					_crewUnit == _unit;
				};

				if (count _crew > 0) then {
					(_crew select 0) params ["_crewUnit", "_role", "_cargoIndex", "_turretPath"];

					[
						["pos", getPosATL _v],
						["type", typeOf _v],
						["role", _role],
						["cargoIndex", _cargoIndex],
						["turretPath", _turretPath]
					];
				} else {
					[];
				};
			}]
		];
	};

	if (count _units isEqualTo 0) then {
		continue;
	};

	_data pushBack [
		["id", groupId _group],
		["side", side _group],
		["units", _units]
	];
} forEach allGroups;

_data;
