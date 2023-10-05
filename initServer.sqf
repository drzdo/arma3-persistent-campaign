#include "Functions\zdo\_mission\inc_initServer.sqf"
#include "ROS_AI_revive\_mission\initServer.sqf"

try {
    ["No errors during initServer"] call zdo_log_fnc_write;
} catch {
    ["ERROR %1", str _exception] call zdo_log_fnc_write;
}
