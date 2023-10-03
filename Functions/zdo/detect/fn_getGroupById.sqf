private _list = allGroups select {groupId _x == _this};
if ((count _list) > 0) then {
	_list select 0;
} else {
	objNull;
}
