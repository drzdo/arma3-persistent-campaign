params ["_layerName"];
private _debug = param [1, false];

private _l = (getMissionLayerEntities _layerName) select 0;
{
	if (_debug == true) then {
		_x hideObjectGlobal true;
		_x enableSimulationGlobal false;
		_x allowDamage false;
	} else {
		deleteVehicle _x;
	};
} forEach _l;
