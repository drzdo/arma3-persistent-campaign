# Zdo's Arma 3 Persistent Campaign scripts

## What is this?

These are scripts that I use in Arma 3 missions to make them feel **persistent**.

<img src="doc/top.png" width="600"/>

Basically, the **effects from previous mission are moved to the next mission**. By effects I mean:

- vehicles (positions, damage, inventory, fuel, textures, flags)
- crates (positions, damage, inventory, arsenal)
- planted mines (positions)
- players (positions, loadout)
- all map markers
- ACE rallypoint position
- ACE trenches, ACE Fortify statics, any buildings placed by Zeus (technically, almost any static which are considered "Things" in Arma)

## Flow

This is how it is supposed to be used:

- create a new mission in 3den however you want
- place the whole directory near `mission.sqm`
    - if you have files to replace like `initPlayerLocal.sqf` and others - manually merge the content instead.
- create `VR Selector` object (blue one, `VR_3DSelector_01_default_F`)
    - name it `zdo_root` - this is important
    - disable "Show Model", "Enable Simulation", "Enable Damage"
    - add this line to its Init:

    ```
    [this] call ZDO_fnc_initRootObject;
    ```

- that's it, the mission is ready to run
- when mission is considered over and you want to "record the effects" - before players log out and mission complete is shown - in the debug console execute

    ```
	private _r = [] call ZDO_fnc_saveForEden;
	profileNamespace setVariable ["zdo_mission", str _r];
	_r;
    ```

- in debug console you should see the content like

    ```
    [["objects",[[["kind","th"],["type","Land_WoodenCrate_01_F"],["pos"<...>
    ```
    
    It means that the content is saved.
    
- then you are good to close the mission and players to log out
- go to 3den, open the mission file, open debug console and load the saved data by executing

    ```
    private _s = profileNamespace getVariable ["zdo_mission", ""];
	if (!(_s isEqualTo "")) then {
		private _v = parseSimpleArray _s;
		[_v] call ZDO_fnc_loadToEden;
		_v;
	};
    ```

- close debug console and you should get a new layer named `Loaded <date when save was made>`
- this layer contains all saved data split into sublayers:

    ![Layer](doc/layer.png)

## Why scripts, not a mod?

Developing scripts feels faster, it makes the development easier.

Maybe, someday it will become a mod. For that, there are some configurations that I need but may not be needed by somebody else - these configurations need to be cleaned up.

# Other features

## How inventory is saved

Player can have a backpack with an rifle with plenty of attachments. 

When player puts this backpack to the inventory - nothing changes, backpack with all its items is in there. But when the inventory is being saved, all nesting is removed.

Basically, instead of having a tree

```
backpack
    rifle
        scope
        silencer
```

this is what is beingsaved:

```
backpack
rifle
scope
silencer
```

If player wants to get his loadout back - they would need to repack everything manually. This is not a good option.

Therefore, there is a way to make this container "an arsenal".

## Make crate an arsenal

When admin is looking at a crate, in ACE Self-Interact menu there will be an option to make this crate an arsenal - or you can execute

```
[cursorTarget] call ZDO_fnc_makeArsenalGlobal;
```

When you do that:

- this crate gets an ACE Interact option to open an ACE Arsenal
- ACE Arsenal is bound to the crate's content (if there is at least one item of any type - it will appear in the Arsenal)
- the fact that this crate is an arsenal is saved

When player is looking at this crate, there is an option to load items from nearest vehicles to the arsenal.

Why I decided to implement this arsenal?

- using just inventory is not so visually stimulating for players, arsenal is better in this regard
- using unlimited arsenal provides too many options (especially, if you are using something like 3CB Factions)
- using limited arsenal (like the one in Antistasi) implies grind which can make the game boring. Hey, you got 10 AKs, but you've died 10 times assaulting the outpost, now go get 10 more AKs. Nah, boring.

## Flag

`flag.jpg` in the mission folder will be automatically assigned to ACE Rallypoint (for independent faction).

While looking at a vehicle, player can select ACE Self-Interact option to put flag on a vehicle as well.

<img src="doc/flag.png" width="512"/>

## Looting to a vehicle

While looking at a vehicle, player can choose to gather loot to it.

<img src="doc/gatherloot.png" width="600"/>

Why I decided to implement it?

- using one-time use loot crates from Antistasi is too grindy for me
- I want looting to be fun, when you finally did whatever you want and now yeah you get the good loot.
  Running around with loot box is just more tedious.

## Wishbox

Say, it is a time to assault a heavely protected enemy outpost. As the result of this assault, you and your players likely want to get more advanced loot that they do not currently have. What are the options?

*Option A:* Zeus can just give a better loot when next mission is started.

Viable, but immersion breaking. Players get more dophamine when they know that they will actually get the loot as the result of the operation.

*Option B:* Zeus can spawn a crate and put there whatever players say they want.

If you have more than two people playing - it becomes tedious, Zeus becomes a bottleneck.

*Option C:* Just loot whatever will be on the outpost.

Yeah, kind of Antistasi way. But if this is your third outpost - the loot will be pretty much the same as for previous two ones.

*Option D:* The way I implemented this:

- Zeus spawns a crate (wishbox)
- Players temporarily get full ACE Arsenal
- They select the gear that they want to see in the outpost
    - Zeus may verbally impose some limitations
- When they are done with it, they original loadout is restored
- And whatever they have selected in ACE Arsenal gets added to the crate
- Zeus potentially adds something cool to it
- Zeus moves crate to the enemy base.

Here is how you do it:

- create an empty crate
- make it a "wishbox"
    
    ```
    [cursorTarget] call ZDO_fnc_makeWishboxGlobal;
    ```
    
- call your players to "make a wish" on this container
- when player ACE-interact with the container, there will be a corresponding option which opens full ACE Arsenal
- when player closes arsenal, the chosen gear is put in the wishbox.

## Blood splatter

`zdo_root` object tracks kills. Whenever entity is killed, the position gets recorded.

When the save is loaded in 3den, `zdo_root` init part gets updated. Remember you created an object and put `ZDO_fnc_initRootObject` in it? Now, there is a lot of stuff being added after this line.

For each kill, a `simpleobject` is created with a blood splatter. Basically, when next mission is started, every player is going to see where were the most kills on the map.

Example of a fight in Livonia:

![blood](doc/blood.png)

The cap is 100.

## ACE Fortify

There is a custom ACE Fortify setup in `initServer.sqf`.

All placed objects are saved.

To remove them player can self-interact and pick "Delete this object".

Example of a garrisoned house that was a good defense position for a long time:

![fortify](doc/fortify.png)

---

# Tips and tricks

- in 3den, when you have one "Loaded" layer and you load another one - do not delete the obsolete layer using `DEL` on keyboard because sometimes is messes up the selection and deletes another random object (I suspect bug in 3den). Instead, right click and delete the old layer.

- you can play in ChernarusAutumn, save the game, and load it in ChernarusWinter and continue there!

# Known issues

- when player logs in - they get a saved loadout
    - then player changes items and logs out
    - then player logs back in - instead of getting loadout from step 2 they get saved loadout

- when player joins in progress, the crate that was made an arsenal in this session is not synchronized as arsenal.
    - inventory is synchronized OK, player just cannot "Open as Arsenal" on it.

# Contributing

Contributions are welcome.

You are allowed to use these scripts and distribute them in your own missions. The only request is to mention the link to this repository.
