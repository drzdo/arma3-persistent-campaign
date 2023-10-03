params ["_center"];

private _x = _center select 0;
private _y = _center select 1;

private _coordToStr = {
	params ["_v"];
	str floor (_v / 100.0);
};

format ["%1%2", [_x] call _coordToStr, [_y] call _coordToStr];
