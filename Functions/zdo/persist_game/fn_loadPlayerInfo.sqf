/**
Load last saved player state.
To be called when player joins.
 */

params ["_player"];

private _tracker = ["zdo_player_info_tracker"] call zdo_persist_game_fnc_getOrCreateMarkedObject;

    private _playersRaw = _tracker getVariable ["zdo_players", []];
private _playersH = createHashMapFromArray _playersRaw;

private _playerInfo = _playersH get (name _player);
if (typeName _playerInfo == "ARRAY") then {
    private _playerInfoH = createHashMapFromArray _playerInfo;

    _player setPosATL (_playerInfoH get "pos");
    _player setDir (_playerInfoH getOrDefault ["dir", 0]);
    _player setUnitLoadout (_playerInfoH get "gear");

    private _med = _playerInfoH getOrDefault ["ace_medical", ""];
    if (count _med > 0) then {
        [_player, _med] call ace_medical_fnc_deserializeState;
    };
};
