/**
Create blood sprite for one position.
To be called on server.
 */

params ["_killPosArray"];

private _tracker = ["zdo_kill_tracker"] call zdo_persist_game_fnc_getOrCreateMarkedObject;

private _blood = [
	"a3\Props_F_Orange\Humanitarian\Garbage\BloodPool_01_Large_F",
	"a3\Props_F_Orange\Humanitarian\Garbage\BloodPool_01_Medium_F",
	"a3\Props_F_Orange\Humanitarian\Garbage\BloodSplatter_01_Large_F",
	"a3\Props_F_Orange\Humanitarian\Garbage\BloodSplatter_01_Medium_F",
	"a3\Props_F_Orange\Humanitarian\Garbage\BloodSplatter_01_Small_F",
	"a3\Props_F_Orange\Humanitarian\Garbage\BloodTrail_01_F",
	"a3\Props_F_Orange\Humanitarian\Garbage\BloodSpray_01_F"
];

private _explosions = [
	// Couldn't find crater sprites, not 3d models.
];

// This is needed to avoid bad Z clipping artifacts.
// Each blood sprite in 10x10 area gets gradually higher and higher.
private _positionsInCell = _tracker getVariable ["_kill_positions_in_cell", createHashMap];

private _killHashMap = createHashMapFromArray _killPosArray;

private _pos = _killHashMap get "pos";
private _z = getTerrainHeightASL _pos;

private _cellKey = format [
	"%1_%2",
	round ((_pos select 0) / 10.0),
	round ((_pos select 1) / 10.0)
];
private _zOffset = _positionsInCell getOrDefault [_cellKey, 0];
_positionsInCell set [_cellKey, _zOffset + 1];
_tracker setVariable ["_kill_positions_in_cell", _positionsInCell];

_pos set [2, _z + _zOffset * 0.001];

if (_killHashMap get "man") then {
	private _model = selectRandom _blood;
	private _blood = createSimpleObject [_model, _pos, false];
	_blood setDir (random 360);
	_blood setVectorUp (surfaceNormal _pos);
} else {
	// TODO
};
