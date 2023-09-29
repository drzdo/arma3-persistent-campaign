params ["_playerUnit", "_didJIP"];

[_playerUnit] call ZDO_fnc_loadPlayerGear;

private _flagT = [
    "ACE_Rallypoint_Independent_Base",
    "ACE_Rallypoint_Independent"
];
{
    {
        _x forceFlagTexture "flag.jpg";
    } forEach (allMissionObjects _x);
} forEach _flagT;


private _actionSetFlag = ["zdo_setVehicleFlag", "Set flag to this vehicle","",{
    cursorTarget forceFlagTexture "flag.jpg";
},{
    private _r = false;
    if (!(isNull cursorTarget) && ((getForcedFlagTexture cursorTarget) isEqualTo "")) then {
       	private _objectType = cursorTarget call BIS_fnc_objectType;
        _r = (
            (
                ((_objectType select 0) isEqualTo "Vehicle") ||
                ((typeof cursorTarget) isEqualTo "PortableFlagPole_01_F")
            ) &&
            (player distance2D cursorTarget) < 5
        );
    };
    _r;
}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionSetFlag, true] call ace_interact_menu_fnc_addActionToObject;

private _actionRemoveFlag = ["zdo_removeVehicleFlag", "Remove flag from this vehicle","",{
    cursorTarget forceFlagTexture "";
},{
    private _r = false;
    if (!(isNull cursorTarget) && !((getForcedFlagTexture cursorTarget) isEqualTo "")) then {
       	private _objectType = cursorTarget call BIS_fnc_objectType;
        _r = (
            (
                ((_objectType select 0) isEqualTo "Vehicle") ||
                ((typeof cursorTarget) isEqualTo "PortableFlagPole_01_F")
            ) &&
            (player distance2D cursorTarget) < 5
        );
    };
    _r;
}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionRemoveFlag, true] call ace_interact_menu_fnc_addActionToObject;


private _actionMakeArsenal = ["zdo_makeArsenal", "Add ACE Arsenal to this container","",{
    private _o = cursorTarget;
    [_o] call ZDO_fnc_makeArsenalGlobal;
},{
    private _r = false;
    if (!(isNull cursorTarget) && (((admin owner player) > 0) || isServer)) then {
        _r = true;
       	_r = (
            (cursorTarget canAdd "FirstAidKit") &&
            (player distance2D cursorTarget) < 5
        );
    };
    _r;
}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionMakeArsenal, true] call ace_interact_menu_fnc_addActionToObject; 


private _actionGatherLoot = ["zdo_gatherLoot", "Gather loot to this container (&lt;100m)","",{
    private _box = cursorTarget;
    [_box, getPos _box, 100] call ZDO_fnc_gatherLoot;
},{
    private _r = false;
    if (!(isNull cursorTarget)) then {
       	private _objectType = cursorTarget call BIS_fnc_objectType;
        _r = (
            (cursorTarget canAdd "FirstAidKit") &&
            (player distance2D cursorTarget) < 5
        );
    };
    _r;
}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionGatherLoot, true] call ace_interact_menu_fnc_addActionToObject; 

private _actionDelete = ["zdo_gatherLoot", "Delete this object","",{
    deleteVehicle cursorTarget;
},{
    private _r = false;
    if (!(isNull cursorTarget)) then {
       	private _objectType = cursorTarget call BIS_fnc_objectType;
        _r = (
            (
                (_objectType isEqualTo ["Object", "House"]) ||
                (_objectType isEqualTo ["Object", "Thing"])
            ) &&
            (player distance2D cursorTarget) < 5
        );
    };
    _r;
}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionDelete, true] call ace_interact_menu_fnc_addActionToObject; 


private _actionRaiseFlag = ["zdo_flagRaise", "Raise the flag","",{
    cursorTarget animateSource ["Flag_source", 1, false];
},{
    private _r = false;
    if (!(isNull cursorTarget)) then {
       	_r = (
            ((typeof cursorTarget) isEqualTo "PortableFlagPole_01_F") &&
            (player distance2D cursorTarget) < 5
        );
    };
    _r;
}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionRaiseFlag, true] call ace_interact_menu_fnc_addActionToObject; 


private _actionLowerFlag = ["zdo_flagRaise", "Lower the flag","",{
    cursorTarget animateSource ["Flag_source", 0, false];
},{
    private _r = false;
    if (!(isNull cursorTarget)) then {
       	_r = (
            ((typeof cursorTarget) isEqualTo "PortableFlagPole_01_F") &&
            (player distance2D cursorTarget) < 5
        );
    };
    _r;
}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionLowerFlag, true] call ace_interact_menu_fnc_addActionToObject; 
