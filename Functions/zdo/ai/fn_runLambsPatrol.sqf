params ["_group", "_position"];

// https://github.com/nk3nny/LambsDanger/wiki/waypoints

/*
0: Group performing action, either unit <OBJECT> or group <GROUP>
1: Position being searched, default group position <OBJECT or ARRAY>
2: Range of tracking, default is 200 meters <NUMBER>
3: Waypoint Count, default 4 <NUMBER>
4: Area the AI Camps in, default [] <ARRAY> 5: Dynamic patrol pattern, default false <BOOL>

[bob, bob, 500] call lambs_wp_fnc_taskPatrol;
 */

[_group, _position] call zdo_pos_fnc_moveGroupToPosition;
[_group, _position, 50] call lambs_wp_fnc_taskPatrol;
