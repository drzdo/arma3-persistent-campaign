params ["_o", "_init"];

private _initToAppend = [];

if (count _init > 0) then {
	_initToAppend pushBack "if (isServer) then {";
	_initToAppend append _init;
	_initToAppend pushBack "};";

	[_o, _initToAppend] call zdo_persist_editor_fnc_appendInitGlobalAttribute;
};
