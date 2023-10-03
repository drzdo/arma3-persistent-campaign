params ["_unit", "_newName"];

_unit setName _newName;

// Update ACE name.
[_unit] call ace_common_fnc_setName;

// Update dog tag.
_unit setVariable ["ace_dogtags_dogtagdata", nil];
[_unit] call ace_dogtags_fnc_getDogtagData;
