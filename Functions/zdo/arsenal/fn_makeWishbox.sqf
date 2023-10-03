params ["_box"];

_box setMaxLoad 1000000;

if (_box getVariable ["_wishbox_actions_created", false]) exitWith {
    // Do not make it wishbox again.
    0;
};

_box setVariable ["zdo_wishbox", true, true];
_box setVariable ["_wishbox_actions_created", true];

private _actionWishbox = ["zdo_wishboxSaveLoadout", "Make a wish with ACE Arsenal","",{
    _box = _target;
    _loadout = (getUnitLoadout player);

    [player, player, true] call ace_arsenal_fnc_openBox;

    _eventId = ["ACE_arsenal_displayClosed", {
        _box = (_thisArgs select 0);
        _loadout = (_thisArgs select 1);

        _weapons = flatten (getUnitLoadout player);
        _weapons = (_weapons arrayIntersect _weapons) select {_x isEqualType "" && {_x != ""}};
        {
            if ([_x] call zdo_util_fnc_isBackpack) then {
                _box addBackpackCargoGlobal [_x, 1];
            } else {
                _box addItemCargoGlobal [_x, 1];
            };
        } forEach _weapons;

        player setUnitLoadout _loadout;
        hint "Wishlist saved";

        _eventId = player getVariable ["arsenalEventId", -1];
        ["ACE_arsenal_displayClosed", _eventId] call CBA_fnc_removeEventHandler;
    }, [_box, _loadout]] call CBA_fnc_addEventHandlerArgs;

    player setVariable ["arsenalEventId", _eventId];
},{true}] call ace_interact_menu_fnc_createAction;
[_box, 0, ["ACE_MainActions"], _actionWishbox, true] call ace_interact_menu_fnc_addActionToObject;
