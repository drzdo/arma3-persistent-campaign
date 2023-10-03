params ["_sourceLayerName", "_destinationLayerName", "_signOrPos"];

private _srcObjects = (getMissionLayerEntities _sourceLayerName) select 0;

private _dstObjects = (getMissionLayerEntities _destinationLayerName) select 0;

private _signPos = if (typeName _signOrPos == "ARRAY") then {_signOrPos} else {getPosATL _signOrPos};

private _dstObjectsByTypeUnsorted = createHashMap;
{
	private _l = _dstObjectsByTypeUnsorted getOrDefault [typeOf _x, []];
	_l pushBack [_x, [_signPos, getPosATL _x] call BIS_fnc_distance2Dsqr];
	_dstObjectsByTypeUnsorted set [typeOf _x, _l];
} forEach _dstObjects;

private _dstObjectsByTypeSorted = createHashMap;
{
	private _ySorted = [_y, [], {_x select 1}, "ASCEND"] call BIS_fnc_sortBy;
	_dstObjectsByTypeSorted set [_x, _ySorted];
} forEach _dstObjectsByTypeUnsorted;

{
	private _l = _dstObjectsByTypeSorted getOrDefault [typeOf _x, []];
	private _place = _l select 0;
 	_l deleteAt 0;
	_dstObjectsByTypeSorted set [typeOf _x, _l]; 

	private _dst = _place select 0;
	_x setPosATL (getPosATL _dst); 
	_x setDir (getDir _dst); 
} forEach _srcObjects;
