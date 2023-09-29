private _items = [
    "Land_BagFence_Long_F",
    "Land_BagFence_Round_F",
    "Land_fort_bagfence_long", 
    "Land_fort_bagfence_round", 
    "Land_fort_bagfence_corner",

    "Land_SandbagBarricade_01_half_F",
    "Land_SandbagBarricade_01_F",
    "Land_SandbagBarricade_01_hole_F",
    
    "Land_BagBunker_Small_F",
    "Land_BagBunker_01_small_green_F",
    
    "Land_BagFence_01_long_green_F",
    "Land_BagFence_01_round_green_F",
    
    "Land_DeerStand_01_F",
    "Land_DeerStand_02_F",
    
    "CamoNet_wdl_open_F",
	"PortableFlagPole_01_F"
];
[resistance, -1, _items apply {[_x, 5]}] call ace_fortify_fnc_registerObjects;
