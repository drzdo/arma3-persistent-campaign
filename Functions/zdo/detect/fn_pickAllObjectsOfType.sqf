params ["_typeOrTypeList"];

private _types = if (typeName _typeOrTypeList == "ARRAY") then {_typeOrTypeList} else {[_typeOrTypeList]};

private _objs = [];
{
	_objs append (_x allObjects 0);
	_objs append (_x allObjects 1);
} forEach _types;

_objs;
