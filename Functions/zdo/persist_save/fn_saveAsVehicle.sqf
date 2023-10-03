params ["_o"];

[
	["kind", "ve"],
	["type", typeOf _o],
	["pos", [getPosATL _o, vectorDir _o, vectorUp _o]],
	["damage", getAllHitPointsDamage _o],
	["fuel", fuel _o],
	["container", [_o] call zdo_util_fnc_serializeContainer],
	["tex", getObjectTextures _o],
	["vars", [_o] call zdo_persist_save_fnc_saveZdoVariables],
	["flag", [_o] call zdo_persist_save_fnc_getForcedFlagTexture]
];