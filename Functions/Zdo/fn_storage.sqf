private _storageStr = missionNamespace getVariable ["zdo_storage", ""];
private _storage = createHashMap;
if (!(_storageStr isEqualTo "")) then {
    _storage = createHashMapFromArray (parseSimpleArray _storageStr);
};
_storage;
