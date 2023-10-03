params ["_group", "_source", "_destination"];

[_group, _source] call zdo_pos_fnc_moveGroupToPosition;
_group addWaypoint [_destination, -1];
