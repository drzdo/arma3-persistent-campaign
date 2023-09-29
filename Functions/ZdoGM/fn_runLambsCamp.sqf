params ["_group", "_position"];

// https://github.com/nk3nny/LambsDanger/wiki/waypoints

/*
0: Group performing action, either unit <OBJECT> or group <GROUP>
1: Central position camp should be made, <ARRAY>
2: Range of patrols and turrets found, default is 50 meters <NUMBER>
3: Area the AI Camps in, default [] <ARRAY>
4: Teleport Units to Position <BOOL>
5: Partial group Patrols the Area <BOOL>

[bob, getPos bob, 50] call lambs_wp_fnc_taskCamp;
 */

[_group, _position, 50, [], true, false] call lambs_wp_fnc_taskCamp;
