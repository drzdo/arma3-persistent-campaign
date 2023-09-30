params ["_group", "_source", "_destination"];

[_group, _source] call ZDOGM_fnc_moveGroupToPosition;
private _wp = _group addWaypoint [_destination, -1];
_wp setWaypointType "SAD";
