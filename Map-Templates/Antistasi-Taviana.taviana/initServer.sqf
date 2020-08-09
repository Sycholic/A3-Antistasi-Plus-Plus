/*
 * The reason for this split, is we can't open dialog boxes during initServer in singleplayer.
 * This is an issue if we want to get params data before initialising the server.

 * So if it's singleplayer, we wait for initServer.sqf to finish (and the player to be spawned in), then get params, then load.
 */
if (isNil "logLevel") then {LogLevel = 2};

// removing post-apocalyptic stuff
_forbiddenTerrainObjects = [
    "tavi",
    "heracleum",
    "zil",
    "heli",
    "bus",
    "dead",
    "junkpile",
    "ruin",
    "zaporozec",
    "moskvic",
    "tahac",
    "prives",
    "buchanka",
    "cisterna",
    "bagbunker",
    "t34",
    "mrtvol",
    "tram",
    "tavi_p_carduus",
    "tavi_fort_barricade",
    "vetrak1"
];

_allTerainObjects = nearestTerrainObjects [[worldSize/2, worldSize/2], ["HIDE"], worldSize];

{
    _terrainObject = _x;
    _terrainObjectName = toLower(str _terrainObject);

    {
        if ((_terrainObjectName find _x) >= 0) exitWith {
            hideObjectGlobal _terrainObject;
            _terrainObject enableSimulationGlobal false;
        }
    }   forEach _forbiddenTerrainObjects;

} forEach (_allTerainObjects);

if (isMultiplayer) then {
	[] call A3A_fnc_initServer;
} else {
	[] spawn {
		waitUntil {!isNull player && player == player && !isNull (finddisplay 46)};
		[2, "Opening Singleplayer Parameter Dialog", "initServer.sqf"] call A3A_fnc_log;
		[] call A3A_fnc_createDialog_setParams;
		[2, "Proceeding to initServer", "initServer.sqf"] call A3A_fnc_log;
		[] call A3A_fnc_initServer;
	};
};