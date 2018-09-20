#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_rearmPetr.sqf");
private _mag = currentMagazine Petr;
Petr removeMagazines _mag;
Petr removeWeaponGlobal (primaryWeapon Petr);
[Petr, selectRandom (AAFWeapons arrayIntersect (AS_weapons select 0)), 5, 0] call BIS_fnc_addWeapon;
Petr selectweapon primaryWeapon Petr;
