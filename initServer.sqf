call ZDOGM_fnc_initAceFortify;

// -- mission

// west setFriend [resistance, 1];
// east setFriend [resistance, 1];

// UK3CB_CCM_B UK3CB_LSM_O UK3CB_CPD_I

call ZDOGM_fnc_logClean;

try {
    // Vars.
    intel_laptop;
    group_qrf_red;
    group_help;
    // armex

    // Init.
    private _signsIntel = [call ZDOGM_fnc_signArmex, -1] call ZDOGM_fnc_pickNRandomObjectsOfType;
    private _signIntel = selectRandom _signsIntel;
    ["intel_src", "intel_dst", _signIntel] call ZDOGM_fnc_teleportLayerObjectsToSameObjectInOtherLayerNearSign;

    {
        [_x, 1, 1] call ZDOGM_fnc_limitGroupVehicles;
    } forEach allGroups;

    private _traitorGroupIds = [_signIntel, 50] call ZDOGM_fnc_findGroupIdsInProximity;
    private _traitors = [];
    {
        private _g = _x call ZDOGM_fnc_getGroupById;
        _traitors append (units _g);
    } forEach _traitorGroupIds;

    private _distanceToTrigger = [10, 70] call BIS_fnc_randomInt;
    
    private _groupIdQrfRed = groupId group group_qrf_red;
    private _groupIdHelp = groupId group group_help;

    // Lambs.
    {
        private _sign = _x;
        private _groupIds = [_sign, 50] call ZDOGM_fnc_findGroupIdsInProximity;
        {
            private _g = _x call ZDOGM_fnc_getGroupById;
            [_g, getPosATL _sign, true] call ZDOGM_fnc_runLambsGarrison;
        } forEach _groupIds;
    } forEach _signsIntel;

    [4, [_distanceToTrigger, _traitors, _groupIdQrfRed, _groupIdHelp], {
        params ["_distanceToTrigger", "_traitors", "_groupIdQrfRed", "_groupIdHelp"];
        
        private _close = [intel_laptop, _distanceToTrigger] call ZDOGM_fnc_isAnyPlayerInProximity;
        if (_close || (["zdo_intel"] call ZDOGM_fnc_isZdoRootVarSet)) then {            
            private _enemyGroup = createGroup east;
            _traitors joinSilent _enemyGroup;

            [
                _groupIdQrfRed call ZDOGM_fnc_getGroupById,
                getPosATL intel_laptop
            ] call ZDOGM_fnc_runSeekAndDestroy;

            [
                _groupIdHelp call ZDOGM_fnc_getGroupById,
                getPosATL intel_laptop
            ] call ZDOGM_fnc_runSeekAndDestroy;

            false;
        } else {
            true;
        };
    }] call ZDOGM_fnc_spawnTrigger;

    // private _laptopProbs = [laptop, 2] call ZDOGM_fnc_pickOtherNRandomObjects;
    // [_laptopProbs, "Laptop?", "ColorBlue"] call ZDOGM_fnc_createMapMarkers;
    // private _laptopProb = [laptop, selectRandom _laptopProbs] call ZDOGM_fnc_teleportToObject;

    // private _sign = [_laptopProb, [] call ZDOGM_fnc_signArmex] call ZDOGM_fnc_findNearestSignOfType;

    // [group leader_garrison, getPosATL _sign, true] call ZDOGM_fnc_runLambsGarrison;
    // [group leader_patrol, getPosATL _sign] call ZDOGM_fnc_runLambsPatrol;

    //[group_test, 1, 2] call ZDOGM_fnc_limitGroupVehicles;

    // private _srcList = [call ZDOGM_fnc_signBurstkoke, 2] call ZDOGM_fnc_pickNRandomObjectsOfType;
    // private _dstList = [call ZDOGM_fnc_signBlueking, 2] call ZDOGM_fnc_pickNRandomObjectsOfType;
    // [group leader_garrison, getPosATL selectRandom _srcList, getPosATL selectRandom _dstList] call ZDOGM_fnc_runSeekAndDestroy;

    // [_srcList, "S%1", "ColorGreen"] call ZDOGM_fnc_createMapMarkers;

    // [_dstList, "D%1", "ColorRed"] call ZDOGM_fnc_createMapMarkers;

    // [group boomcargo, getPosATL selectRandom _srcList, getPosATL selectRandom _dstList] call ZDOGM_fnc_runMove;

    // private _srcList = [call ZDOGM_fnc_signRedstone, 4] call ZDOGM_fnc_pickNRandomObjectsOfType; 
    // ["Layer 209", selectRandom _srcList, 2] call ZDOGM_fnc_teleportLayerObjectsAsWhole;

    // [2, [groupID group_test], {
    //     params ["_gId"];
    //     private _g = _gId call ZDOGM_fnc_getGroupById;
    //     private _close = [leader _g, 5] call ZDOGM_fnc_isAnyPlayerInProximity;
    //     if (_close || (["a1"] call ZDOGM_fnc_isZdoRootVarSet)) then {
    //         [_g, 1, 2] call ZDOGM_fnc_limitGroupVehicles;
    //         false;
    //     } else {
    //         true;
    //     };
    // }] call ZDOGM_fnc_spawnTrigger;

    // [2, [groupID group traitor], {
    //     params ["_gId"];

    //     if (zdo_root getVariable ["zdo_intel", 0] == 1) then {
    //         private _g = _gId call ZDOGM_fnc_getGroupById;
    //         if (!(isNull _g)) then {
    //             private _enemyGroup = createGroup east;
    //             (units _g) joinSilent _enemyGroup;
    //         };
    //         false;
    //     } else {
    //         true;
    //     };
    // }] call ZDOGM_fnc_spawnTrigger;

    // private _armexL = [call ZDOGM_fnc_signArmex, 2] call ZDOGM_fnc_pickNRandomObjectsOfType;
    // private _armex = selectRandom _armexL;
    // [_armex, ["Layer 210", "Layer 212"]] call ZDOGM_fnc_deleteOtherLayersWithSameSignType;

    // [boomcargo, [
    //     ["text", "Cargo"],
    //     ["color", "ColorBlue"],
    //     ["type", "c_car"],
    //     ["radius", 0]
    // ]] call ZDOGM_fnc_spawnMapPositionTracker;

    // ------------- Cleanup.
    // [laptop] call ZDOGM_fnc_deleteOtherObjectsOfSameType;

    ["intel_dst"] call ZDOGM_fnc_deleteWholeLayer;
    
    call ZDOGM_fnc_deleteAllSigns;
    // [true] call ZDOGM_fnc_deleteAllSigns; // debug
} catch {
    ["ERROR %1", str _exception] call ZDOGM_fnc_log;
    [str _exception] spawn BIS_fnc_guiMessage;
}