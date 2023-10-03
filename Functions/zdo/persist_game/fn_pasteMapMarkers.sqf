{
    _x params [
        "_name",
        "_shape",
        "_pos",
        "_size",
        "_type",
        "_col",
        "_txt",
        "_brush",
        "_dir",
        "_poly"
    ] ;
    _marker = createMarker [_name,_pos] ;
    _marker setMarkerShape _shape ;
    _marker setMarkerSize _size ;
    _marker setMarkerType _type ;
    _marker setMarkerColor _col ;
    _marker setMarkerText _txt ;
    _marker setMarkerBrush _brush ;
    _marker setMarkerDir _dir ;
    if (count _poly > 0) then {
        _marker setMarkerPolyline _poly ;
    };
} forEach _this;
