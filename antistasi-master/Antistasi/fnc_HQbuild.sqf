#include "macros.hpp"
AS_SERVER_ONLY("fnc_HQbuild.sqf");

[Petr] join grupoPetr;
[[Petr,"remove"],"AS_fnc_addAction"] call BIS_fnc_MP;
[[Petr,"mission"],"AS_fnc_addAction"] call BIS_fnc_MP;
Petr forceSpeed 0;

["FIA_HQ", "position", getPos Petr] call AS_location_fnc_set;

// place everything on its place
call AS_fnc_HQdeploy;

// and then show everything
if isMultiplayer then {
	{_x hideObjectGlobal false} forEach AS_permanent_HQplacements;
} else {
	{_x hideObject false} forEach AS_permanent_HQplacements;
};
