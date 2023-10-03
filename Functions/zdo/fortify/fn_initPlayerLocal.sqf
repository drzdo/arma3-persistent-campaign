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
