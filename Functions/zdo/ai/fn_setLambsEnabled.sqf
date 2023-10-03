params ["_group", "_enabled"];

// https://github.com/nk3nny/LambsDanger/wiki/variables

_group setVariable ["lambs_danger_disableGroupAI", !_enabled];
{
	_x setVariable ["lambs_danger_disableAI", !_enabled];
} forEach units _group;
