/**
For quick debugging.

profileNamespace getVariable ["zdo_log", 0];
*/

if (is3DEN || is3DENPreview) then {
	private _msgs = profileNamespace getVariable ["zdo_log", []];
	_msgs pushBack (format _this);
	profileNamespace setVariable ["zdo_log", _msgs];
};