params ["_objectMapRaw", "_layersMapRaw"];

private _h = createHashMapFromArray _objectMapRaw;

private _type = _h get "type";

// If some type is saved but it should not have been and we do not want to load it:
// - add it here to avoid loading into editor, load
// - add it to ignore list in saveObjectIfNeeded
// - delete it here.
private _typesToIgnore = [
];
if (_type in _typesToIgnore) exitWith {
	false;
};

private _layers = createHashMapFromArray _layersMapRaw;

private _rawType = _h get "kind";
private _layerStr = _layers get _rawType;
private _layerId = parseNumber _layerStr;

private _pos = _h get "pos";
private _o = create3DENEntity ["Object", _type, _pos select 0, true];
_o set3DENLayer _layerId;

private _zNew = _pos select 0 select 2;
if (_zNew > -1 && _zNew < 1) then {
	// Avoid accumulating Z-shift of objects on each load.
	_zNew = 0;
};

_o set3DENAttribute ["position", [_pos select 0 select 0, _pos select 0 select 1, _zNew]];
_o set3DENAttribute ["rotation", [_pos select 1, _pos select 2] call zdo_persist_editor_fnc_vecDirUpToXyzRotation];

private _initGlobal = [];
private _initServerOnly = [];

private _hasInventory = _o canAdd "FirstAidKit";
if (_hasInventory) then {
	// Clean default inventory on game load.
	_initServerOnly pushBack "clearItemCargoGlobal this;";
	_initServerOnly pushBack "clearBackpackCargoGlobal this;";
	_initServerOnly pushBack "clearMagazineCargoGlobal this;";
	_initServerOnly pushBack "clearWeaponCargoGlobal this;";
};

private _vars = _h getOrDefault ["vars", []];
{
	private _k = _x select 0;
	private _v = _x select 1;
	_initGlobal pushBack (format ['this setVariable ["%1", "%2"];', _k, _v]);
} forEach _vars;

private _flag = _h get "flag";
if ((typeName _flag == "STRING") && !(_flag isEqualTo "")) then {
	_o forceFlagTexture _flag;
	_initGlobal pushBack (format ['this forceFlagTexture "%1";', _flag]);
};

if (_rawType == "bu") then {
	if ((_o isKindOf "Ruins") && (_o isKindOf "HouseBase")) then {
		_initServerOnly pushBack "(nearestBuilding getPosATL this) setDamage [1, false];";
		_initServerOnly pushBack "deleteVehicle this;";
	};
};

if (_rawType == "bu" || _rawType == "th" || _rawType == "fl") then {
	_o set3DENAttribute ["Health", 1.0 - (_h get "damage")];
};

if (_rawType == "ve" || _rawType == "th") then {
	_items = _h get "container";
	{
		if ([_x] call zdo_util_fnc_isBackpack) then {
			_initServerOnly pushBack (format ['this addBackpackCargoGlobal ["%1", 1];', _x]);
		} else {
			_initServerOnly pushBack (format ['this addItemCargoGlobal ["%1", 1];', _x]);
		};
	} forEach _items;
};

if (_rawType == "ve") then {
	_dmg = _h get "damage";
	_hitpoints = _dmg select 0;
	_damages = _dmg select 2;
	_dmgi = 0;
	{
		_name = _x;
		_value = _damages select _dmgi;
		_o setHitPointDamage [_name, _value];
		if (_value > 0) then {
			_initServerOnly pushBack (format ['this setHitPointDamage ["%1", %2];', _name, _value]);
		};
		_dmgi = _dmgi + 1;
	} forEach _hitpoints;

	_o set3DENAttribute ["fuel", (_h get "fuel")];

	_tex = _h get "tex";
	_texi = 0;
	{
		_o setObjectTexture [_texi, _tex select _texi];
		_initGlobal pushBack (format ['this setObjectTexture [%1, "%2"];', _texi, _tex select _texi]);
		_texi = _texi + 1;
	} forEach _tex;
};

if (_rawType == "fl") then {
	private _phase = _h getOrDefault ["flagPhase", 0];
	_o animateSource ["Flag_source", _phase, true];
	_initServerOnly pushBack (format ['this animateSource ["Flag_source", %1, true];', _phase]);
};

[_o, _initServerOnly] call zdo_persist_editor_fnc_appendInitServerAttribute;
[_o, _initGlobal] call zdo_persist_editor_fnc_appendInitGlobalAttribute;
