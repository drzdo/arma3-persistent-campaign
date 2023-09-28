params ["_o"];

private _nestedContainers = everyContainer _o;

private _nestedChildren = [];
private _items = [];
{
    private _type = _x;

    private _isNested = false;
    private _nestedI = 0;
    {
        private _nested = _x;
        private _nestedType = _nested select 0;
        if (_nestedType == _type) then {
            private _nestedObj = _nested select 1;
            private _rChild = [_nestedObj] call serializeContainer;
            _nestedChildren pushBack [_nestedType, _rChild];
            _isNested = true;
            break;
        };
        _nestedI = _nestedI + 1;
    } forEach _nestedContainers;
    
    if (_isNested) then {
        _nestedContainers deleteAt _nestedI;
    } else {
        _items pushBack _type;
    };
} forEach (flatten [itemCargo _o, backpackCargo _o]);

private _weaponsCargo = [];
{
    _weaponsCargo pushBack _x;
} forEach weaponsItemsCargo _o;

private _magazineCargo = [];
{
    _magazineCargo pushBack _x;
} forEach magazineCargo _o;

private _r = [];
{
    if ((typeName _x == "STRING") && !(_x isEqualTo "")) then {
        _r pushBackUnique _x;
    };
} forEach (flatten [_items, _magazineCargo, _weaponsCargo, _nestedChildren]);
_r;
