try {
    #include "Functions\zdo\_mission\inc_initServer.sqf"

	// Here goes the mission setup.

    ["No errors during initServer"] call zdo_log_fnc_write;
} catch {
    ["ERROR %1", str _exception] call zdo_log_fnc_write;
}