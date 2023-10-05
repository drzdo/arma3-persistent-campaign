# Zdo's Arma 3 Persistent Campaign scripts

## What is this?

These are scripts that for Arma 3 missions to make them feel **persistent**.

<img src="https://github.com/drzdo/arma3-persistent-campaign/assets/146330747/2a8ab18e-b12a-4002-9349-d8c089b5ea55" width=600>


Basically, the **effects from previous mission are moved to the next mission**. By effects I mean:

- vehicles (positions, damage, inventory, fuel, textures, flags)
- crates/boxes (positions, damage, inventory, arsenal)
- planted mines (positions)
- players (positions, loadout, ACE medical)
- all map markers
- ACE rallypoint position
- ACE trenches, ACE Fortify statics, any buildings placed by Zeus (technically, almost any static which are considered "Things" in Arma)
- ruined buildings, fences, trees
- all units (positions, loadout, ACE medical, roles in vehicles).

Also, I've integrated `ROS AI Revive Demo and script v4.0` written by `Rickoshay` https://steamcommunity.com/sharedfiles/filedetails/?id=2967824861 (big kudos!) and made couple of custom changes in there:

- previously, AI was only reviving the same team the player is in. Now, OPFOR AI can also revive other OPFOR AI.
- when AI revives another AI or player, ACE medical is still the thing. Now, after reviving, all wounds get bandaged, blood is restored. The only things to manually take care of are fractures, stitching (if enabled) and pain.

This makes friendly AI more helpful in battles and enemy AI more dangerous.

# Documentation

Please check out [Wiki](https://github.com/drzdo/arma3-persistent-campaign/wiki).

# Contributing

Contributions are welcome.

You are allowed to use these scripts and distribute them in your own missions. The only request is to mention the link to this repository.
