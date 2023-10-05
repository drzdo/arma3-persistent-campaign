// Part of Simple AI revive system - by RickOShay
// See ROS_monitor health script header for instructions
// [_caller] execVM "ROS_AI_revive\scripts\ROS_PlayerReviveAI.sqf";

params ["_player"];

_incap = cursorObject;
 [_incap, _player] remoteExecCall ["disableCollisionWith", 0, _incap];
_multiplier = 1;
_isMedic = false;
_hasmedicKit = false;
_nearestMkr = "";
_vcrew = [];

// Unassign vehicle crew to prevent them getting back in after revive (reset fnc will conditionally reassign veh and allow getin)
if (!isnull assignedVehicle _incap) then {
	_veh =  (assignedVehicle _incap);
	{_vcrew pushBack _x} foreach (ROS_AllUnitsarray select {assignedvehicle _x == _veh});
	// Unassign vehicle crew to prevent them getting back in after revive (reset fnc will conditionally reassign veh and allow getin)
	{unassignVehicle _x; [_x] allowGetIn false;} forEach _vcrew;
};

// Medic speed multiplier
if (_player getUnitTrait "Medic") then {_isMedic = true;};
if ("Medikit" in (items _player)) then {_hasmedicKit = true;};
if (_isMedic && !_hasmedicKit) then {_multiplier = 1.5};
if (_isMedic && _hasmedicKit) then {_multiplier = 1};

if (lifestate _incap == "INCAPACITATED") then {
	{ROS_Processing pushback _x} foreach [_incap, _player];
	publicVariable "ROS_Processing";

	waitUntil {_player distance _incap <2 or !alive _player};

	if (ROS_moaning) then {[_incap, _player] spawn ROS_Fnc_groan};

	_nearEnemy = _player findNearestEnemy _player;

	// Add smoke _incap, _player, _multiplier
	if (ROS_RevSmokeOn) then {[_incap, _player, _multiplier] spawn ROS_Fnc_RevSmoke};

	sleep 0.1;

	// Change medic anim for player
	if (_incap distance _nearEnemy > 100) then {
		[_player,"AinvPknlMstpSnonWnonDnon_medic4"] remoteExec ["playMoveNow", _player];
	} else {
		[_player,"ainvppnemstpslaywrfldnon_medicother"] remoteExec ["playMoveNow", _player];
	};

	sleep 10;

	// Remove FAK or Medikit
	_medItems = [];
	_item = objNull;
	_newdamage = 0;
	if ((items _player) find "Medikit" >-1) then {_newdamage = 0} else {_newdamage = 0.2};
	_medItems = items _player select {(_x find "Medikit" >-1) or (_x find "FirstAidKit" >-1) or (_x find "fak" >-1)};

	if (count _medItems >0) then {
		// Remove FAK first
		_items = items _player;
		_items sort true;
		_item = _medItems select 0;
		_player removeitem _item;
	};

	_incap setDamage _newdamage;
	if !((_incap getVariable ["ROS_IncapMarker",""]) == "") then {
		deleteMarker (_incap getVariable "ROS_IncapMarker");
		_incap setVariable ["ROS_IncapMarker","",true];
	};
	_grpI = (_incap getVariable ["Grp",(group _incap)]);
	[_incap] joinSilent _grpI;
	[_incap, (leader _grpI)] remoteExec ["doFollow", _incap];
	[_incap, false] remoteExec ["setUnconscious",_incap];
	[_incap] remoteExec ["ROS_Fnc_resetAI", _incap];
	_incap allowdamage true;
	_incap setCaptive false;
	ROS_Processing = ROS_Processing - [_incap, _player];
	publicVariable "ROS_Processing";

	[format ["%1\nrevived by\n%2",name _incap, name _player]] remoteExec ["hintsilent",0];
}; // end lifestate incap == "INCAPACITATED"

[(group _player), _player] remoteExec ["selectLeader", _player];
// Zero player rating if negative - after he revives
if (rating _player <0) then {_player addrating ((abs rating _player)+1)};

if !((_incap getVariable ["ROS_IncapMarker",""]) == "") then {
	deleteMarker (_incap getVariable "ROS_IncapMarker");
	_incap setVariable ["ROS_IncapMarker","",true];
};

// Remove nearest yellow markers if debug is on
if (ROS_AIRevive_debug) then {
	_incap call ROS_Fnc_delYmarkers;
};
