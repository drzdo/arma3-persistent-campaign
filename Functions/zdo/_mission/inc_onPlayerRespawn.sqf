params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

if (!(isNull _oldUnit)) then {
	[_newUnit] call zdo_extra_fnc_makeSlightlyWounded;
};
