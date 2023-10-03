/**
Adds arsenal ACE Interactions.
To be called in initPlayerLocal.
 */

{
    if (_x getVariable ["zdo_arsenal", false]) then {
        [_x] call zdo_arsenal_fnc_makeArsenal;
    };
    if (_x getVariable ["zdo_wishbox", false]) then {
        [_x] call zdo_arsenal_fnc_makeWishbox;
    };
} forEach allMissionObjects "";

private _actionMakeArsenal = ["zdo_makeArsenal", "Add ACE Arsenal to this container","",{
    private _o = cursorTarget;
    [_o] call zdo_arsenal_fnc_makeArsenalGlobal;
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
    [_box, getPos _box, 100] call zdo_arsenal_fnc_gatherLoot;
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

