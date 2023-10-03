/**
When GM wants to make respawns slightly more "harsh" so the players do not respawn easily.
Potentially, each next respawn can induce bigger penalty.
Remember about balancing immersiveness and fun.
 */

params ["_unit"];

private _bodyParts = ["leftarm", "rightarm", "head", "torso", "leftleg", "rightleg"];

private _bodyPartsToDamage = [0, 4] call BIS_fnc_randomInt;
[_unit, _unit] call ace_medical_treatment_fnc_fullHeal;

private _i = 0;
while {(_i < _bodyPartsToDamage) && (_i < (count _bodyParts))} do {
	private _index = [0, (count _bodyParts) - 1] call BIS_fnc_randomInt;
	private _part = _bodyParts select _index;
	_bodyParts deleteAt _index;

	private _dmg = [0.1, 1.0] call BIS_fnc_randomNum;

	private _dmgType = selectRandom ["stab", "bullet"];

	[_unit, _dmg, _part, _dmgType, _unit] call ace_medical_fnc_addDamageToUnit;

	[_unit, _unit, _part, "FieldDressing"] call ace_medical_treatment_fnc_bandage;
	[_unit, _unit, _part, "FieldDressing"] call ace_medical_treatment_fnc_bandage;
	[_unit, _unit, _part, "FieldDressing"] call ace_medical_treatment_fnc_bandage;

	[_unit, _unit, _part] call ace_medical_treatment_fnc_splint;

	_i = _i + 1;
};

[_unit, false, 0, false] call ace_medical_fnc_setUnconscious;
[_unit, -1.0] call ace_medical_fnc_adjustPainLevel;
[_unit, "activity", "Residual wounds after respawn", []] call ace_medical_treatment_fnc_addToLog;
