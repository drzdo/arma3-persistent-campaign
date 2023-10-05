params ["_data", "_layer", "_layerVehicles"];

private _unitPosToId = createHashMapFromArray [
	["Auto", 3],
	["Up", 0],
	["Middle", 1],
	["Down", 2]
];

private _allVehicles = get3DENLayerEntities _layerVehicles;

{
	private _g = createHashMapFromArray _x;

	private _group = objNull;
	{
		private _u = createHashMapFromArray _x;
		private _unit = if (isNull _group) then {
			create3DENEntity ["Object", _u get "type", _u get "pos"];
		} else {
			_group create3DENEntity ["Object", _u get "type", _u get "pos"];
		};
		_unit set3DENLayer _layer;
		_group = group _unit;

		_unit set3DENAttribute ["rotation", [0, 0, _u get "dir"]];
		_unit set3DENAttribute ["unitPos", _u get "stance"];

		_unit set3DENAttribute ["ControlSP", false];
		_unit set3DENAttribute ["ControlMP", _u get "isPlayer"];
		if (_u get "isPlayer") then {
			_unit set3DENAttribute ["description", format ["Saved player %1", _u get "name"]];
		};

		_unit set3DENAttribute ["unitName", _u get "name"];
		_unit set3DENAttribute ["unitPos", _unitPosToId getOrDefault [_u get "unitPos", 3]];

		_unit setUnitLoadout (_u get "gear");

		private _initServer = [];
		_initServer pushBack format ["this setUnitLoadout %1;", str (_u get "gear")];
		_initServer pushBack format ["[this, %1] call ace_medical_fnc_deserializeState;", str (_u get "ace_medical")];

		private _vRaw = _u getOrDefault ["vehicle", []];
		if (count _vRaw > 0) then {
			private _v = createHashMapFromArray _vRaw;

			_initServer pushBack format ["private _vehicles = nearestObjects [getPosATL this, [%1], 10, true];", str (_v get "type")];
			_initServer pushBack "if (count _vehicles > 0) then {";
			_initServer pushBack "private _vehicle = _vehicles select 0;";

			private _role = _v get "role";
			private _cargoIndex = _v get "cargoIndex";
			private _turretPath = _v get "turretPath";

			if (_role isEqualTo "driver") then {
				_initServer pushBack format ["this assignAsDriver _vehicle;"];
				_initServer pushBack format ["this moveInDriver _vehicle;"];
			};
			if (_role isEqualTo "commander") then {
				_initServer pushBack format ["this assignAsCommander _vehicle;"];
				_initServer pushBack format ["this moveInCommander _vehicle;"];
			};
			if (_role isEqualTo "cargo") then {
				_initServer pushBack format ["this assignAsCargo _vehicle;"];

				if (count _turretPath > 0) then {
					_initServer pushBack format ["this moveInTurret [_vehicle, %1];", str _turretPath];
				} else {
					if (_cargoIndex == -1) then {
						_initServer pushBack format ["this moveInCargo _vehicle;"];
					} else {
						_initServer pushBack format ["this moveInCargo [_vehicle, %1];", _cargoIndex];
					};
				};
			};
			if (_role isEqualTo "turret") then {
				_initServer pushBack format ["this assignAsTurret [_vehicle, %1];", str _turretPath];
				_initServer pushBack format ["this moveInTurret [_vehicle, %1];", str _turretPath];
			};
			if (_role isEqualTo "gunner") then {
				_initServer pushBack format ["this assignAsGunner _vehicle;"];
				_initServer pushBack format ["this moveInTurret [_vehicle, %1];", str _turretPath];
			};

			_initServer pushBack "};";
		};

		[_unit, _initServer] call zdo_persist_editor_fnc_appendInitServerAttribute;
	} forEach (_g get "units");
} forEach _data;
