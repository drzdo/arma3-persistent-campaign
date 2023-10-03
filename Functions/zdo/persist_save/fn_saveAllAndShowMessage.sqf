["Game is being saved..."] remoteExec ["systemChat", 0];

[] spawn {
    call zdo_persist_save_fnc_saveAll;

    ["Game is saved successfully"] remoteExec ["systemChat", 0];
    ["Saved to local profile"] call BIS_fnc_guiMessage;
};
