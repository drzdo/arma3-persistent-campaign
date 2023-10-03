params ["_object", "_count"];

private _objs = [_object] call zdo_detect_fnc_pickOtherObjectsOfSameType;
[_objs, _count] call zdo_detect_fnc_selectNRandom;
