params ["_sign", "_layerNames"];

private _otherSigns = [_sign] call zdo_detect_fnc_pickOtherObjectsOfSameType;
{
	private _objsInLayer = (getMissionLayerEntities _x) select 0;
	private _shouldKeepLayer = _sign in _objsInLayer;
	if (!_shouldKeepLayer) then {
		{
			deleteVehicleCrew _x;
			deleteVehicle _x;
		} forEach _objsInLayer;
	};
} forEach _layerNames;
