params ["_o"];
private _flag = toLower (getForcedFlagTexture _o);
if (count _flag > 0) then {
	private _root = toLower (getMissionPath "");
	private _flagRemoveFrom = _flag find _root;
	if (_flagRemoveFrom == 0) then {
		_flag = _flag select [count _root];
	};
};
_flag;
