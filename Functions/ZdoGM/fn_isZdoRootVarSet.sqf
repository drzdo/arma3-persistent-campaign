params ["_name"];

!((zdo_root getVariable [_name, "__NOT__SET__"]) isEqualTo "__NOT__SET__");