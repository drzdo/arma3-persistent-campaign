params ["_name"];

(zdo_root getVariable [_name, "__NOT__SET__"]) != "__NOT__SET__";