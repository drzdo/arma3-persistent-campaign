params ["_object", "_typeOrTypeList"];

private _types = if (typeName _typeOrTypeList == "ARRAY") then {_typeOrTypeList} else {[_typeOrTypeList]};
nearestObjects [_object, _types, 100] select 0;
