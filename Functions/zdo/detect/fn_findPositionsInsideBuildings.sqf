params ["_center", "_radius"];

private _locations = [];

private _buildings = _center nearObjects ["House", _radius];
{
	{
		_locations pushBack _x;
	} forEach (_x buildingPos -1);
} forEach _buildings;
_locations;