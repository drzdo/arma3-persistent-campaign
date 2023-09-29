params ["_t", "_count"];

private _objs = (
	(_t allObjects 0)
	+
	(_t allObjects 1)
);
[_objs, _count] call ZDOGM_fnc_selectNRandom;
