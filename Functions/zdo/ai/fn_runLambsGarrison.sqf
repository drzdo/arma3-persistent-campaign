params ["_group", "_position", ["_patrol", false], ["_teleport", false]];

// https://github.com/nk3nny/LambsDanger/wiki/waypoints

/*
0: Group performing action, either unit <OBJECT> or group <GROUP>
1: Position to occupy, default group location <ARRAY or OBJECT>
2: Range of tracking, default is 50 meters <NUMBER>
3: Area the AI Camps in, default [] <ARRAY>
4: Teleport Units to Position <BOOL>
5: Sort Based on Height <BOOL>
6: Exit Conditions that breaks a Unit free (-2 Random, -1 All, 0 None, 1 Hit, 2 Fired, 3 FiredNear, 4 Suppressed), default -2 <NUMBER>
7: Sub-group patrols the area <BOOL>

[bob, bob, 50] call lambs_wp_fnc_taskGarrison;
 */

[_group, _position, 30, [], true, _teleport, -2, _patrol] call lambs_wp_fnc_taskGarrison;
