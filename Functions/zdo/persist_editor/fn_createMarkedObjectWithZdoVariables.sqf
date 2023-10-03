params ["_vars", "_layer"];

private _o = create3DENEntity ["Object", "VR_3DSelector_01_default_F", [0, 0, 0], true];
_o set3DENAttribute ["Init", [
	"this hideObject true;",
	"this allowDamage false;",
	"this enableSimulationGlobal false;"
] joinString endl];

_o set3DENLayer _layer;

private _initServerOnly = [];
{
	private _k = _x select 0;
	private _v = _x select 1;
	_initServerOnly pushBack format ["this setVariable [%1, %2, true];", str _k, str _v];
} forEach _vars;

[_o, _initServerOnly] call zdo_persist_editor_fnc_appendInitServerAttribute;

_o;
