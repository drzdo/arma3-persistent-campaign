params ["_root"];

if (_root != zdo_root) then {
	throw "zdo_root is not set";
};

_root setVariable ["zdo_kill_pos", []];

addMissionEventHandler ["EntityKilled", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	_thisArgs params ["_root"];
	
	private _list = _root getVariable ["zdo_kill_pos", []];
	_list pushBack [
		["pos", getPosWorld _unit],
		["man", (_unit isKindOf "Man")]
	];

	private _maxCount = 100;
	private _maxThreshold = 10;
	if ((count _list) > (_maxCount + _maxThreshold)) then {
		_list = _list select [_maxThreshold, _maxCount];
	};

	_root setVariable ["zdo_kill_pos", _list];
}, [_root]];
