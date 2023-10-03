/**
When game master wants to make a container an arsenal.
Idempotent.
 */

params ["_box"];

[_box] remoteExec ["zdo_arsenal_fnc_makeArsenal", 0];