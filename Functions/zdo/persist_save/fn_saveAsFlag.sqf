params ["_o"];
[
	["kind", "fl"],
	["type", typeOf _o],
	["pos", [getPosATL _o, vectorDir _o, vectorUp _o]],
	["damage", damage _o],
	["tex", getObjectTextures _o],
	["vars", [_o] call zdo_persist_save_fnc_saveZdoVariables],
	["flag", [_o] call zdo_persist_save_fnc_getForcedFlagTexture],
	["flagPhase", _o animationSourcePhase "Flag_source"]
];
