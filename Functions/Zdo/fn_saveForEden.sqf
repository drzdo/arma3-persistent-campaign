private _saveIfNeeded = {
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

	private _object = _this select 0;
	
	private _type = typeOf _object;
	if (_type in _typesToIgnore) exitWith {
		[];
	};
	if (_type in _typesToSave) exitWith {
		_this call _saveAsBuilding;
	};
	
	private _objectType = _object call BIS_fnc_objectType;
	if (_objectType isEqualTo ["Object", "House"]) exitWith {
		_this call _saveAsBuilding;	   
	};
	if ((_objectType select 0) == "Vehicle") exitWith {
		_this call _saveAsVehicle;
	};
    
    if (_objectType isEqualTo ["Object", "AmmoBox"]) exitWith {
		_this call _saveAsThing;
	};
    
    _result = [];
    
    if (_objectType isEqualTo ["Object", "Thing"]) then {
        private _isEmptyModel = (getModelInfo _object select 0) == "empty.p3d";
        if (!_isEmptyModel) then {
            _result = _this call _saveAsThing;
        };
	};

	_result;
};
private _saveAsBuilding = {
	_o = _this select 0;
	[
		["kind", "bu"],
		["type", typeOf _o],
		["pos", [getPosATL _o, vectorDir _o, vectorUp _o]],
		["damage", damage _o],
		["tex", getObjectTextures _o],
        ["attrs", [_o] call _saveCustomAttrs]
	];
};
private _saveAsVehicle = {
	private _o = _this select 0;
    
    private _flag = toLower (getForcedFlagTexture _o);
    if (count _flag > 0) then {
        private _root = toLower (getMissionPath "");
        private _flagRemoveFrom = _flag find _root;
        if (_flagRemoveFrom == 0) then {
            _flag = _flag select [count _root];
        };
    };
    
	[
		["kind", "ve"],
		["type", typeOf _o],
		["pos", [getPosATL _o, vectorDir _o, vectorUp _o]],
		["damage", getAllHitPointsDamage _o],
		["fuel", fuel _o],
		["container", [_o] call ZDO_fnc_serializeContainer],
		["tex", getObjectTextures _o],
        ["attrs", [_o] call _saveCustomAttrs],
        ["flag", _flag]
	];
};
private _saveAsThing = {
	_o = _this select 0;
	[
		["kind", "th"],
		["type", typeOf _o],
		["pos", [getPosATL _o, vectorDir _o, vectorUp _o]],
		["damage", damage _o],
		["container", [_o] call ZDO_fnc_serializeContainer],
        ["attrs", [_o] call _saveCustomAttrs]
	];
};

private _saveCustomAttrs = {
	private _o = _this select 0;
    private _attrs = allVariables _o;
    private _r = [];
    {
        private _isCustomAttr = ["zdo_", _x] call BIS_fnc_inString;
        if (!_isCustomAttr) then {
            continue;
        };
        
        private _v = _o getVariable [_x, ""];
        if (_v isEqualTo "") then {
            continue;
        };
        _r pushBack [_x, _v];
    } forEach _attrs;
    _r;
};

private _savePlayersLoadouts = {
    private _storage = _this select 0;

    private _players = createHashMap;
    
    private _oldPlayers = _storage get "players";
    if (typeName _oldPlayers == "ARRAY") then {
        {
            _players set _x;
        } forEach _oldPlayers;
    };
    
    {
        _players set [name _x, [
            ["pos", getPosATL _x],
            ["gear", getUnitLoadout _x]
        ]];
    } forEach allPlayers;
    
    _players;
};

private _saveMines = {
    private _mines = [];
    {
        private _o = _x;
        _mines pushBack [
            ["pos", [getPosATL _o, vectorDir _o, vectorUp _o]],
            ["type", typeOf _o]
        ];
    } forEach allMines;
    _mines;
};

private _objects = [];
private _ignored = [];

private _storage = call ZDO_fnc_storage;

{
    _saved = [_x] call _saveIfNeeded;
    if ((count _saved) > 0) then {
        _objects pushBack _saved;
    } else {
        _ignored pushBack [_x, typeOf _x, _x call BIS_fnc_objectType];
    }
} forEach (allMissionObjects "");

[
    ["objects", _objects],
    ["players", [_storage] call _savePlayersLoadouts],
    ["mines", call _saveMines],
    ["map", call ZDO_fnc_copyMapMarkers],
    ["save_time", format (["%1-%2-%3-%4-%5-%6"] + systemTimeUTC)],
    ["kill_pos", zdo_root getVariable ["zdo_kill_pos", []]]
];
