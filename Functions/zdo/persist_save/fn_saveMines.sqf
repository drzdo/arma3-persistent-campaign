private _mines = [];
{
    private _o = _x;
    _mines pushBack [
        ["pos", [getPosATL _o, vectorDir _o, vectorUp _o]],
        ["type", typeOf _o]
    ];
} forEach allMines;
_mines;
