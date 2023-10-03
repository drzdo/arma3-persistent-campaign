params ["_object", "_text"];

// Only on server.
[_object, "acex_intelitems_notepad", _text] remoteExec ["ace_intelitems_fnc_addIntel", 2];
