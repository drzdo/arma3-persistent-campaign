params ["_object", "_count"];

private _objs = [_object] call ZDOGM_fnc_pickOtherObjectsOfSameType;
[_objs, _count] call ZDOGM_fnc_selectNRandom;
