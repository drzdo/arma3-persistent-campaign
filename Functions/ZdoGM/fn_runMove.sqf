params ["_group", "_source", "_destination"];

[_group, _source] call ZDOGM_fnc_moveGroupToPosition;
_group addWaypoint [_destination, -1];
