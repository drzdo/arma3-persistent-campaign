params ["_group", "_destination"];

private _wp = _group addWaypoint [_destination, -1];
_wp setWaypointType "SAD";
