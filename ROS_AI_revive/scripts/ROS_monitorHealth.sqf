/* ROS_AI_Revive system v4.0 - by RickOShay

LEGAL STUFF: You may use these scripts in your mission - full attribution must given on Steam Workshp submission and in your mission.
Likewise if you modify any / all of these scripts or use them in derivative work - attribution must be given in the Steam Workshop submission as well as in the new script and your mission.

USAGE:
This system works for all units on the player's side or in the player's group see scope below.
NOTE: ALL PLAYERS MUST BE ON THE SAME SIDE.
The leader of the group must be a player.
You must have some AI units on your side or in your group for it to work.
NB! Vanilla revive system must be enabled for SP and MP.

Ace is not explicitly supported but this script apparently does work with it.

INSTALLATION:
1. Copy the ROS_AI_revive folder to your mission root.
2. Add the sound classes to CFGSounds in your description.ext (See sample description.ext file in Example root files folder)
3. Put the following line in your init.sqf:
[] execvm "ROS_AI_revive\scripts\ROS_monitorhealth.sqf";
4. Create a text file in the mission root called: initserver.sqf Place the following code into that file:
   (This will stop AI respawning when killed)

{
	_x addMPEventHandler ["MPRespawn", {
		params ["_unit"];
		if (!isPlayer _unit) exitWith {
			deleteVehicle _unit
		}
	}]
} forEach playableUnits;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
// CONFIGURABLE OPTIONS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*

Select scope of the Revive system. NB: BIS revive must be Enabled in editor or description.ext (see sample description.ext for example)!
 1 = Player group including players
 2 = Entire Player side including players Note: ALL PLAYERS MUST BE ON THE SAME SIDE. FPS impact with large number of players and or simulated units.
 3 = Entire Player side excluding players FPS impact with large number of simulated units.*/

ROS_AIreviveScope = 2;

// Select how long an INCAPACITATED unit can survive in state before dying / or being reset. Max = 300.
ROS_maxIncapTime = 180; // 5 mins

// Should INCAPACITATED unit be auto revived after the above time elapses? true = autorecover false = die
ROS_autoRecover = false;

// Create smoke when reviving (simulates a smoke grenade between the incap unit and the nearest enemy to provide cover)
ROS_RevSmokeOn = false;

// Select smoke colour (lower case): "random","yellow","red","purple","orange","green","white"
ROS_RevSmokeCol = "white";

// Allow radio status messages
ROS_statusmsg = false;

// Allow AI medic to make audio comments during revive
ROS_allowComments = false;

// Allow moan sfx from incap unit
ROS_moaning = false;

// Captive blacklist - units to be excluded from the revive system - that are set captive for mission purposes (hostage, spy, undercover units etc)
// ie: ROS_captiveBL = [hostage1, spy1, sniper1];
ROS_captiveBL = [];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Don't change anything below this line //// Don't change anything below this line //// Don't change anything below this line /////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Debug testing
ROS_AIRevive_debug = false;

publicVariable "ROS_AIreviveScope";
ROS_incapacitated = [];
ROS_Processing = [];
publicVariable "ROS_Processing";
ROS_bloodPools = [];
ROS_medics = [];
ROS_medicDist = 1000;

// Stop AI radio chatter
//enableSentences false;

// Wait until players have joined the game
waitUntil {count (allPlayers - entities "HeadlessClient_F") >0};

// Addrating to players
_players = allPlayers - entities "HeadlessClient_F";
{if (local _x) then {_x addRating 20000}} foreach _players;

// Get player's side - the AI revive system will process units on this side
ROS_RevSide = independent;

// Sounds
moanP0 = ["P0_moan_01.wss","P0_moan_02.wss","P0_moan_03.wss","P0_moan_04.wss","P0_moan_05.wss","P0_moan_06.wss","P0_moan_07.wss","P0_moan_08.wss","P0_moan_09.wss","P0_moan_10.wss","P0_moan_11.wss","P0_moan_12.wss"];
moanP1 = ["P1_moan_01.wss","P1_moan_02.wss","P1_moan_03.wss","P1_moan_04.wss","P1_moan_05.wss","P1_moan_06.wss","P1_moan_07.wss","P1_moan_08.wss","P1_moan_09.wss","P1_moan_10.wss","P1_moan_11.wss","P1_moan_12.wss","P1_moan_13.wss","P1_moan_14.wss","P1_moan_15.wss","P1_moan_16.wss","P1_moan_17.wss","P1_moan_18.wss"];
moanP2 = ["P2_moan_01.wss","P2_moan_02.wss","P2_moan_03.wss","P2_moan_04.wss","P2_moan_05.wss","P2_moan_06.wss","P2_moan_07.wss","P2_moan_08.wss","P2_moan_09.wss","P2_moan_10.wss","P2_moan_11.wss","P2_moan_12.wss","P2_moan_13.wss"];
moanP3 = ["P3_moan_01.wss","P3_moan_02.wss","P3_moan_03.wss","P3_moan_04.wss","P3_moan_05.wss","P3_moan_06.wss","P3_moan_07.wss","P3_moan_08.wss","P3_moan_09.wss"];

moanwordsP0 = ["P0_moan_13_words.wss","P0_moan_14_words.wss","P0_moan_15_words.wss","P0_moan_16_words.wss","P0_moan_17_words.wss","P0_moan_18_words.wss","P0_moan_19_words.wss","P0_moan_20_words.wss"];
moanwordsP1 = ["P1_moan_19_words.wss","P1_moan_20_words.wss","P1_moan_21_words.wss","P1_moan_22_words.wss","P1_moan_24_words.wss","P1_moan_25_words.wss","P1_moan_26_words.wss","P1_moan_27_words.wss","P1_moan_28_words.wss","P1_moan_29_words.wss","P1_moan_30_words.wss","P1_moan_31_words.wss","P1_moan_32_words.wss","P1_moan_33_words.wss"];
moanwordsP2 = ["P2_moan_14_words.wss","P2_moan_15_words.wss","P2_moan_16_words.wss","P2_moan_19_words.wss","P2_moan_20_words.wss","P2_moan_21_words.wss"];
moanwordsP3 = ["P3_moan_10_words.wss","P3_moan_11_words.wss","P3_moan_12_words.wss","P3_moan_17_words.wss"];

// Medical Items
ROS_medicItems = ["Medikit","FirstAidKit","fak"];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Add handledamage EH, revive addaction and group leader var

if (isServer) then {

	ROS_ALLUnitsArray = [];
	publicVariable "ROS_ALLUnitsArray";

	ROS_Fnc_unitArrayEHupdate = {

		// Get All Units array from server

		// player group include players (default) 	* LOCAL TO EACH LEADER GROUP PLAYER
		if (ROS_AIreviveScope == 1) then {ROS_AllUnitsArray = allunits select {isplayer leader _x && simulationEnabled _x}};

		// player side include players 				* LOCAL TO LEADER GROUP PLAYER AND SERVER
		if (ROS_AIreviveScope == 2) then {ROS_AllUnitsArray = allunits select {(side _x == ROS_RevSide or side _x == civilian) && simulationEnabled _x}};

		// player side exclude players 				* LOCAL TO SERVER AND PLAYER (if player has group AI units)
		if (ROS_AIreviveScope == 3) then {ROS_AllUnitsArray = allunits select {(side _x == ROS_RevSide or side _x == civilian) && !(isPlayer _x) && simulationEnabled _x}};

		publicVariable "ROS_ALLUnitsArray";

		waitUntil {count ROS_ALLUnitsArray >0};

		// Add HDEH and addaction and Grp vars
		{
			// Has HDEH been added ?
			if !(_x getVariable ["HDEHadded",false]) then {

				// AI EH - SP && MP
				if (!isplayer _x) then {

					[_x, ["handleDamage", {
						params ["_unit", "_selection", "_damage"];
						if (_damage > 0.7 && isTouchingGround vehicle _unit) then {
							if !(lifestate _unit == "INCAPACITATED") then {
								[_unit] spawn {
									params ["_unit"];
									if (random 1 >0.98) then {
										_unit setdamage 1;
									} else {
										_unit setDamage 0.8;

										if (!isnull objectParent _unit) then {
											_veh = objectParent _unit;
											_pos = _unit getPos [(4 + random 3), (getdir _veh) + (60 + random 20)];
											sleep 3 + random 3;
											moveOut _unit;
											_unit setPosATL _pos
										};
										_unit setcaptive true;
										// _unit allowdamage false;
										_unit setUnconscious true;
										ROS_incapacitated pushBackUnique _unit;
										publicVariable "ROS_incapacitated";
										if (count units group _unit ==1) then {
											if (_unit getVariable ["ROS_OrigPos",[]] isEqualTo []) then {
												_pos = (getPosATL _unit);
												_dir = (getdir _unit);
												_unit setVariable ["ROS_OrigPos", _pos, true];
												_unit setVariable ["ROS_OrigDir", _dir, true];
											};
										};
									};
								};
							};
							_damage = 0.8;
						};
						_damage
					}]] remoteexec ["addeventhandler", _x];

					// Stop AI respawning when killed
					[_x, ["MPRespawn", {
						params ["_unit"];
						deleteVehicle _unit;
					}]] remoteexec ["addMPeventhandler", _x];

				}; // !isplayer

				// Player EH - SP
				if (isPlayer _x && !isMultiplayer) then {
					[_x, ["handledamage", {
						params ["_unit", "_selection", "_damage"];
						if (_damage > 0.7 && isTouchingGround vehicle _unit) then {
							if !(lifestate _unit == "INCAPACITATED") then {
								[_unit] spawn {
									params ["_unit"];
									_unit setDamage 0.8;

									if (!isnull objectParent _unit) then {
										_veh = objectParent _unit;
										_pos = _unit getPos [(4 + random 3), (getdir _veh) + (60 + random 20)];
										sleep 3 + random 3;
										moveOut _unit;
										_unit setPosATL _pos;
									};

									_unit setcaptive true;
									// _unit allowdamage false; // zdo
									_unit setUnconscious true;
									ROS_incapacitated pushBackUnique _unit;
									publicVariable "ROS_incapacitated";
								};
							};
							_damage = 0.8;
						};
						_damage
					}]] remoteexec ["addeventhandler", _x];
				}; // isplayer && !multiplayer

				// addaction - player revive AI - SP && MP
				if (isPlayer _x && !(_x getVariable ["ROS_RevActionAdded",false])) then {
					// Zdo addition: no need in REVIVE action, this is for AI only.
					//[_x, ["<t color='#FF8000'>REVIVE</t>",{params ["_target", "_caller", "_actionId"]; [_caller] execVM "ROS_AI_revive\scripts\ROS_PlayerReviveAI.sqf";},[],8,true,true,"","!isplayer cursorObject && _this distance cursorObject < 2.2 && lifeState cursorObject == 'INCAPACITATED' && animationstate _this find 'medic' ==-1"]] remoteexec ["addAction", _x];

					_x setVariable ["ROS_RevActionAdded",true,true];
				}; // player

				// Add initial group and reviveTL var to AllUnitsArray
				if ((_x getVariable ["Grp",""]) == "") then {
					_grp = group _x;
					_x setVariable ["Grp", _grp, true];
					_x setVariable ["reviveTimeLimit",0,true];
				};

				// Add assigned vehicle var to ALLUnitsArray
				if !(assignedvehicle _x isEqualTo (_x getVariable ["AssignedVeh", objNull])) then {
					_veh = assignedvehicle _x;
					_x setVariable ["AssignedVeh", _veh, true];
				};

				// HDEH and other vars etc have been added to unit
				_x setVariable ["HDEHadded",true,true];

				sleep 0.5;

			}; // end (_x getVariable ["HDEHadded",false]

		} foreach ROS_ALLUnitsArray;

		ROS_AllUnitsArray

	}; // end ROS_Fnc_unitArrayEHupdate

	// Update ALLUNITS array
	[] call ROS_Fnc_unitArrayEHupdate; // returns ROS_AllUnitsArray ~0.05s

}; // end isserver

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////// FUNCTIONS ////////////// FUNCTIONS ////////////// FUNCTIONS ////////////// FUNCTIONS //////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Medic comments
ROS_Fnc_medicLines = {
	params ["_incap", "_medic"];
	if (ROS_allowComments && isplayer _incap) then {
		_sndsArray = ["medic1", "medic2", "medic3", "medic4", "medic5"];
		if (lifeState _incap == "INCAPACITATED") then {
			sleep 2;
			_medicsnd = selectRandom _sndsArray;
			_medic setRandomLip true;
			[_incap, [_medicsnd, 50, 1, true]] remoteExec ["say3D", 0];
			sleep 5;
			_medic setRandomLip false;
		};
	};
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Revived unit thanks medic
ROS_Fnc_medicThanks = {
	params ["_incap", "_medic"];
	if (ROS_allowComments) then {
		if (alive _incap) then {
			if (isplayer _incap) then {
				_incapSndsArray = ["thanks1", "thanks2", "thanks3", "thanks4", "thanks5", "thanks6", "thanks7", "thanks8"];
				_incapSndsArray = _incapSndsArray call BIS_fnc_arrayShuffle;
				sleep 2;
				_incapSnd = selectRandom _incapSndsArray;
				_incap setRandomLip true;
				[_incap, [_incapSnd, 50, 1, true]] remoteExec ["say3D", 0];
				sleep 5;
				_incap setRandomLip false;
			} else {
				// if a player is nearby then medic speaks and AI thanks medic
				_nearestPlayer = (_incap nearEntities ["man", 20]) select {isplayer _x};
				if !(_nearestPlayer isEqualTo []) then {
					_medicSndsArray = ["thanks1AI", "thanks2AI", "thanks3AI", "thanks4AI", "thanks5AI", "thanks6AI", "thanks7AI", "thanks8AI"];
					_medicSndsArray = _medicSndsArray call BIS_fnc_arrayShuffle;
					_incapSndsArray = ["thanks1", "thanks2", "thanks3", "thanks4", "thanks5", "thanks6", "thanks7", "thanks8"];
					_incapSndsArray = _incapSndsArray call BIS_fnc_arrayShuffle;
					_incapSnd = selectRandom _incapSndsArray;
					sleep 2;
					_medicSnd = selectRandom _medicSndsArray;
					_medic setRandomLip true;
					[_medic, [_medicSnd, 50, 1, true]] remoteExec ["say3D", 0];
					sleep 2;
					_medic setRandomLip false;
					[_incap, [_incapSnd, 50, 1, true]] remoteExec ["say3D", 0];
					_incap setRandomLip true;
					sleep 2;
					_incap setRandomLip false;
				};
			};
		};
	};
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Call for medic - with same voice until revived
ROS_Fnc_groanWords = {
	params ["_incap", "_medic"];
	_sndFullPathW = "";

	_indx = _incap getVariable ["mWordIndx", (round random 3)];

	_sndPathW = ["A3\sounds_f\characters\human-sfx\Person0\","A3\sounds_f\characters\human-sfx\Person1\","A3\sounds_f\characters\human-sfx\Person2\","A3\sounds_f\characters\human-sfx\Person3\"] select _indx;
	_moanWordArray = [moanwordsP0, moanwordsP1, moanwordsP2, moanwordsP3] select _indx;
	_moanWord = (selectRandom _moanWordArray);
	while {lifeState _incap == "INCAPACITATED"} do {
		if (_medic distance _incap > 3) then {
			playSound3D [(_sndPathW + _moanWord), _incap, false, (getPosASL _incap), 5, 1, 30];
			_incap setRandomLip true;
			sleep 3;
			_incap setRandomLip false;
			sleep 20 + random 10;
		};

		sleep 1;
	};
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Moan sounds
ROS_Fnc_groan = {
	params ["_incap", "_medic"];
	_sndFullPathM = "";

	if (isnil "ROS_lastMoanIndx") then {
		ROS_lastMoanIndx = 0;
	} else {
		if (ROS_lastMoanIndx +1 >3) then {
			ROS_lastMoanIndx = 0;
		} else {
			ROS_lastMoanIndx = ROS_lastMoanIndx +1;
		};
	};

	_sndPathM = ["A3\sounds_f\characters\human-sfx\Person0\","A3\sounds_f\characters\human-sfx\Person1\","A3\sounds_f\characters\human-sfx\Person2\","A3\sounds_f\characters\human-sfx\Person3\"] select ROS_lastMoanIndx;
	_moanSndArray = [moanP0, moanP1, moanP2, moanP3] select ROS_lastMoanIndx;
	_moanSnd =  selectRandom _moanSndArray;
	while {lifeState _incap == "INCAPACITATED"} do {
		if (_medic distance _incap < 5) then {
			playSound3D [(_sndPathM + _moanSnd), _incap, false, (getPosASL _incap), 5, 1, 30];
			sleep 10 + random 5;
		};
		sleep 2;
	};
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Medical waste
ROS_Fnc_medwaste = {
	params ["_unit"];
	_medobjs = ["Land_BloodBag_F","MedicalGarbage_01_Bandage_F","MedicalGarbage_01_FirstAidKit_F","MedicalGarbage_01_Injector_F","MedicalGarbage_01_Bandage_F","MedicalGarbage_01_Bandage_F","Land_BloodBag_F","MedicalGarbage_01_Bandage_F"];
	_mpos1 = _unit modelToWorld [1.1,1.3,0];
	_mpos2 = _unit modelToWorld [-0.7,1.2,0];
	_mpos3 = _unit modelToWorld [-1,1.3,0];
	_med1 = selectRandom _medobjs;
	_med2 = selectRandom _medobjs;
	_med3 = selectRandom _medobjs;
	sleep 3.5;
	_medwaste1 = _med1 createVehicle [0,0,0];
	_medwaste1 setdir (random 360);
	_medwaste1 setPosATL [_mpos1 select 0,_mpos1 select 1,0];
	_medwaste1 setVectorUp surfaceNormal position _medwaste1;
	_medwaste1 enableSimulationGlobal false;
	sleep 1;
	_medwaste2 = _med2 createVehicle [0,0,0];
	_medwaste2 setdir (random 360);
	_medwaste2 setPosATL [_mpos3 select 0,_mpos3 select 1,0];
	_medwaste2 setVectorUp surfaceNormal position _medwaste2;
	_medwaste2 enableSimulationGlobal false;
	sleep 1;
	_medwaste3 = _med3 createVehicle [0,0,0];
	_medwaste3 setdir (random 360);
	_medwaste3 setPosATL [_mpos3 select 0,_mpos3 select 1,0];
	_medwaste3 setVectorUp surfaceNormal position _medwaste3;
	_medwaste3 enableSimulationGlobal false;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Bloodpools - local
ROS_Fnc_blood = {
	params ["_medic", "_incap"];
	ROS_bloodPools = [];
	_bloodTypes = ["BloodPool_01_Large_New_F","BloodSplatter_01_Large_New_F"];
	_nearestBlood = (position _incap nearObjects 0.8) select {(typeof _x) in _bloodTypes};

	if (count _nearestBlood ==0) then {
		_bpos = getposatl _incap;
		_pool = selectRandom _bloodTypes;
		_blood = createSimpleObject [_pool, [0,0,0], true];
		_blood setdir (getdir _incap);
		_blood setPosATL _bpos;
		_blood setobjectscale 0.3;
		_blood setVectorUp surfaceNormal position _blood;
		_blood enableSimulationGlobal false;
		_blood disableCollisionWith _incap;
		_blood disableCollisionWith _medic;
		_incap setPosATL _bpos;
		ROS_bloodPools pushBackUnique _blood;
		// Force animation state (occasionally incap unit anim doesn't transition to unonscious default)
		if (lifestate _incap == "INCAPACITATED" && animationState _incap find "unconsciousrevivedefault" < 0) then {
			[_incap,"unconsciousrevivedefault"] remoteExec ["switchmove", 0];
			waitUntil {(!alive _incap or !(lifeState _incap == "INCAPACITATED"))};
		};
		// upscale blood pool
		[_incap, _blood] spawn {
			params ["_incap", "_blood"];
			while {lifeState _incap == "INCAPACITATED" && (getObjectScale _blood)<1.2} do {
				_blood setobjectscale ((getObjectScale _blood)+0.002);
				sleep 0.07;
			};
		};
	};
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Smoke grenade sim
ROS_Fnc_RevSmoke = {
	params ["_incap", "_medic", "_multiplier"];
	_reldir = 0;
	_relpos = [];
	_col = "";
	_idx = 0;
	_ttl = 0;
	_smokeSpawnDist = 10;
	_nearEnemy = [_medic] call ROS_Fnc_NearEnemy;

	if (getPosATL _incap select 2 <1) then {
		if (!isNull _nearEnemy && alive _nearEnemy && _nearEnemy isKindOf "CAManbase") then {
				_reldir = _incap getdir _nearEnemy;
		} else {
			_reldir = _incap getdir _medic;
		};
		_relpos = _incap getPos [_smokeSpawnDist, _reldir];
		// Smoke colour
		_colors= ["yellow","red","purple","orange","green","white"];
		_colRGB = [[1,1,0],[0.3,0.01,0],[0.2,0.1,1],[1,0.25,0],[0.05,0.3,0.01],[1,1,1]];
		if (ROS_RevSmokeCol == "random") then {
			_col = selectRandom _colors;
		} else {
			_col = ROS_RevSmokeCol;
		};
		_idx = _colors find _col;
		_colArray = _colRGB select _idx;
		_ttl = (9 * _multiplier);
		[_relpos, _colArray, _ttl] execvm "ROS_AI_revive\scripts\ROS_smokeRev.sqf";
	};
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Get nearest Enemy < 300m
ROS_Fnc_NearEnemy = {
	params ["_unit"];

	_nearEnemies = [];
	_nearEnemy = objNull;

	_enemySides = (ROS_RevSide call BIS_fnc_enemySides);
	_enemyUnits = allunits select {side _x in _enemySides};
	_nearEnemies = _enemyUnits select {_x distance _unit <500 && simulationEnabled _x};
	if (count _nearEnemies >0) then {
		// Not nearest but ok for purpose
		_nearEnemy = _nearEnemies select 0;
	} else {
		_nearEnemy = objNull;
	};
	_nearEnemy
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Adjust Rank capitalization
ROS_Fnc_rank_Capitalization = {
	params ["_unitRank"];
	_new1stChar = "";
	_lowerTxt = "";

	_lowerTxt = (toLower _unitRank);
	_new1stChar = toupper (_lowerTxt select [0, 1]);
	_minus1stChar = [_lowerTxt,1] call BIS_fnc_trimString;
	_newRank = _new1stChar + _minus1stChar;

	_newRank
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Remove debug markers
ROS_Fnc_delYmarkers = {
	params ["_unit"];
	_ymrkrs = nearestObjects [_unit,["Sign_Arrow_Yellow_F"], 6];
	{deleteVehicle _x} foreach _ymrkrs;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Reenable AI features of medic
ROS_Fnc_resetAI = {
	params ["_unit"];
	_unit enableAI "TARGET";
	_unit enableAI "AUTOTARGET";
	_unit enableAI "AUTOCOMBAT";
	_unit enableAI "SUPPRESSION";
	_unit enableAI "ANIM";
	_unit enableAI "MOVE";
	//_grp = (_unit getVariable ["Grp", (group _unit)]);
	//[_unit] joinsilent (leader _grp);
	_unit doWatch objNull;
	if (_unit in ROS_Processing) then {_unit dofollow leader (group _unit)};
	ROS_Processing = ROS_Processing - [_unit];
	publicVariable "ROS_Processing";
	_unit setvariable ["reviveTimeLimit",0,true];
};

ROS_Fnc_AI_healSelf = {
	params ["_unit"];

	if (lifeState _unit == "INCAPACITATED" or !alive _unit or damage _unit <0.1 or !(isnull (objectParent _unit))) exitWith {};
	sleep (random 5);
	_grp = _unit getVariable ["Grp",objNull];
	if (alive _unit) then {
		// Get Nearest Enemy to Incap unit
		_nearEnemy = [_unit] call ROS_Fnc_NearEnemy;
		if (isnull _nearEnemy or _unit distance _nearEnemy >100) then {
			[_unit,"AinvPknlMstpSlayWrflDnon_medic"] remoteExec ["playMoveNow", _unit];
			sleep 6;
		} else {
			[_unit,"ainvppnemstpslaywrfldnon_medic"] remoteExec ["playMoveNow",_unit];
			sleep 7;
		};
		_unit setdamage 0;
		if (_unit != leader _grp && count units group _unit >1) then {
			[_unit] joinSilent (leader _grp);
			_unit doFollow (leader _grp);
		};
		sleep 3;
	};
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Update INCAPACITATED and medics array
ROS_Fnc_UpdateIncapAndMedics = {

	// Add players to incap array
	{if (isPlayer _x && lifeState _x == "INCAPACITATED" && !(_x in ROS_incapacitated)) then {ROS_incapacitated = ROS_incapacitated + [_x]}} foreach ROS_AllUnitsArray;

	// Set and Clear Incap state
	if (count (ROS_AllUnitsArray select {alive _x}) >0) then {
		{

			if !(lifeState _x == "INCAPACITATED") then {ROS_incapacitated = ROS_incapacitated - [_x];};

			if ((_x getVariable ["incapTimeLimit",0])>0) then {
				// Time up
				if (time > (_x getVariable "incapTimeLimit") && lifeState _x == "INCAPACITATED") then {
					// Unit dies
					if !(ROS_autoRecover) then {
						_x setDamage 1;
						_rankI = [(rank _x)] call ROS_Fnc_rank_Capitalization;
						if (ROS_statusmsg or ROS_AIRevive_debug) then {[format ["%1 %2\nunfortunately\ndied from his injuries", _rankI, name _x]] remoteExec ["hintSilent",allPlayers]};
					} else {
						// Unit auto recovers
						_x setDamage 0;
						[['#rev',1, _x],BIS_fnc_reviveOnState] remoteExec ['call', _x];
						[_x, false] remoteExec ["setUnconscious", _x];
						_x addItemToBackpack "Medikit";
						_x setVariable ["reviveTimeLimit", 0, true];
						_x setVariable ["incapTimeLimit", 0, true];
						_rankI = [(rank _x)] call ROS_Fnc_rank_Capitalization;
						if (ROS_statusmsg or ROS_AIRevive_debug) then {[format ["%1 %2\nRecovered from his injuries", _rankI, name _x]] remoteExec ["hintSilent",allPlayers]};
						_x dofollow leader (group _x);
					};
					ROS_Processing = ROS_Processing - [_x];
					publicVariable "ROS_Processing";
					// Remove nearest yellow markers if debug
					if (ROS_AIRevive_debug) then {_x call ROS_Fnc_delYmarkers};
				};
			} else {
				// Stamp incap with death/autorevive time
				if (_x getVariable ["incapTimeLimit",0] ==0) then {_x setVariable ["incapTimeLimit", (time + ROS_maxIncapTime), true]};
			};

		} foreach ROS_incapacitated;
	};

	// Remove captive and allowdamage states
	{
		if (captive _x && !(_x in ROS_captiveBL) && !(lifeState _x == "INCAPACITATED") && !(_x in ROS_Processing)) then {[_x,false] remoteExec ["setCaptive",_x]};
		//if (!(isDamageAllowed _x) && !(_x in ROS_Processing) && !(lifeState _x == "INCAPACITATED")) then {[_x,true] remoteExec ["allowDamage",_x]};
		if (time > (_x getvariable "reviveTimeLimit")) then {
			_x call ROS_Fnc_resetAI;
		};
	} foreach ROS_AllUnitsArray;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Recycle or recovery or death FUNC
ROS_Fnc_Recycle_Fnc = {
	params ["_medic", "_incap"];

	if (ROS_AIRevive_debug) then {[format ["Incap: %1\nMedic: %2", _incap, _medic]] remoteExec ["hintsilent", allPlayers]};

	while {alive _incap && alive _medic && lifestate _incap == "INCAPACITATED"} do {

		// Add some ammo to medic
		if (_medic ammo primaryWeapon _medic <30) then {_medic setammo [primaryWeapon _medic, 100]};

		// check time limit
		_reviveTime = (_incap getVariable ["reviveTimeLimit",0]);
		_incapTL = (_incap getVariable "incapTimeLimit");

		// Medic taking too long to get to Incap -> reset Medic
		if (_reviveTime > 0 && time > _reviveTime) then {
			// RESET Incap and Medic
			_medic call ROS_Fnc_resetAI;
			//[_medic,true] remoteExec ["allowDamage",_medic];
			[_medic,false] remoteExec ["setCaptive",_medic];
			_incap setVariable ["reviveTimeLimit", 0, true];
			ROS_Processing = ROS_Processing - [_incap];
			publicVariable "ROS_Processing";
			if (ROS_AIRevive_debug) then {
				["Medic reset\nTaking too long"] remoteExec ["hintsilent", allPlayers];
				_incap call ROS_Fnc_delYmarkers;
			};
		}; // end time > _reviveTimeLimit

		// Incap unit has been INCAPACITATED too long

		// Incap auto recovers
		if (ROS_autoRecover && _incapTL > 0 && time > _incapTL) then {
			ROS_Processing = ROS_Processing - [_incap, _medic];
			publicVariable "ROS_Processing";
			_incap setVariable ["ROS_IncapMarker","",true];
			_incap setVariable ["reviveTimeLimit", 0, true];
			//[_incap,true] remoteExec ["allowDamage",_incap];
			[_incap,false] remoteExec ["setCaptive",_incap];
			_medic call ROS_Fnc_resetAI;
			//[_medic,true] remoteExec ["allowDamage",_medic];
			[_medic,false] remoteExec ["setCaptive",_medic];
			if (ROS_AIRevive_debug) then {
				["Medic reset\nIncap Autorecovers"] remoteExec ["hintsilent", allPlayers];
				_incap call ROS_Fnc_delYmarkers;
			};
		};
		// Incap Dies
		if (!ROS_autoRecover && _incapTL > 0 && time > _incapTL) then {
			ROS_Processing = ROS_Processing - [_incap, _medic];
			publicVariable "ROS_Processing";
			_medic call ROS_Fnc_resetAI;
			//[_medic,true] remoteExec ["allowDamage",_medic];
			[_medic,false] remoteExec ["setCaptive",_medic];
			if (ROS_AIRevive_debug) then {
				["Medic reset\nIncap TL exceeded\nIncap Died"] remoteExec ["hintsilent", allPlayers];
				_incap call ROS_Fnc_delYmarkers;
			};
		}; // end auto Recover or die

		sleep 1;
	}; // end while
}; // END Fnc spawn recovery, recycle or death func


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// AI REVIVE FUNCTION // AI REVIVE FUNCTION // AI REVIVE FUNCTION // AI REVIVE FUNCTION // AI REVIVE FUNCTION // AI REVIVE FUNCTION //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ROS_Fnc_AIReviveUnits = {
	params ["_medic", "_incap"];

	// Debug send message to player leader - _grp is medic grp
	if (ROS_AIRevive_debug) then {[format ["Incap: %1\nMedic: %2", _incap, _medic]] remoteExec ["hintsilent", allPlayers]; sleep 5;};

	// Exit if missing unit in pair
	if (isNil "_medic" or isnil "_incap") exitWith {
		if (alive _incap) then {
			if (ROS_AIRevive_debug) then {["Incap exists and Medic isnil"] remoteExec ["hintsilent", allPlayers]};
			ROS_Processing = ROS_Processing - [_incap];
			publicVariable "ROS_Processing";
		};
		if (alive _medic) then {
			_medic call ROS_Fnc_resetAI;
			//[_medic,true] remoteExec ["allowDamage",_medic];
			[_medic,false] remoteExec ["setCaptive",_medic];
			ROS_Processing = ROS_Processing - [_incap];
			publicVariable "ROS_Processing";
		};
		if (ROS_AIRevive_debug) then {["Medic reset > EXIT"] remoteExec ["hintsilent", allPlayers]};
		// Leave incap damage and captive state as is
		sleep 3;
	};

	_nearEnemy = objNull;
	_ismedic = false;
	_hasmediKit = false;
	_multiplier = 1.5;
	_ymarker1 = objNull;

	// Disable damage and setcaptive
	//[_medic,false] remoteExec ["allowDamage",_medic];
	[_medic,true] remoteExec ["setCaptive",_medic];

	// Unassign player group vehicle (if assigned) so new effective commander doesnt inherit assigned vehicle and order AI to get in
	if (isPlayer _incap) then {
		{
			_veh = _x getVariable ["assignedveh", objnull];
			if (!isNull _veh) then {
				unassignVehicle _x;
			};
	 	} forEach units group _incap;
	};

	// Medics original group check
	_grp = (_medic getVariable ["Grp", (group _medic)]);
	if (_grp isEqualTo grpnull) then {_grp = group _medic};

	// Used for revive loop time calc Debug
	private _reviveTime = time;

	// Check Medic can run
	_medic call ROS_Fnc_AI_healSelf;

	// If animation state still not switched -> force
	if (lifestate _incap == "INCAPACITATED" && animationState _incap find "unconsciousrevivedefault" ==-1) then {
		[_incap,"unconsciousrevivedefault"] remoteExec ["switchmove", 0];
	};

	// Medic speed multiplier
	if (_medic getUnitTrait "Medic") then {_ismedic = true;};
	if ("Medikit" in (items _medic)) then {_hasmediKit = true;};
	if (_ismedic && !_hasmediKit) then {_multiplier = 1.5};
	if (_ismedic && _hasmediKit) then {_multiplier = 2};

	// Adjust skill and stop fleeing
	_medic setSkill ["COURAGE", 1];
	_medic allowFleeing 0;
	_medic disableAI "AUTOTARGET";
	_medic disableAI "AUTOCOMBAT";
	_medic disableAI "SUPPRESSION";
	_medic disableAI "TARGET";

	// Add some blood, medic speech, and remove collision
	if (alive _incap && alive _medic) then {
		if (ROS_moaning && isPlayer _medic) then {[_incap, _medic] spawn ROS_Fnc_groanWords};
		[_medic, _incap] remoteExecCall ["disableCollisionWith", 0, _medic];
		sleep 1;
		[[_medic, _incap], ROS_Fnc_blood] remoteExec ["spawn", 0, true];
	};

	// MOVE TO REVIVE //

	_revPos = [];
	_dir = 0;

	// Select/add primary weapon to medic - to allow for revive anim transition on unarmed player side / civ units
	if (alive _medic && primaryWeapon _medic == "") then {_medic addWeapon "arifle_MX_F"};
	if (alive _medic && currentWeapon _medic != (primaryWeapon _medic)) then {_medic selectWeapon (primaryWeapon _medic)};

	// Prone revive positions
	_posp1 = _incap modelToWorld [0,-1.8,0];
	_posp2 = _incap modelToWorld [-1.1,-1.1,0];
	_posp3 = _incap modelToWorld [1.1,-1.1,0];
	_posp4 = _incap modelToWorld [0,1.8,0];
	_posp5 = _incap modelToWorld [-1.1,1.1,0];
	_posp6 = _incap modelToWorld [1.1,1.1,0];
	_posp7 = _incap modelToWorld [-1.6,0,0];
	_posp8 = _incap modelToWorld [1.6,0,0];
	_posp = [_posp1, _posp2, _posp3, _posp4, _posp5, _posp6, _posp7, _posp8];

	// Kneel revive positions
	_posk1 = _incap modelToWorld [0,-1.9,0];
	_posk2 = _incap modelToWorld [-0.9,-0.9,0];
	_posk3 = _incap modelToWorld [0.9,-0.9,0];
	_posk4 = _incap modelToWorld [0,1.9,0];
	_posk5 = _incap modelToWorld [-0.9,0.9,0];
	_posk6 = _incap modelToWorld [0.9,0.9,0];
	_posk7 = _incap modelToWorld [-1.1,0,0];
	_posk8 = _incap modelToWorld [1.1,0,0];
	_posk = [_posk1, _posk2, _posk3, _posk4, _posk5, _posk6, _posk7, _posk8];

	// Get Nearest Enemy to Incap unit
	_nearEnemy = [_medic] call ROS_Fnc_NearEnemy;

	// Use prone or kneel revive anim
	if (!isnull _nearEnemy) then {
		_revPos = [_posp, _medic] call BIS_fnc_nearestPosition;
	} else {
		_revPos = [_posk, _medic] call BIS_fnc_nearestPosition;
	};

	// Zero height
	_revPos set [2,0];

	// yellow marker if debug is on
	if (ROS_AIRevive_debug) then {_ymarker1 = createVehicle ["Sign_Arrow_Yellow_F", _revPos,[],0,"can_collide"];};

	if (alive _medic && alive _incap && (lifestate _incap == "incapacitated")) then {
		_wp0 = [];
		// Stop medic using binoculars (dowatch)
		[_medic, (binocular _medic)] remoteExec ["removeWeapon", _medic];

		[_incap, _medic] remoteExecCall ["disableCollisionWith", 0, _incap];

		// Move - wps dont work in some buildings/positions
		_medic domove _revPos;

		// Move to pos (use domove and wp - useful for some buildings/areas)
		if (_medic distance2D _incap >5) then {
			for "_i" from 0 to (count waypoints _grp - 1) do {deleteWaypoint [_grp, 0]};
			_medic setSpeedMode "NORMAL";
			_wp0 = (group _medic) addWaypoint [_revPos, 0];
			_wp0 setWaypointSpeed "NORMAL";
			_wp0 setWaypointType "MOVE";
		} else {
			_medic setSpeedMode "LIMITED";
		};

		if (!(_wp0 isEqualTo []) && _medic distance2D _revPos <=8) then {_wp0 setWaypointSpeed "LIMITED"};

		waitUntil {
			//_medic domove _revPos;
			sleep 1;
			(_medic distance2D _incap <=5.5 or !alive _medic or !alive _incap)
		};

		_medic setSpeedMode "LIMITED";

		waitUntil {
			//_medic domove _revPos;
			sleep 0.7;
			(_medic distance2D _revPos <=3 or !alive _medic or !alive _incap)
		};

		_medic setdir (_medic getDir _revPos);

		// Update nearest revpos - force AI to move to revpos (slight negative - medic may occasionally glitch through a nearby obj)
		_animM = "";
		_animS = "";
		_dist = _medic distance _revPos;
		_esttime = _dist/0.5;
		_timer = time;
		_maxD = _revPos distance _incap;

		// crawl
		if (!isnull _nearEnemy) then {
			_revPos = [_posp, _medic] call BIS_fnc_nearestPosition;
			_animM = "amovppnemsprslowwrfldf";
			_animS = "amovppnemstpsraswrfldnon";
			_esttime = _dist/0.65;
		} else {
		// crouch
			_revPos = [_posk, _medic] call BIS_fnc_nearestPosition;
			_animM = "amovpknlmwlkslowwrfldf"; //"amovpknlmwlkslowwrfldf"; "amovpknlmrunslowwrfldf" "amovpercmrunsraswrfldf"
			_animS = "amovpknlmstpslowwrfldnon";
			_esttime = _dist/0.55;
		};

		_medic disableAI "ANIM";
		_medic playMoveNow _animM;
		_medic setdir (_medic getDir _incap);

		waitUntil {
			_medic doWatch _revPos;
			(_medic distance2D _revPos <=0.15) or (_medic distance2D _incap <=1) or time > (_timer + _esttime) or (!alive _medic) or (!alive _incap)
		};

		_medic playMoveNow _animS;
		if (_medic distance2d _incap >1.8) then {_medic setPosATL _revPos};
		_inview = [position _medic, getDir _medic, 30, position _incap] call BIS_fnc_inAngleSector;
		if (!_inview) then {_medic setdir (_medic getDir _revPos)};
		_medic doWatch _incap;

	};// end (alive _medic && (lifestate _incap == "incapacitated")

	// Medic animation and revive //
	if (alive _incap && alive _medic && lifestate _incap == "INCAPACITATED") then {

		// Add smoke
		if (ROS_RevSmokeOn) then {[_incap, _medic, _multiplier] spawn ROS_Fnc_RevSmoke};

		// Groaning sounds
		if (ROS_moaning) then {[_incap, _medic] spawn ROS_Fnc_groan};

		// Medic speaks
		[_incap, _medic] spawn ROS_Fnc_medicLines;

		// Add some medical waste
		[_medic] spawn ROS_Fnc_medwaste;
		_medic dowatch _incap;
		if (_medic distance _revpos >0.15) then {_medic setPosATL _revPos};

		if (isPlayer (leader _incap)) then {
			_rankI = [(rank _incap)] call ROS_Fnc_rank_Capitalization;
			_rankM = [(rank _medic)] call ROS_Fnc_rank_Capitalization;
			if (ROS_statusmsg or ROS_AIRevive_debug) then {[format ["%1 %2\n- reviving -\n%3 %4", _rankM, name _medic, _rankI, name _incap]] remoteExec ["hintsilent", allPlayers]};
		};

		_medic setdir (_medic getDir _revpos);
		// Kneeling revive - no near enemy
		if (lifestate _incap == "INCAPACITATED" && isNull _nearEnemy) then {
			_medic setdir (_medic getDir _incap)+5;
			[_medic, "AinvPknlMstpSnonWnonDnon_medic4"] remoteExec ["playMove", _medic];
			[_medic, _incap] spawn {
				params ["_medic", "_incap"];
				_medic setdir (_medic getDir _incap)+10;
			};
			sleep 12;
		};
		// Lying down revive - near enemy
		if (lifestate _incap == "INCAPACITATED" && !isNull _nearEnemy) then {
			[_medic, (_medic getDir _incap)+5] remoteExec ["setdir", _medic];
			[_medic, "ainvppnemstpslaywrfldnon_medicother"] remoteExec ["playMoveNow", _medic];
			[_medic, _incap] spawn {
				params ["_medic", "_incap"];
				_medic setdir (_medic getDir _incap)+10;
			};
			sleep 7;
		};

		// Remove damage and wake up //

		// Zdo addition.
		private _jsonStr = _incap call ace_medical_fnc_serializeState;
		private _json = [_jsonStr] call CBA_fnc_parseJSON;

		private _wounds = _json getVariable "ace_medical_openwounds";
		_json setVariable ["ace_medical_openwounds", _wounds apply {
			_x params ["_class", "_bodyPartIndex", "_amountOf", "_bleeding", "_damage"];
			[_class, _bodyPartIndex, _amountOf, 0, _damage];
		}];
		_json setVariable ["ace_medical_bloodvolume", [
			4 max (_json getVariable "ace_medical_bloodvolume"),
			6
		] call BIS_fnc_randomNum];
		_json setVariable ["ace_medical_bloodpressure", [
			[70, 80] call BIS_fnc_randomInt,
			[110, 120] call BIS_fnc_randomInt
		]];
		_json setVariable ["ace_medical_heartrate", [70, 120] call BIS_fnc_randomInt];
		_json setVariable ["ace_medical_statemachinestate", "Injured"];

		private _newJsonStr = [_json] call CBA_fnc_encodeJSON;
		_json call CBA_fnc_deleteNamespace;
		[_incap, _newJsonStr] call ace_medical_fnc_deserializeState;

		// Incap sometimes says thanks
		if (ROS_allowComments && random 1 <0.5) then {[_incap, _medic] spawn ROS_Fnc_medicThanks};

		// Reset health state and zero damage
		[_incap, false] remoteExec ["setUnconscious",_incap];
		_incap setdamage 0;

		if (isplayer _incap) then {
			[['#rev',1, _incap],BIS_fnc_reviveOnState] remoteExec ['call', _incap];
			// if player has no weapon he will stay in incapacitated anim - roll over anim requires a weapon
			if (count weapons _incap ==0) then {_incap addWeapon "hgun_Pistol_heavy_01_F";};
			// Fadein Radio
			[3, 1] remoteExec ["fadeRadio", _incap];
		};

		// Send revived success message to all players
		if (alive _incap && (isPlayer (leader _incap))) then {
			_rankI = [(rank _incap)] call ROS_Fnc_rank_Capitalization;
			_rankM = [(rank _medic)] call ROS_Fnc_rank_Capitalization;
			if (ROS_statusmsg or ROS_AIRevive_debug) then {[format ["%1 %2\n - REVIVED - \n%3 %4", _rankM, name _medic, _rankI, name _incap]] remoteExec ["hintsilent", allPlayers]};
		};

	}; // END if alive medic and incap unit and lifestate incap == "incapacitated"

	// REVIVE COMPLETED //

	// Remove medic and incap from Processing array
	ROS_Processing = ROS_Processing - [_medic, _incap];
	publicVariable "ROS_Processing";

	// Remove wps for medic
	for "_i" from 0 to (count waypoints _grp - 1) do {deleteWaypoint [_grp, 0]};

	// Enable collision
	[_incap, _medic] remoteExecCall ["enableCollisionWith", 0, _incap];

	// Enable AI features
	_medic call ROS_Fnc_resetAI;
	[_medic] joinSilent (leader _grp);
	//[_medic,true] remoteExec ["allowDamage",_medic];
	[_medic,false] remoteExec ["setCaptive",_medic];

	//[_incap,true] remoteExec ["allowDamage",_incap];
	[_incap,false] remoteExec ["setCaptive",_incap];
	if (ROS_AIRevive_debug) then {["Medic reset\nRevive completed"] remoteExec ["hintsilent", allPlayers]};

	// Reset dowatch
	[_medic, objNull] remoteExec ["doWatch",_medic];

	// Delete Incap marker
	if !(_incap getVariable ["ROS_IncapMarker",""] == "") then {
		deleteMarker (_incap getVariable "ROS_IncapMarker");
		_incap setVariable ["ROS_IncapMarker","",true];
	};

	// Debug get total revive time and remove debug path marker
	if (ROS_AIRevive_debug) then {
		_incap call ROS_Fnc_delYmarkers;
		if (lifestate _incap != "incapacitated") then {
			ROS_TimeTocomplete = (time - _reviveTime);
			[format ["Revive Total time: %1", ROS_TimeTocomplete]] remoteExec ["hintSilent",allPlayers];
		} else {
			["Incap not revived"] remoteExec ["hintsilent",allPlayers];
		};
	};

	/*
	// Is a player in the incap group
	_isplayerIngrpMedic = {isplayer _x} count units group _medic;
	_isplayerIngrpIncap = {isplayer _x} count units group _incap;

	// Allow medic to get into their assigned vehicle only if grp not in combat
	if (_isplayeringrpMedic ==0 && behaviour _medic != "COMBAT" && isnull _nearEnemy) then {
		_vehm = (_medic getVariable ["AssignedVeh", objNull]);
		if (!isnull _vehm && alive _vehm && isTouchingGround _vehm) then {
			sleep 2;
			[_vehm,0] remoteExec ["lock", 0];
			(group _medic) addVehicle _vehm;
			(units group _medic) allowGetIn true;
			[_medic,"NORMAL"] remoteExec ["setSpeedMode", 0];
		};
		if (_isplayeringrpMedic ==0 && leader _medic == _medic) then {
			[group _medic, getpos (leader _medic), 200] call BIS_fnc_taskPatrol;
		};
	};
	// Allow incap to get into their assigned vehicle only if not in combat
	if (_isplayeringrpIncap ==0 && behaviour _incap != "COMBAT" && isnull _nearEnemy) then {
		_vehi = (_incap getVariable ["AssignedVeh", objNull]);
		if (!isnull _vehi && alive _vehi && isTouchingGround _vehi) then {
			sleep 2;
			[_vehi,0] remoteExec ["lock", 0];
			(group _incap) addVehicle _vehi;
			(units group _incap) allowGetIn true;
			[_incap,"NORMAL"] remoteExec ["setSpeedMode", 0];
		};
		if (_isplayeringrpIncap ==0 && leader _incap == _incap) then {
			[group _incap, getpos (leader _incap), 200] call BIS_fnc_taskPatrol;
		};

	};
	*/

	[_medic, _incap, _nearEnemy] spawn {
		params ["_medic", "_incap", "_nearEnemy"];
		// Allow medic to return to orig position - single unit in grp
		if (behaviour _medic != "COMBAT" && isNull _nearEnemy) then {
			if !((_medic getVariable ["ROS_medicOrigPos",[]]) isEqualTo []) then {
				_posm = (_medic getVariable ["ROS_medicOrigPos",[]]);
				_dirm = (_medic getVariable ["ROS_medicOrigDir",0]);
				_medic domove _posm;
				sleep 1;
				waitUntil {(_medic distance _posm) <0.2 or unitReady _medic or !alive _medic};
				[_medic, _dirm] remoteExec ["setdir",0];
				if (unitReady _medic) then {
					// Cant get back to orig pos - then reset origpos to current pos
					if (_medic distance _posm >0.2) then {
						_medic setVariable ["ROS_medicOrigPos",[],true];
						_medic setVariable ["ROS_medicOrigDir",0,true];
					};
				};
			};
		};
		// Allow incap to return to orig position - single unit in grp
		if (lifestate _incap != "incapacitated" && behaviour _incap != "COMBAT" && isNull _nearEnemy) then {
			if !((_incap getVariable ["ROS_OrigPos",[]]) isEqualTo []) then {
				_posi = (_incap getVariable ["ROS_OrigPos",[]]);
				_diri = (_incap getVariable ["ROS_OrigDir",0]);
				_incap domove _posi;
				sleep 1;
				waitUntil {(_incap distance _posi) <0.2 or unitReady _incap or !alive _incap};
				[_incap, _diri] remoteExec ["setdir",0];
				if (unitReady _incap) then {
					// Cant get back to orig pos - then reset origpos to current pos
					if (_incap distance _posi >0.2) then {
						_incap setVariable ["ROS_OrigPos",[],true];
						_incap setVariable ["ROS_OrigDir",0,true];
					};
				};
			};
		};
	};
}; // End AIReviveUnits Fnc

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// END FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// LOOPED PROCESSES - RUN ON SERVER ONLY
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (isServer) then {
	// Add markers to incap or dead units and AI heal themselves
	[] spawn {
		while {true} do {

			{
				// Add marker
				if (lifestate _x == "INCAPACITATED" && isTouchingGround _x && vehicle _x == _x) then {
					if ((_x getVariable ["ROS_IncapMarker",""]) == "") then {
						_mkrName = "Marker" + str(round random 100000);
						_mkr = createMarker [_mkrName, position _x];
						_mkr setMarkerShape "ICON";
						_mkr setMarkerType "loc_Hospital";
						_mkr setmarkerText (name _x);
						_mkr setMarkerColor "ColorRed";
						_mkr setMarkerSize [0.5,0.5];
						_x setVariable ["ROS_IncapMarker",_mkrName,true];
					};
				};
				// Remove marker
				if (lifestate _x != "INCAPACITATED" && vehicle _x == _x && alive _x) then {

					if !(_x getVariable ["ROS_IncapMarker",""] == "") then {
						deleteMarker (_x getVariable "ROS_IncapMarker");
						_x setVariable ["ROS_IncapMarker","",true];
					};
				};
				// Add dead marker
				if (!alive _x) then {
					if ((_x getVariable ["ROS_IncapMarker",""]) == "") then {
						_mkrName = "Marker" + str(round random 100000);
						_mkr = createMarker [_mkrName, position _x];
						_mkr setMarkerShape "ICON";
						_mkr setMarkerType "loc_Hospital";
						_mkr setmarkerText (name _x);
						_mkr setMarkerColor "ColorBlack";
						_mkr setMarkerSize [0.5,0.5];
						_x setVariable ["ROS_IncapMarker",_mkrName,true];
						if (ROS_statusmsg) then {
							["memberdied"] remoteexec ["playSound", allPlayers];
						};
					};
				};
				// AI heal themselves
				if (!isPlayer _x && !(_x in ROS_Processing) && alive _x && damage _x >=0.2) then {
					_x spawn ROS_Fnc_AI_healSelf;
				};

			} foreach ROS_AllUnitsArray;

			sleep 2;
		}; // while
	}; // spawn

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// UPDATE ALLUNITS array and Remove blood
	[] spawn {
		while {true} do {
			// Update ALLUNITS array
			[] call ROS_Fnc_unitArrayEHupdate; // returns ROS_AllUnitsArray / PubVar

			sleep 5;
		};
	};

	// Remove blood
	[] spawn {
		while {true} do {

			// Remove blood
			_bRemoveTime = 300;
			if (count ROS_bloodPools >0) then {
				sleep _bRemoveTime;
				deleteVehicle (ROS_bloodPools select 0);
			};

			sleep 20;
		};
	};

}; // Isserver

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////// PRIMARY PROCESSING LOOP //////////////////////////////////////////////////////////
//////////////////////  ASSIGN INCAP UNIT AND MEDIC PAIRS  //////////////////////  ASSIGN INCAP UNIT AND MEDIC PAIRS  //////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Run on server only
if (isServer) then {

	ROS_incapsUnprocessed = [];
	ROS_medicsUnprocessed = [];

	// Store Orig Pos and Dir for units in own group
	{
		if (count units group _x ==1) then {
			if (_x getVariable ["ROS_OrigPos",[]] isEqualTo []) then {
				_pos = (getPosATL _x);
				_dir = (getdir _x);
				_x setVariable ["ROS_OrigPos", _pos, true];
				_x setVariable ["ROS_OrigDir", _dir, true];
			};
		};
	} foreach ROS_AllUnitsArray;

	// ROS_AI_revive Initialized
	// Zdo addition.
	//["ROS AI Revive Starting"] remoteExec ["hintsilent", allplayers];

	while {true} do {

		ROS_medics = [];
		_incap = objNull;
		_medic = objNull;

		// Update Incap units and potential medic units
		call ROS_Fnc_UpdateIncapAndMedics;

		// Get array of unprocessed Incap units
		ROS_incapsUnprocessed = ROS_incapacitated select {!(_x in ROS_Processing)};

		if (count ROS_incapsUnprocessed >0) then {

			//***** SELECT INCAP UNIT *****//
			_incap = (ROS_incapsUnprocessed select 0);
			//[_incap,false] remoteExec ["allowDamage",_incap];
			[_incap,true] remoteExec ["setCaptive",_incap];
			ROS_Processing pushBackUnique _incap;
			publicVariable "ROS_Processing";

			// Fadeout Radio for downed player
			if (alive _incap && isPlayer _incap) then {
				[5, 0.2] remoteExec ["fadeRadio", _incap]};

			//***** SELECT MEDIC UNIT *****//
			ROS_medics_healthy = ROS_AllUnitsArray - ROS_incapacitated;
			ROS_medicsUnprocessed = (ROS_medics_healthy select {!(side _x == civilian) && !isPlayer _x && !(_x in ROS_Processing) && ((_x distance2D _incap) < ROS_medicDist)});

			if (alive _incap && count ROS_medicsUnprocessed >0) then {
				ROS_medics = [ROS_medicsUnprocessed, [], {_x distance _incap }, "ASCEND"] call BIS_fnc_sortBy;
				_medic = ROS_medics select 0;
				ROS_Processing pushBackUnique _medic;
				publicVariable "ROS_Processing";
				//[_medic,false] remoteExec ["allowDamage",_medic];
				[_medic,true] remoteExec ["setCaptive",_medic];
				sleep 0.2;
			} else {
				_medic = objNull;
			};

			// If Medic in own group store orig pos and dir - used to restore orig pos
			if (alive _incap && alive _medic && count units group _medic ==1) then {
				if (_medic getVariable ["ROS_medicOrigPos",[]] isEqualTo []) then {
					_pos = (getPosATL _medic);
					_dir = (getdir _medic);
					_medic setVariable ["ROS_medicOrigPos", _pos, true];
					_medic setVariable ["ROS_medicOrigDir", _dir, true];
				};
			};

			// Player is down send text and sound message
			if (alive _incap && isPlayer _incap && alive _medic && ROS_statusmsg) then {
				_sound = "";
				_nearestUnits = (nearestObjects [_incap,["camanbase"],100]) select {side _x == ROS_RevSide};
				if (count _nearestUnits ==0) then {_sound = "bepatient"}; // subtle humor
				[_incap, [_sound, 50, 1, true]] remoteExec ["say3D", _incap];
			};

			/////////////////////////////////////////////////////////////////

			// MEDIC IN VEHICLE - kick _medic out of vehicle
			if (alive _incap && alive _medic && !(isNull objectParent _medic) && isTouchingGround (vehicle _medic)) then {
				_veh = (objectParent _medic);
				unassignVehicle _medic;
				doGetOut _medic;
				[_medic] allowGetIn false;
				_medic setVariable ["AssignedVeh", _veh, true];
			};

			// DISPATCH MEDIC
			if (alive _incap && alive _medic) then {
				// Disable damage and set captive on medic
				//[_medic,false] remoteExec ["allowDamage",_medic];
				[_medic,true] remoteExec ["setCaptive",_medic];

				// Time before new medic assigned
				_timeOutDelay = 15;
				_dist = (_medic distance2D _incap);
				_timeOutDelay = _timeOutDelay + (_dist/3);
				// Revive time limit before recycle
				_revTimeLimit = (time + _timeOutDelay);
				_incap setVariable ["reviveTimeLimit", _revTimeLimit, true];
				_incap setVariable ["incapTimeLimit", (time + ROS_maxIncapTime), true];
				_medic setVariable ["reviveTimeLimit", _revTimeLimit, true];

				//if (isPlayer _incap) then {["A medic is on his way!\nHang in there!"] remoteExec ["hintsilent",_incap];};

				if (ROS_AIRevive_debug) then {
					[format ["INCAP: %1\nMEDIC: %2\n\nDistance: %3", _incap, _medic, _medic distance2D _incap]] remoteExec ["hintsilent",allPlayers];
				};

				if (ROS_statusmsg && isPlayer _incap) then {
					[_incap, ["ontheway", 50, 1, true]] remoteExec ["say3D", _incap];
				};

				[_medic, _incap] spawn {
					params ["_medic", "_incap"];
					// Start Recycle / death / Auto recovery
					[_medic, _incap] spawn ROS_Fnc_Recycle_Fnc;

					// Start AI revive
					[_medic, _incap] call ROS_Fnc_AIReviveUnits;

					waitUntil {
						sleep 1;
						(!alive _incap or !alive _medic or !(lifestate _incap == "INCAPACITATED") or (!(_incap in ROS_Processing) or !(_medic in ROS_Processing)))
					};
				};

			}; // end if !(_medic in ROS_Processing) && !(_incap in ROS_Processing)

		}; // end count ROS_incapsUnprocessed >0 && count ROS_medics_healthy >0

		sleep 3;

	}; // end while

}; // isserver


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
