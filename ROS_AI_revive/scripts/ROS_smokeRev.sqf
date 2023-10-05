// Simple smoke effect - RickOShay
// [_relpos, _colArray, _ttl] execvm "ROS_AI_revive\scripts\ROS_smokeRev.sqf";

/*
_particleSpeed = 0.1;
_particleLifting = -0.2;
_windEffect = 0.2;
_particleSize = 5;
_colorRed = .9;
_colorGreen = .9;
_colorBlue = .9;
_colorAlpha = 0.3;
_expansion = 0.1;
_particleLifeTime = 0.1;
_effectSize = 0.1;
_particleDensity = 50;

_emitter = "#particlesource" createVehicleLocal getpos _pos;

  _emitter setParticleRandom [0.5, [0.3, 0.3, 0.3], [0.4, 0.4, 0.4], 0, 0.3, [0, 0, 0, 0], 0, 0];
  _emitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 8,0],
      "", "Billboard", 1, 2, [0, 0, 0],
      [0,0,0], 1, 1, 0.80, 0.5, [2.5,3.5,4],[[_colorRed,_colorGreen,_colorBlue,_colorAlpha],[_colorRed,_colorGreen,_colorBlue,_colorAlpha],[_colorRed,_colorGreen,_colorBlue,_colorAlpha],[_colorRed,_colorGreen,_colorBlue,_colorAlpha],[_colorRed,_colorGreen,_colorBlue,_colorAlpha],[_colorRed,_colorGreen,_colorBlue,_colorAlpha],
  [_colorRed,_colorGreen,_colorBlue,_colorAlpha],[_colorRed,_colorGreen,_colorBlue,_colorAlpha],[_colorRed,_colorGreen,_colorBlue,_colorAlpha]],[1],0.1,0.1,"","",_pos,random 360];
  _emitter setdropinterval 0.002;

_emitter attachto [_pos, [0,-1,0]];

sleep _ttl;

deleteVehicle _emitter;

*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

params ["_pos", "_col", "_ttl"];

_co = "Land_CanOpener_F" createVehicle _pos;
sleep 0.1;
_c1 =_col select 0;
_c2 =_col select 1;
_c3 =_col select 2;

_source1 = "#particlesource" createVehicle _pos;
_source1 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48], "", "Billboard", 1, 20, [0, 0, 0],
				[0.2, 0.1, 0.1], 0, 1.277, 1, 0, [0.1, 2, 6], [[_c1, _c2, _c3, 0.2], [_c1, _c2, _c3, 0.05], [_c1, _c2, _c3, 0]],
				 [1.5,0.5], 1, 0, "", "", _pos];
_source1 setParticleRandom [2, [0, 0, 0], [0.25, 0.25, 0.25], 0, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
_source1 setDropInterval 0.1;
_source1 attachTo [_co,[0,0,0]];

_source2 = "#particlesource" createVehicle _pos;
_source2 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 8, 0], "", "Billboard", 1, 20, [0, 0, 0],
				[0.2, 0.1, 0.1], 0, 1.277, 1, 0, [0.1, 2, 6], [[_c1, _c2, _c3, 1], [_c1, _c2, _c3, 0.5], [_c1, _c2, _c3, 0]],
				 [0.2], 1, 0, "", "", _pos];
_source2 setParticleRandom [2, [0, 0, 0], [0.25, 0.25, 0.25], 0, 0.5, [0, 0, 0, 0.2], 0, 0, 360];
_source2 setDropInterval 0.05;
_source2 attachTo [_co,[0,0,0]];

sleep _ttl;
_co setPosATL (_co modelToWorld [0,0,-40]);
deletevehicle _source1;
deletevehicle _source2;
{if (typeOf _x == "#particlesource") then {deleteVehicle _x}} forEach (_co nearObjects 20);
sleep 1;
deletevehicle _co;
