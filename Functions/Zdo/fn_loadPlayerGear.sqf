params ["_player"];

private _storage = call ZDO_fnc_storage;
if ("players" in _storage) then {
    private _players = _storage get "players";
    private _playersH = createHashMapFromArray _players;
    private _playerInfo = _playersH get (name _player);
    if (typeName _playerInfo == "ARRAY") then {
        private _playerInfoH = createHashMapFromArray _playerInfo;
        _player setPosATL (_playerInfoH get "pos");
        _player setUnitLoadout (_playerInfoH get "gear");
    };
};
1;
