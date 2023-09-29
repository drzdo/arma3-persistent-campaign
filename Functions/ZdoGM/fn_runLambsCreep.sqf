params ["_group", "_position"];

// https://github.com/nk3nny/LambsDanger/wiki/waypoints

/*
0: Group performing action, either unit <OBJECT> or group <GROUP>
1: Range of tracking, default is 500 meters <NUMBER>
2: Delay of cycle, default 15 seconds <NUMBER>
3: Area the AI Camps in, default [] <ARRAY>
4: Center Position, if no position or Empty Array is given it uses the Group as Center and updates the position every Cycle, default [] <ARRAY>
5: Only Players, default true <BOOL>

[bob, 500] spawn lambs_wp_fnc_taskCreep;
 */

[_group, _position] call ZDOGM_fnc_moveGroupToPosition;
[_group, 3000] spawn lambs_wp_fnc_taskCreep;
