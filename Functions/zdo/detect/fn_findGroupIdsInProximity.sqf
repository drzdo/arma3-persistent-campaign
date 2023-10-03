params ["_center", "_radius"];

private _units = _center nearEntities ["Man", _radius];
private _groupIds = [];
{
	private _groupId = groupId group _x;
	_groupIds pushBackUnique _groupId;
} forEach _units;
_groupIds;
