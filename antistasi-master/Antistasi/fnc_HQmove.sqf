#include "macros.hpp"
AS_SERVER_ONLY("fnc_HQmove.sqf");

Petr enableAI "MOVE";
Petr enableAI "AUTOTARGET";
Petr forceSpeed -1;

[[Petr, "remove"], "AS_fnc_addAction"] call BIS_fnc_MP;
call AS_fnc_rearmPetr;
[Petr] join AS_commander;
Petr setBehaviour "AWARE";

if isMultiplayer then {
	{_x hideObjectGlobal true} forEach AS_permanent_HQplacements;
} else {
	{_x hideObject true} forEach AS_permanent_HQplacements;
};

"delete" call AS_fnc_HQaddObject;

sleep 5;

[[Petr, "buildHQ"],"AS_fnc_addAction"] call BIS_fnc_MP;
