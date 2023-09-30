// Types should not be saved rather than saved but not loaded.
// This list is for gradual upgrading from old save version to new load version.
private _typesToIgnore = [
    "HIG_mywall"
];
    
private _loadObject = {
	private _hraw = _this select 0;
	private _h = createHashMapFromArray _hraw;
    
    private _type = _h get "type";
    if (_type in _typesToIgnore) then {
        continue;
    };
    
	private _layers = createHashMapFromArray (_this select 1);
    
	private _rawType = _h get "kind";
    private _layerStr = _layers get _rawType;
    private _layerId = parseNumber _layerStr;

	private _pos = _h get "pos";
	private _o = create3DENEntity ["Object", _type, _pos select 0, true];
	_o set3DENLayer _layerId;
    
    private _zNew = _pos select 0 select 2;
    if (_zNew > -1 && _zNew < 1) then {
        // Avoid accumulating Z-shift of objects on each load. Bug in Arma?
        _zNew = 0;
    };
    
	_o set3DENAttribute ["position", [_pos select 0 select 0, _pos select 0 select 1, _zNew]];
    
	_o set3DENAttribute ["rotation", [_pos select 1, _pos select 2] call _get3denRotation];
	
	private _initGlobal = [];
    private _initServerOnly = [];
    
    private _hasInventory = _o canAdd "FirstAidKit";
    if (_hasInventory) then {
        _initServerOnly pushBack "clearItemCargoGlobal this;";
        _initServerOnly pushBack "clearBackpackCargoGlobal this;";
        _initServerOnly pushBack "clearMagazineCargoGlobal this;";
        _initServerOnly pushBack "clearWeaponCargoGlobal this;";
    };

    private _attrsRaw = _h get "attrs";
    if (typeName _attrsRaw == "ARRAY") then {
        {
            private _k = _x select 0;
            private _v = _x select 1;

            if ((_k isEqualTo "zdo_arsenal") && (_v isEqualTo "1")) then {
                _initGlobal pushBack (format ['[this] call ZDO_fnc_makeArsenal;']);
            };

            _initGlobal pushBack (format ['this setVariable ["%1", "%2"];', _k, _v]);
        } forEach _attrsRaw;
    };
    
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
            if ([_x] call ZDO_fnc_isBackpack) then {
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
	
    private _init = [];
    _init append _initGlobal;
    
    if (count _initServerOnly > 0) then {
        _initServerOnly insert [0, ["if (isServer) then {"], false];
        _initServerOnly pushBack "};";
        _init append _initServerOnly;
    };
    
    if (count _init > 0) then {
        _o set3DENAttribute ["Init", _init joinString endl];
    };
};

_get3denRotation = {
	private _dir = _this select 0;
	private _up = _this select 1;
	private _aside = _dir vectorCrossProduct _up;

	private ["_xRot", "_yRot", "_zRot"];

	if (abs (_up select 0) < 0.999999) then {
		_yRot = -asin (_up select 0);

		private _signCosY = if (cos _yRot < 0) then { -1 } else { 1 };

		_xRot = (_up select 1 * _signCosY) atan2 (_up select 2 * _signCosY);
		_zRot = (_dir select 0 * _signCosY) atan2 (_aside select 0 * _signCosY);
	} else {
		_zRot = 0;

		if (_up select 0 < 0) then {
			_yRot = 90;
			_xRot = (_aside select 1) atan2 (_aside select 2);
		} else {
			_yRot = -90;
			_xRot = (-(_aside select 1)) atan2 (-(_aside select 2));
		};
	};

	[_xRot, _yRot, _zRot];
};

private _createKillPosSimpleObjects = {
    private _h = _this select 0;

    private _blood = [
        "a3\Props_F_Orange\Humanitarian\Garbage\BloodPool_01_Large_F",
        "a3\Props_F_Orange\Humanitarian\Garbage\BloodPool_01_Medium_F",
        "a3\Props_F_Orange\Humanitarian\Garbage\BloodSplatter_01_Large_F",
        "a3\Props_F_Orange\Humanitarian\Garbage\BloodSplatter_01_Medium_F",
        "a3\Props_F_Orange\Humanitarian\Garbage\BloodSplatter_01_Small_F",
        "a3\Props_F_Orange\Humanitarian\Garbage\BloodTrail_01_F",
        "a3\Props_F_Orange\Humanitarian\Garbage\BloodSpray_01_F"
    ];

    private _explosions = [
    ];

    private _init = [];
    _init pushBack "private _blood = objNull;";
    
    private _posInCell = createHashMap;

    private _killPositions = _h get "kill_pos";
    {
        private _kph = createHashMapFromArray _x;
        
        private _pos = _kph get "pos";
        private _z = getTerrainHeightASL _pos;

        private _cellKey = format ["%1_%2", round ((_pos select 0) / 10.0), round ((_pos select 1) / 10.0)];
        private _zOffset = _posInCell getOrDefault [_cellKey, 0];
        _posInCell set [_cellKey, _zOffset + 1];

        _pos set [2, _z + _zOffset * 0.001];

        if (_kph get "man") then {
            private _model = selectRandom _blood;
            _init pushBack (format ["_blood = createSimpleObject ['%1', %2, true];", _model, _pos]);
            _init pushBack (format ["_blood setDir %1;", random 360]);
            _init pushBack (format ["_blood setVectorUp %1;", surfaceNormal _pos]);
        } else {
            // TODO
        };
    } forEach _killPositions;

    _init;
};

private _updateRootObject = {
    private _h = _this select 0;
    
    private _storage = [
        ["players", _h get "players"]
    ];
	
	private _init = [];
    private _initServerOnly = [];
    
    _init pushBack "[this] call ZDO_fnc_initRootObject;";

    if ("root_attrs" in _h) then {
        private _rootAttrs = _h get "root_attrs";
        {
            _initServerOnly pushBack (format [
                "this setVariable ['%1', %2, true];",
                _x select 0,
                str (_x select 1)
            ]);
        } forEach _rootAttrs;
    };

    _init pushBack (format ["missionNamespace setVariable ['%1', '%2'];", "zdo_storage", str _storage]);

    _init append ([_h] call _createKillPosSimpleObjects);
    
    _initServerOnly pushBack (format ["private _map = %1;", _h get "map"]);
    _initServerOnly pushBack "_map call ZDO_fnc_pasteMapMarkers;";    

    if (count _initServerOnly > 0) then {
        _initServerOnly insert [0, ["if (isServer) then {"], false];
        _initServerOnly pushBack "};";
        _init append _initServerOnly;
    };

    private _zdo_root = (("VR_3DSelector_01_default_F" allObjects 0) select { (_x get3DENAttribute "Name") isEqualTo ["zdo_root"] }) select 0;
    if (isNull _zdo_root) then {
        throw "Cannot find zdo_root";
    };
	_zdo_root set3DENAttribute ["Init", _init joinString endl];
};

_loadMines = {
    private _h = _this select 0;
	private _layer = _this select 1;
    
    private _mineClasses = createHashMap;
    
    {
        private _mineCfg = createHashMapFromArray _x;
        private _ammoT = _mineCfg get "type";
        private _posRot = _mineCfg get "pos";
        
        if (!(_ammoT in _mineClasses)) then {
            private _c = (format ["(getText (_x >> 'ammo') == '%1') && (getText (_x >> 'vehicleClass') == 'Mines')", _ammoT]) configClasses (configFile >> "CfgVehicles");
            private _t = "";
            if (count _c > 0) then {
                _t = configName (_c select 0);
            };
            _mineClasses set [_ammoT, _t];
        };
        
        private _mineType = _mineClasses get _ammoT;
        if (!(_mineType isEqualTo "")) then {
            private _o = create3DENEntity ["Object", _mineType, _posRot select 0, true];
            _o set3DENLayer _layer;
            
            _o set3DENAttribute ["rotation", [_posRot select 1, _posRot select 2] call _get3denRotation];
        };
    } forEach (_h get "mines");
};

params ["_arg"];
private _h = createHashMapFromArray (_this select 0);
private _layerRoot = -1 add3DENLayer (format ["Loaded %1", _h get "save_time"]);

private _layers = [
    ["ve", str (_layerRoot add3DENLayer "Vehicles")],
    ["bu", str (_layerRoot add3DENLayer "Buildings")],
    ["th", str (_layerRoot add3DENLayer "Things")],
    ["fl", str (_layerRoot add3DENLayer "Flags")]
];

private _objects = _h get "objects";
{
    [_x, _layers] call _loadObject;
} forEach _objects;

[_h] call _updateRootObject;

private _layerMines = _layerRoot add3DENLayer "Mines";
[_h, _layerMines] call _loadMines;

1;
