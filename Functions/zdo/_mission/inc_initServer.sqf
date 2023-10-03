call zdo_log_fnc_clean;

["zdo initServer.sqf starting..."] call zdo_log_fnc_write;

call zdo_fortify_fnc_initServer;
call zdo_persist_game_fnc_initAll;

["zdo initServer.sqf completed"] call zdo_log_fnc_write;
