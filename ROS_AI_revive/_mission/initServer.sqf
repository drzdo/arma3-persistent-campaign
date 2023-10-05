// Stop AI respawning when killed
{
	_x addMPEventHandler ["MPRespawn", {
		params ["_unit"];
		if (!isPlayer _unit) exitWith {
			deleteVehicle _unit
		}
	}]
} forEach playableUnits;
