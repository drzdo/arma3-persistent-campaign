/**
Add ACE Self-Interactions for flags.
To be called in initPlayerLocal.sqf.
 */

localNamespace setVariable ["flag_to_use", "Functions\zdo\flag\flag.jpg"];

private _flagT = [
    "ACE_Rallypoint_Independent_Base",
    "ACE_Rallypoint_Independent"
];
{
    {
        _x forceFlagTexture (localNamespace getVariable ["flag_to_use", ""]);
    } forEach (allMissionObjects _x);
} forEach _flagT;


private _actionSetFlag = ["zdo_setVehicleFlag", "Put our flag to this vehicle","",{
    cursorTarget forceFlagTexture (localNamespace getVariable ["flag_to_use", ""]);
},{
    private _r = false;
    if (!(isNull cursorTarget) && ((getForcedFlagTexture cursorTarget) isEqualTo "")) then {
       	private _objectType = cursorTarget call BIS_fnc_objectType;
        _r = (
            ((_objectType select 0) isEqualTo "Vehicle") &&
            (player distance2D cursorTarget) < 5
        );
    };
    _r;
}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _actionSetFlag, true] call ace_interact_menu_fnc_addActionToObject;


private _actionSetFlagToPole = ["zdo_setFlagpoleFlag", "Put our flag to this flag pole","",{
    cursorTarget forceFlagTexture (localNamespace getVariable ["flag_to_use", ""]);
},{
    private _r = false;
    if (!(isNull cursorTarget) && ((getForcedFlagTexture cursorTarget) isEqualTo "")) then {
       	private _objectType = cursorTarget call BIS_fnc_objectType;
        _r = (
            ((typeof cursorTarget) isEqualTo "PortableFlagPole_01_F") &&
            (player distance2D cursorTarget) < 5
        );
    };
    _r;
}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _actionSetFlagToPole, true] call ace_interact_menu_fnc_addActionToObject;

private _actionRemoveFlag = ["zdo_removeVehicleFlag", "Remove flag","",{
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
