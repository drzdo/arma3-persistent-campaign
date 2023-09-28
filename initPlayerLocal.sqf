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
},{!(isNull cursorTarget) && ((getForcedFlagTexture cursorTarget) isEqualTo "")}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionSetFlag, true] call ace_interact_menu_fnc_addActionToObject;

private _actionRemoveFlag = ["zdo_removeVehicleFlag", "Remove flag from this vehicle","",{
    cursorTarget forceFlagTexture "";
},{!(isNull cursorTarget) && !((getForcedFlagTexture cursorTarget) isEqualTo "")}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionRemoveFlag, true] call ace_interact_menu_fnc_addActionToObject;


private _actionMakeArsenal = ["zdo_makeArsenal", "Add ACE Arsenal to this container","",{
    private _o = cursorTarget;
    [_o] call ZDO_fnc_makeArsenalGlobal;
},{!(isNull cursorTarget) && (((admin owner player) > 0) || isServer)}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionMakeArsenal, true] call ace_interact_menu_fnc_addActionToObject; 


private _actionGatherLoot = ["zdo_gatherLoot", "Gather loot to this container (&lt;100m)","",{
    private _box = cursorTarget;
    [_box, getPos _box, 100] call ZDO_fnc_gatherLoot;
},{!(isNull cursorTarget)}] call ace_interact_menu_fnc_createAction;  
[player, 1, ["ACE_SelfActions"], _actionGatherLoot, true] call ace_interact_menu_fnc_addActionToObject; 
