private _items = [
    ["Land_BagFence_Long_F", 5],
    ["Land_BagFence_Round_F", 5],
    ["Land_fort_bagfence_long", 10],
    ["Land_fort_bagfence_round", 10],
    ["Land_fort_bagfence_corner", 10],

    ["Land_SandbagBarricade_01_half_F", 10],
    ["Land_SandbagBarricade_01_F", 10],
    ["Land_SandbagBarricade_01_hole_F", 10],

    ["Land_BagBunker_Small_F", 20],
    ["Land_BagBunker_01_small_green_F", 20],

    ["Land_BagFence_01_long_green_F", 5],
    ["Land_BagFence_01_round_green_F", 5],

    ["Land_DeerStand_01_F", 25],
    ["Land_DeerStand_02_F", 25],

    ["CamoNet_wdl_open_F", 10],
	["PortableFlagPole_01_F", 10]
];
[resistance, -1, _items] call ace_fortify_fnc_registerObjects;
