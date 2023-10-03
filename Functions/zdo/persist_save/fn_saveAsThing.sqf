params ["_o"];
[
	["kind", "th"],
	["type", typeOf _o],
	["pos", [getPosATL _o, vectorDir _o, vectorUp _o]],
	["damage", damage _o],
	["container", [_o] call zdo_util_fnc_serializeContainer],
	["vars", [_o] call zdo_persist_save_fnc_saveZdoVariables]
];