private _data = profileNamespace getVariable ["zdo_mission", []];
if (count _data > 0) then {
    [_data] call zdo_persist_editor_fnc_loadAll;
};
_data;