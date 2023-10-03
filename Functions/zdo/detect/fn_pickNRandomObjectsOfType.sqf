params ["_typeOrTypeList", "_count"];

private _objs = [_typeOrTypeList] call zdo_detect_fnc_pickAllObjectsOfType;
[_objs, _count] call zdo_detect_fnc_selectNRandom;
