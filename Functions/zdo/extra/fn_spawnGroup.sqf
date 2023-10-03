/**
Server-only, scheduled.
Spawns a group with specified parameters like amount of units, which factions and categories of these factions to choose, etc.
 */

params [
	"_side",
	"_countMinMax", // [1, 10]
	"_position",

	// Format: [[side, [faction1, category1a, category1b], [faction2, category2a]], [anotherSide, [faction3, category3, category4]]]
	// Examples:
	// [[east, ["csat", "Infantry"], ["fia", "@motor"]]]
	// [[west, ["nato", "@inf"]], [east, ["csat", "@inf"], ["@fi", "@motor"]]]
	// This will randomly pick groups from "NATO - Infantry", "CSAT - Infantry" and "FIA - Motorized Infantry" and build up the group up to specified amount of units.
	// Faction and categories can be substrings if first character is "@";
	// Faction and categories are to be taken from 3den/Zeus compositions tab, not objects tab.
	"_config"
];

private _createConditionStr = {
	params ["_substr"];
	[
		"private _n = toLower getText (_x >> 'name');",
		if ((_substr find "@") >= 0) then {
			format ["[%1, _n] call BIS_fnc_inString;", str toLower (_substr select [1])];
		} else {
			format ["%1 isEqualTo _n;", str toLower _substr];
		}
	] joinString endl;
};

private _spawnGroups = [];

{
	private _configSide = _x select 0;
	private _factions = _x select [1];

	{
		private _factionSubstr = _x select 0;
		private _categorySubstrs = _x select [1];

		private _configFactionsCondition = [_factionSubstr] call _createConditionStr;
		private _configFactions = _configFactionsCondition configClasses (configFile >> "CfgGroups" >> str _configSide);

		{
			private _configFaction = _x;
			{
				private _configCategoriesCondition = [_x] call _createConditionStr;
				private _configCategories = _configCategoriesCondition configClasses _configFaction;

				{
					_spawnGroups append ("true" configClasses _x);
				} forEach _configCategories;
			} forEach _categorySubstrs;
		} forEach _configFactions;
	} forEach _factions;
} forEach _config;

["Requested spawn group, found %1", count _spawnGroups] call zdo_log_fnc_write;
if (count _spawnGroups == 0) exitWith {false};

private _allSizes = [];
private _sizeToSpawnGroups = createHashMap;
{
	private _size = count ("true" configClasses _x);
	private _key = str _size;
	private _l = _sizeToSpawnGroups getOrDefault [_key, []];
	_l pushBack _x;
	_sizeToSpawnGroups set [_key, _l];

	_allSizes pushBackUnique _size;
} forEach _spawnGroups;

_allSizes call BIS_fnc_sortNum;

private _count = _countMinMax call BIS_fnc_randomInt;
private _unitsLeft = _count;
private _unitsToSpawnFromLastGroup = 0;

private _groupsToSpawn = [];
while {_unitsLeft > 0} do {
	private _maxAvailableSize = 0;
	for "_i" from (count _allSizes - 1) to 0 step -1 do {
		private _size = _allSizes select _i;
		if ((_size < _unitsLeft) || (_i == 0)) then {
			_maxAvailableSize = _size;
			break;
		};
	};

	private _group = selectRandom (_sizeToSpawnGroups get str _maxAvailableSize);
	_groupsToSpawn pushBack _group;
	_unitsLeft = _unitsLeft - _maxAvailableSize;

	if (_unitsLeft < 0) then {
		_unitsToSpawnFromLastGroup = _maxAvailableSize + _unitsLeft;
	};
};

[_count, _allSizes, _groupsToSpawn apply { getText (_x >> 'name') }, _unitsLeft];

private _group = createGroup _side;

for "_i" from 0 to (count _groupsToSpawn - 1) do {
	private _groupToSpawn = _groupsToSpawn select _i;
	private _unitClasses = "true" configClasses _groupToSpawn apply { getText ( _x >> 'vehicle') };
	private _unitsToSpawn = count _unitClasses;
	private _isLastGroup = (_i == (count _groupsToSpawn - 1));
	if (_isLastGroup) then {
		_unitsToSpawn = _unitsToSpawnFromLastGroup;
	};

	private _classes = _unitClasses select [0, _unitsToSpawn];
	{
		private _type = _x;
		private _isMan = _type isKindOf "Man";

		private _unit = objNull;
		if (_isMan) then {
			_unit = _group createUnit [_type, [0, 0, 0], [], 0, "CAN_COLLIDE"];

			// Disable LAMBS temporarily. Otherwise AI becomes agitated from the very beginning.
			_unit setVariable ["lambs_danger_disableAI", true];

			_unit enableSimulationGlobal false;
			_unit hideObject true;
			_unit allowDamage false;

			[_unit] joinSilent _group;
		} else {
			_unit = createVehicle [_type, [0, 0, 0], [], 0, "CAN_COLLIDE"];

			_unit enableSimulationGlobal false;
			_unit hideObject true;
			_unit allowDamage false;

			_group createVehicleCrew _unit;
		};

		_unit setDir ([0, 360] call BIS_fnc_randomNum);

		if (_isMan) then {
			[_unit, _position] call zdo_pos_fnc_moveToEmptyPosition;
		} else {
			[_unit, _position] call zdo_pos_fnc_moveToEmptyPositionCloserToRoad;
		};

		// Sleeps are needed so vehicles do not collide.
		sleep 0.5;

		_unit enableSimulationGlobal true;
		_unit hideObject false;
		_unit allowDamage true;

		sleep 0.5;

		_unit setVariable ["lambs_danger_disableAI", false];
	} forEach _classes;
};

_group;
