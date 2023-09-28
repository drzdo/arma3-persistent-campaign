{
    if (_x find "_USER_DEFINED #" != -1) then {
        deleteMarker _x;
    };
} forEach allMapMarkers;
