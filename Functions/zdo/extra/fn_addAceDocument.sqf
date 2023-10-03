params ["_object", "_text"];
// Only on server.
[_object, "acex_intelitems_document", _text] remoteExec ["ace_intelitems_fnc_addIntel", 2];
