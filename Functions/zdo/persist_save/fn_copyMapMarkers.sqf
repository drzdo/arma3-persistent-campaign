/**
Copy all map markers in the array.
*/

private _array = [] ;
{
    if (_x find "_USER_DEFINED #" != -1) then {
        _array = _array + [[
        _x,
        markerShape _x,
        markerPos _x,
        markerSize _x,
        markerType _x,
        markerColor _x,
        markerText _x,
        markerBrush _x,
        markerDir _x,
        markerPolyline _x
        ]] ;
    } ;
} forEach allMapMarkers;
_array;
