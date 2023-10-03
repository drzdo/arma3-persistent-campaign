params ["_pgi"];

group ((_pgi getOrDefault ["original_units", []]) select 0);
