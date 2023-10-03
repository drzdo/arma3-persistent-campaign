params ["_object"];

private _t = typeOf _object;
private _objs = (
	((_t allObjects 0) select { _x != _object })
	+
	((_t allObjects 1) select { _x != _object })
);
_objs;
