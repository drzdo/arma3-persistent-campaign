_this spawn {
	params ["_o", "_args"];

	private _h = createHashMapFromArray _args;

	private _markerPrecise = createMarker [format ["zdo_tracker_%1", str netId _o], _o];
	private _r = _h getOrDefault ["radius", 0];
	
	// https://community.bistudio.com/wiki/Arma_3:_CfgMarkers
	// https://community.bistudio.com/wikidata/images/thumb/f/f0/A3_MarkerTypes.png/1920px-A3_MarkerTypes.png
	_markerPrecise setMarkerType (_h getOrDefault ["type", "hd_dot"]);

	_markerPrecise setMarkerText (_h getOrDefault ["text", "GPS Tracker"]);
	_markerPrecise setMarkerColor (_h getOrDefault ["color", "ColorBlack"]);
	
	private _precise = _r < 1;
	private _markerCircle = nil;
	if (!_precise) then {
		_markerCircle = createMarker [format ["zdo_tracker_circle_%1", str netId _o], _o];
		_markerCircle setMarkerShape "ELLIPSE";
		_markerCircle setMarkerSize [_r, _r];
		_markerCircle setMarkerColor (_h getOrDefault ["color", "ColorBlack"]);
	};

	while {true} do {
		private _center = getPosATL _o;

		if (!_precise) then {
			_center = [
				// Not strictly radius, rather quad side, but anyway.
				(_center select 0) + (random _r),
				(_center select 1) + (random _r),
				(_center select 2)
			];

			_markerCircle setMarkerPos _center;
		};
		
		_markerPrecise setMarkerPos _center;
		
		sleep parseNumber (_h getOrDefault ["interval", "3"]);
	};
};