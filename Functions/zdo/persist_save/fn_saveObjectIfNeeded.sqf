params ["_object"];

private _typesToIgnore = [
	"babe_helper",
	"CBA_NamespaceDummy",
	"ACE_Rallypoint_West_Base",
	"ACE_Rallypoint_East_Base",
	"ACE_Rallypoint_Independent_Base",
	"VR_3DSelector_01_default_F",
	"UserTexture1m_F",
	"HIG_mywall"
];
private _typesToSave = [
	"ACE_Rallypoint_West",
	"ACE_Rallypoint_East",
	"ACE_Rallypoint_Independent"
];

private _type = typeOf _object;
if (_type in _typesToIgnore) exitWith {
	[];
};
if (_type in _typesToSave) exitWith {
	_this call zdo_persist_save_fnc_saveAsBuilding;
};

private _objectType = _object call BIS_fnc_objectType;
if (_objectType isEqualTo ["Object", "House"]) exitWith {
	_this call zdo_persist_save_fnc_saveAsBuilding;
};
if (_type isEqualTo "PortableFlagPole_01_F") exitWith {
	_this call zdo_persist_save_fnc_saveAsFlag;
};
if ((_objectType select 0) == "Vehicle") exitWith {
	_this call zdo_persist_save_fnc_saveAsVehicle;
};

if (_objectType isEqualTo ["Object", "AmmoBox"]) exitWith {
	_this call zdo_persist_save_fnc_saveAsThing;
};

_result = [];

if (_objectType isEqualTo ["Object", "Thing"]) then {
	private _isEmptyModel = (getModelInfo _object select 0) == "empty.p3d";
	if (!_isEmptyModel) then {
		_result = _this call zdo_persist_save_fnc_saveAsThing;
	};
};

_result;
