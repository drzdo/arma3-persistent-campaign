call ZDOGM_fnc_initAceFortify;

// -- mission

// west setFriend [resistance, 1];
// east setFriend [resistance, 1];

// UK3CB_CCM_B UK3CB_LSM_O UK3CB_CPD_I

call ZDOGM_fnc_logClean;

try {


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

    // // Cleanup.
    // [laptop] call ZDOGM_fnc_deleteOtherObjectsOfSameType;
    
    // call ZDOGM_fnc_deleteAllSigns;
    // [true] call ZDOGM_fnc_deleteAllSigns; // debug
} catch {
    ["ERROR %1", str _exception] call ZDOGM_fnc_log;
    [str _exception] spawn BIS_fnc_guiMessage;
}