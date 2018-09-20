#include "macros.hpp"
AS_SERVER_ONLY("fnc_resetPetrPosition.sqf");
private _dir = fuego getdir cajaVeh;
private _defPos = [getPos fuego, 3, _dir + 45] call BIS_Fnc_relPos;

Petr setPos _defPos;
Petr setDir (Petr getDir fuego);

diag_log "[AS] Server: Petr repositioned";
