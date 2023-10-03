params ["_o", "_init"];

if (count _init > 0) then {
	private _initToSet = "";

	private _existingInit = _o get3DENAttribute "Init";
	if (count _existingInit > 0) then {
		_initToSet = _existingInit select 0;
	};

	if (count _initToSet > 0) then {
		_initToSet = _initToSet + endl;
	};

	_initToSet = _initToSet + (_init joinString endl);
	_o set3DENAttribute ["Init", _initToSet];
};
