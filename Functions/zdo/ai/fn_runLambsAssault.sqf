params ["_group", "_source", "_destination"];

// https://github.com/nk3nny/LambsDanger/wiki/waypoints

/*
0: Unit fleeing <OBJECT>
1: Destination <ARRAY>
2: Forced retreat, default false <BOOL>
3: Distance threshold, default 10 <NUMBER>
4: Update cycle, default 2 <NUMBER>
5: Is Called for Waypoint, default false <BOOLEAN>

[bob, getPos angryJoe] spawn lambs_wp_fnc_taskAssault;
 */

[_group, _source] call zdo_pos_fnc_moveGroupToPosition;
[_group, _destination, false] spawn lambs_wp_fnc_taskAssault;
