params ["_dir", "_up"];

private _aside = _dir vectorCrossProduct _up;

private _xRot = 0;
private _yRot = 0;
private _zRot = 0;

if (abs (_up select 0) < 0.999999) then {
	_yRot = -asin (_up select 0);

	private _signCosY = if (cos _yRot < 0) then { -1 } else { 1 };

	_xRot = (_up select 1 * _signCosY) atan2 (_up select 2 * _signCosY);
	_zRot = (_dir select 0 * _signCosY) atan2 (_aside select 0 * _signCosY);
} else {
	_zRot = 0;

	if (_up select 0 < 0) then {
		_yRot = 90;
		_xRot = (_aside select 1) atan2 (_aside select 2);
	} else {
		_yRot = -90;
		_xRot = (-(_aside select 1)) atan2 (-(_aside select 2));
	};
};

[_xRot, _yRot, _zRot];
