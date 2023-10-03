params ["_center", "_radius"];

private _locations = [];

private _bestPlaces = selectBestPlaces [
	_center,
	_radius,
	"trees*3 + forest - houses * 10",
	15,
	50
];
_locations append (_bestPlaces apply {
	private _pos = _x select 0;
	[
		_pos select 0,
		_pos select 1,
		0
	];
});

_locations;
