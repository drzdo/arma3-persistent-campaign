params ["_playerUnit", "_didJIP"];

private _originalPos = getPosATL _playerUnit;
[_playerUnit] call zdo_persist_game_fnc_loadPlayerInfo;

if (is3DENMultiplayer) then {
    // For debugging.
    _playerUnit setPosATL _originalPos;
};

call zdo_fortify_fnc_initPlayerLocal;
call zdo_arsenal_fnc_init;
call zdo_flag_fnc_init;

addMissionEventHandler ["HandleChatMessage", {
	params ["_channel", "_owner", "_from", "_text", "_person", "_name", "_strID", "_forcedDisplay", "_isPlayerMessage", "_sentenceType", "_chatMessageType"];

	if (_text isEqualTo "/save") then {
		[] spawn zdo_persist_save_fnc_saveAllAndShowMessage;
        true;
	};
}];
