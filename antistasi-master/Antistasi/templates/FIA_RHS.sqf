// clean everything because we do not need the default stuff
{AS_FIAvehicles setVariable [_x, nil];} forEach (allVariables AS_FIAvehicles);

AS_FIAvehicles setVariable ["land_vehicles", [
	"C_Offroad_01_F",
	"B_T_LSV_unarmed_01_F",
	"B_G_Offroad_01_armed_F",
	"rhs_Ural_Open_Civ_01",
	"rhsusf_mrzr4_d",
	statMG, statMortar, statAT, statAA
]];

// All elements in the lists above must be priced below or their price is 300
AS_FIAvehicles setVariable ["C_Offroad_01_F", 200];
AS_FIAvehicles setVariable ["rhs_Ural_Open_Civ_01", 400];
AS_FIAvehicles setVariable ["rhsusf_mrzr4_d", 50];
AS_FIAvehicles setVariable ["B_T_LSV_unarmed_01_F", 200];
AS_FIAvehicles setVariable ["B_G_Offroad_01_armed_F", 700];
AS_FIAvehicles setVariable [statMG, 800];
AS_FIAvehicles setVariable [statMortar, 800];
AS_FIAvehicles setVariable [statAT, 800];
AS_FIAvehicles setVariable [statAA, 800];

AS_FIAvehicles setVariable ["water_vehicles", ["B_G_Boat_Transport_01_F"]];
AS_FIAvehicles setVariable ["B_G_Boat_Transport_01_F", 400];

// First helicopter of this list is undercover
AS_FIAvehicles setVariable ["air_vehicles", ["rhs_Mi8amt_civilian"]];
AS_FIAvehicles setVariable ["rhs_Mi8amt_civilian", 6000];

AS_FIA_vans = ["rhs_Ural_Open_Civ_01", "rhs_Ural_Open_Civ_02", "rhs_Ural_Open_Civ_03"];

AS_FIACustomSquad_types = ["Mobile AA", "Mobile AT", "Mobile Mortar"];


AS_fnc_FIACustomSquad_piece = {
	params ["_squadType"];
	if (_squadType == "Mobile AT") exitWith {statAT};
	if (_squadType == "Mobile Mortar") exitWith {statMortar};
};

AS_fnc_FIACustomSquad_cost = {
	params ["_squadType"];
	private _cost = 0;
	private _costHR = 0;
	if (_squadType == "Mobile AA") then {
		_costHR = 3;
		_cost = _costHR*(AS_data_allCosts getVariable "Crew") +
			    ([vehTruckAA] call AS_fnc_getFIAvehiclePrice);
	} else {
		_costHR = 2;
		_cost = _costHR*(AS_data_allCosts getVariable "Crew") +
				(["B_G_Van_01_transport_F"] call AS_fnc_getFIAvehiclePrice) +
				([[_squadType] call AS_fnc_FIACustomSquad_piece] call AS_fnc_getFIAvehiclePrice);
	};
	[_costHR, _cost]
};

AS_fnc_FIACustomSquad_initialization = {
	params ["_squadType", "_position"];
	private _grupo = grpNull;

	if (_squadType == "Mobile AA") then {
		private _pos = _position findEmptyPosition [1,30,vehTruckAA];
		private _vehicle = [_pos, 0, vehTruckAA, side_blue] call bis_fnc_spawnvehicle;
		private _veh = _vehicle select 0;
		private _vehCrew = _vehicle select 1;
		{deleteVehicle _x} forEach crew _veh;
		_grupo = _vehicle select 2;
		[_veh, "FIA"] call AS_fnc_initVehicle;
		private _driv = _grupo createUnit [["Crew"] call AS_fnc_getFIAUnitClass, _pos, [],0, "NONE"];
		_driv moveInDriver _veh;
		private _gun = _grupo createUnit [["Crew"] call AS_fnc_getFIAUnitClass, _pos, [],0, "NONE"];
		_gun moveInGunner _veh;
		private _com = _grupo createUnit [["Crew"] call AS_fnc_getFIAUnitClass, _pos, [],0, "NONE"];
		_com moveInCommander _veh;
	} else {
		private _pos = _position findEmptyPosition [1,30,"B_G_Van_01_transport_F"];
		private _vehicleData = [_pos, 0,"B_G_Van_01_transport_F", side_blue] call bis_fnc_spawnvehicle;
		private _camion = _vehicleData select 0;
		_grupo = _vehicleData select 2;
		_grupo setVariable ["staticAutoT",false,true];

		private _piece = ([_squadType] call AS_fnc_FIACustomSquad_piece) createVehicle (_position findEmptyPosition [1,30,"B_G_Van_01_transport_F"]);
		private _morty = _grupo createUnit [["Crew"] call AS_fnc_getFIAUnitClass, _position findEmptyPosition [1,30,"B_G_Van_01_transport_F"], [], 0, "NONE"];

		if (_squadType == "Mobile Mortar") then {
			_morty moveInGunner _piece;
			_piece setVariable ["attachPoint", [0,-1.5,0.54]];
			[_morty,_camion,_piece] spawn AS_fnc_activateMortarCrewOnTruck;
		} else {
			_piece attachTo [_camion,[0,-2.4,-0.6]];
			_piece setDir (getDir _camion + 180);
			_morty moveInGunner _piece;
		};
		[_camion, "FIA"] call AS_fnc_initVehicle;
		[_piece, "FIA"] call AS_fnc_initVehicle;
	};
	_grupo
};

// Equipment unlocked by default
unlockedWeapons = [
		// Binoculars
	"Rangefinder",
	"Binocular",
		// Launchers
	"rhs_weap_rpg7", // << RPG-7
	"rhs_weap_fim92", // << Stinger Platform 
	"tf47_smaw", // << SMAW
	"tf47_m3maaws", // << MAAWS
		// Sidearms
	"rhs_weap_makarov_pm", // << Mak PM
	"rhs_weap_pb_6p9", // << 6P9 
	"rhs_weap_pya", // << Grach MP-443
	"rhsusf_weap_m1911a1", // << M1911
	"rhs_weap_pp2000_folded", // << PP2000 
	"rhs_weap_savz61", // << Vz. 61
		// Rifles/Primaries
	"rhs_weap_m24sws", // << M24 SWS 
	"rhs_weap_m38_rail", // << Mosin (rail) 
	"rhs_weap_kar98k", // << Kar98K
	"rhs_weap_akms", // << AKMS
	"rhs_weap_pkm", // << PKM
	"rhs_weap_akm_zenitco01_b33", // << AKM Zenitco Furniture
	"rhs_weap_aks74u", // << AKS74U
	"rhs_weap_m70b1n", // << M70B
	"rhs_weap_m16a4", // << M16A4
	"rhs_weap_M590_8RD", // << 8RND Shotgun
	"rhs_weap_M590_5RD", // << 5RND Shotgun
	"rhs_weap_MP44", // << MP44
	"rhs_weap_m3a1", // << Grease Gun
	"rhs_weap_m3a1_specops", // << Grease Gun (special)
	"rhs_weap_m1garand_sa43", // << M1 Garand
	"hlc_rifle_aks74", // << AKS74 
	"hlc_rifle_g3a3v", // << G3 
	"hlc_rifle_g3a3ris", // << G3 RIS 
	"hlc_rifle_M14_Bipod_Rail", // << M14 Bipod 
	"hlc_rifle_FAL5000Rail", // << FAL PARA 
	"hlc_rifle_FAL5061Rail" // << FAL 

];

unlockedMagazines = [
		// Sidearm ammo
	"rhsusf_mag_7x45acp_MHP", // << M1911 Mag
	"rhs_mag_9x19mm_7n21_20", // << 20rd PP2000
	"rhs_mag_9x18_8_57N181S", // << PM Mag
	"rhs_mag_9x19_17", // << Grach Mag
	"rhsgref_20rnd_765x17_vz61", // << Vz. 61 20rd Mag
		// Rifle Ammo
	"rhsgref_5Rnd_762x54_m38", // << Mosin Ammo
	"rhsusf_5Rnd_762x51_M993_Mag", // << SWS AP Mag
	"rhsgref_5Rnd_792x57_kar98k", // << Kar98K Ammo
	"rhsgref_8Rnd_762x63_M2B_M1rifle", // << M1 Garand Enblock
	"rhs_100Rnd_762x54mmR_green", // << PKM Box (Tracer)
	"rhs_100Rnd_762x54mmR", // << PKM Box
	"rhsgref_30rnd_792x33_SmE_StG", // << 30rd MP44 Mag
	"rhsgref_30rnd_1143x23_M1911B_SMG", // << Grease Gun Mag
	"rhsgref_30rnd_1143x23_M1911B_2mag_SMG", // << Grease Gun Jungle Mag
	"rhs_30Rnd_545x39_AK", // <<  30rd AK 5.45x39
	"rhs_30Rnd_762x39mm", // << 30rd AK 7.62x39	
	"rhs_mag_30Rnd_556x45_M855_Stanag_Tracer_Green", // << 5.56 M855 STANAG (Tracer)
	"rhs_mag_30Rnd_556x45_M855_Stanag", // << 5.56 M855 STANAG
	"hlc_20rnd_762x51_b_G3", // << 20rd EPR G3 
	"hlc_50rnd_762x51_M_G3", // << 50rd (Tracers 4) G3
	"hlc_20rnd_762x51_B_M14", // << 20rd EPR M14
	"hlc_20rnd_762x51_T_M14", // << 20rd Tracer M14 
	"hlc_20rnd_762x51_T_fal", // << 20rd Tracer FAL 
	"hlc_20rnd_762x51_B_fal," // << 20rd EPR FAL
		// Shot Shells
	"rhsusf_8Rnd_00Buck", // <<  8rd 00 Buck 
	"rhsusf_5Rnd_00Buck", // << 5rd 00 Buck 
	"rhsusf_8Rnd_Slug", // << 8rd Slug
	"rhsusf_5Rnd_Slug", // << 5rd Slug
		// Launcher Ammo
	"rhs_rpg7_PG7V_mag", // << PG7V (RPG Basic HEAT)
	"rhs_rpg7_PG7VL_mag", // << PG7-VL (RPG Improved HEAT) 
	"rhs_rpg7_OG7V_mag", // << OG7V (RPG Frag)
	"rhs_rpg7_PG7VR_mag", // << PG7VR (Tandem HEAT)
	"rhs_rpg7_TBG7V_mag", // << TBG7V (RPG Thermobaric)
	"rhs_weap_fim92_mag", // << Stinger Missile 
	"tf47_smaw_HEAA", // << SMAW HEAA
	"tf47_smaw_HEDP", // <<  SMAW HEDP
	"tf47_m3maaws_HE", // << Maaws HE 
	"tf47_m3maaws_HEAT", // << Maaws HEAT 
	"tf47_m3maaws_SMOKE", // << Maaws SMOKE 
	"tf47_m3maaws_ILLUM", // << Maaws Flare
		// Grenades
	"rhs_mag_rgd5", // << RGD 5
	"rhs_mag_rdg2_white" // << RGD2 Smoke

];

unlockedItems = unlockedItems + [
		//Items
	"ToolKit",
	"Chemlight_Green",
	"SmokeShell",
	"SmokeShellGreen",
	"SmokeShellPurple",
	"IEDUrbanBig_Remote_Mag",
	"IEDUrbanSmall_Remote_Mag",
		//Accessories
	"rhs_acc_pgs64_74u", // << AKS-74UN muzzle attachment
	"rhs_acc_dtk", // << default AK74 muzzle attachment
	"optic_KHS_blk", // << Kahlia Black
	"optic_KHS_old", // << Kahlia Old
	"optic_DMS", // << DMS
	"rhsusf_acc_grip2", // << AFG
	"rhs_acc_2dpZenit", // <<2DP Flashlight
	"rhs_acc_2dpZenit_ris", // <<2DP Flashlight RIS 
	"sma_sffl_blk", // << Surefire Flashlight
	"sma_eotech552", // << Eotech
	"sma_eotech552_3xdown", // << Eotech + 3x Magnifier
	"rhs_acc_harris_swivel", // << Harris Bipod
		//Clothing
	"U_BG_Guerilla1_1",
	"U_BG_Guerilla2_1",
	"U_BG_Guerilla2_2",
	"U_BG_Guerilla2_3",
	"U_BG_Guerilla3_1",
	"U_BG_Guerilla3_2",
	"U_BG_leader",
	"H_Booniehat_khk",
	"H_Booniehat_oli",
	"H_Booniehat_grn",
	"H_Booniehat_dirty",
	"H_Cap_oli",
	"H_Cap_blk",
	"H_MilCap_rucamo",
	"H_MilCap_gry",
	"H_BandMask_blk",
	"H_Bandanna_khk",
	"H_Bandanna_gry",
	"H_Bandanna_camo",
	"H_Shemag_khk",
	"H_Shemag_tan",
	"H_Shemag_olive",
	"H_ShemagOpen_tan",
	"H_Beret_grn",
	"H_Beret_grn_SF",
	"H_Watchcap_camo",
	"H_TurbanO_blk",
	"H_Hat_camo",
	"H_Hat_tan",
	"H_Beret_blk",
	"H_Beret_red",
	"H_Beret_02",
	"H_Watchcap_khk",
	"G_Balaclava_blk",
	"G_Balaclava_combat",
	"G_Balaclava_lowprofile",
	"G_Balaclava_oli",
	"G_Bandanna_blk",
	"G_Tactical_Black",
	"G_Aviator",
	"G_Shades_Black",
	"U_C_Poloshirt_blue",
	"U_C_Poloshirt_burgundy",
	"U_C_Poloshirt_salmon",
	"U_C_Poloshirt_tricolour",
	"U_C_Poor_1",
	"U_Rangemaster",
	"U_NikosBody",
	"U_IG_Guerilla3_2",
	"U_OG_Guerilla2_1",
	"U_IG_Guerilla1_1",
	"U_I_G_Story_Protagonist_F",
	"U_I_G_resistanceLeader_F",
	"U_C_Poloshirt_blue",
	"U_C_Poloshirt_burgundy",
	"U_C_Poloshirt_stripped",
	"U_C_Poloshirt_tricolour",
	"U_C_Poloshirt_salmon",
	"U_C_Poloshirt_redwhite",
	"U_C_Commoner1_1",
	"U_C_Commoner1_2",
	"U_C_Commoner1_3",
	"U_Rangemaster",
	"U_NikosBody",
	"U_C_Poor_1",
	"U_C_Poor_2",
	"U_C_WorkerCoveralls",
	"U_C_Poor_shorts_1",
	"U_C_Commoner_shorts",
	"U_C_ShirtSurfer_shorts",
	"U_C_TeeSurfer_shorts_1",
	"U_C_TeeSurfer_shorts_2",
	"U_BG_Guerrilla_6_1",
	"U_B_survival_uniform",
	"U_OrestesBody",
	"V_Chestrig_blk",
	"V_Chestrig_rgr",
	"V_TacChestrig_grn_F",
	"V_TacVest_oli",
	"V_TacVest_blk",
	"V_TacVest_blk_POLICE",
	"min_rf_beanie_black",
		//RHS 
	"rhs_vest_pistol_holster",
	"rhs_scarf",
	"rhsgref_uniform_altis_lizard",
	"rhsgref_uniform_altis_lizard_olive",
	"rhsgref_uniform_dpm",
	"rhsgref_uniform_olive",
	"rhsgref_uniform_flecktarn",
	"rhsgref_uniform_flecktarn_full",
	"rhsgref_alice_webbing",
	"rhs_vydra_3m",
	"rhsgref_helmet_pasgt_olive",
	"rhs_altyn",
	"rhs_altyn_visordown",
	"rhs_balaclava",
	"rhs_balaclava1_olive",
		// VSM
	"VSM_FAPC_Operator_OGA_OD",
	"VSM_RAV_operator_OGA_OD",
	"VSM_LBT6094_operator_OGA_OD",
	"VSM_CarrierRig_Operator_OGA_OD",
	"VSM_M81_Camo_SS",
	"M81_Camo_BDU",
	"VSM_M81_casual_Camo",
	"VSM_Beanie_Black",
	"VSM_Beanie_tan",
	"VSM_Beanie_OD",
		// /asg/ custom
	"VSM_M81_Camo_GRY_TShirt",
	"VSM_FAPC_Operator_OGA_ODBLK",
	"PU_shemagh_Gry",
	"PU_shemagh_Tan",
	"PU_shemagh_OD",
	"shemaghface_white",
	"shemaghface_tan",
	"shemaghface_od",
	"shemagh_looseod",
	"shemagh_loosetan"

];

unlockedBackpacks = [
	"B_FieldPack_oli",
	"B_FieldPack_blk",
	"B_FieldPack_ocamo",
	"B_FieldPack_oucamo",
	"B_FieldPack_cbr",
	"B_TacticalPack_blk",
	"B_TacticalPack_rgr",
	"rhs_rpg_empty",
	"rhs_assault_umbts",
	"rhs_assault_umbts_engineer_empty",
	"B_AssaultPack_dgtl",
	"VSM_M81_Backpack_Compact",
	"B_Respawn_TentDome_F",
	"B_Respawn_TentA_F",
	"B_Respawn_Sleeping_bag_F"

];
