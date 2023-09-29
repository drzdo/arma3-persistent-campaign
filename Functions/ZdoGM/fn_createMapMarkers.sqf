params ["_objs", "_name", "_color"];

// https://community.bistudio.com/wiki/Arma_3:_CfgMarkerColors

{
	private _markerIndex = missionNamespace getVariable ["zdo_nextMarkerIndex", 1];
	missionNamespace setVariable ["zdo_nextMarkerIndex", _markerIndex + 1];

	private _markerName = format ["zdo_marker_%1", _markerIndex];

	private _marker = createMarker [_markerName, _x];
	_marker setMarkerType "hd_dot";
	_marker setMarkerText format [_name, _markerIndex];
	_marker setMarkerColor _color;
} forEach _objs;
