class TAG_ZdoUtil
{
	tag = "zdo_util";
	class Fns
	{
		file = "Functions\zdo\util";

		class isBackpack {};
		class serializeContainer {};
		class wipeContainerInventory {};
		class spawnTrigger {};
	};
};

class TAG_ZdoLog
{
	tag = "zdo_log";
	class Fns
	{
		file = "Functions\zdo\log";

		class write {};
		class clean {};
		class get {};
	};
};

class TAG_ZdoArsenal
{
	tag = "zdo_arsenal";
	class Fns
	{
		file = "Functions\zdo\arsenal";

		class gatherLoot {};
		class init {};
		class makeArsenal {};
		class makeArsenalGlobal {};
		class makeWishbox {};
		class makeWishboxGlobal {};
	};
};

class TAG_ZdoFlag
{
	tag = "zdo_flag";
	class Fns
	{
		file = "Functions\zdo\flag";

		class init {};
	};
};

class TAG_ZdoFortify
{
	tag = "zdo_fortify";
	class Fns
	{
		file = "Functions\zdo\fortify";

		class initPlayerLocal {};
		class initServer {};
	};
};

class TAG_ZdoPersistEditor
{
	tag = "zdo_persist_editor";
	class Fns
	{
		file = "Functions\zdo\persist_editor";

		class appendInitGlobalAttribute {};
		class appendInitServerAttribute {};
		class createMapLoader {};
		class createMarkedObjectWithZdoVariables {};
		class createTerrainObjectsDestroyer {};
		class loadAll {};
		class loadAllFromProfile {};
		class loadMines {};
		class loadObject {};
		class loadUnits {};
		class vecDirUpToXyzRotation {};
	};
};

class TAG_ZdoPersistGame
{
	tag = "zdo_persist_game";
	class Fns
	{
		file = "Functions\zdo\persist_game";

		class deleteAllMapMarkers {};
		class getOrCreateMarkedObject {};
		class initAll {};
		class killTrackerObjectCreateSprite{};
		class killTrackerObjectCreateSprites{};
		class killTrackerObjectInit {};
		class loadPlayerInfo {};
		class pasteMapMarkers {};
		class playerInfoTrackerInit {};
		class playerInfoTrackerSaveAll {};
	};
};

class TAG_ZdoPersistSave
{
	tag = "zdo_persist_save";
	class Fns
	{
		file = "Functions\zdo\persist_save";

		class copyMapMarkers {};
		class getForcedFlagTexture {};
		class saveAll {};
		class saveAllAndShowMessage {};
		class saveAsBuilding {};
		class saveAsFlag {};
		class saveAsThing {};
		class saveAsVehicle {};
		class saveDestroyedTerrainObjects {};
		class saveMines {};
		class saveObjectIfNeeded {};
		class saveUnits {};
		class saveZdoVariables {};
		class terrainObjectsToTrack {};
	};
};

class TAG_ZdoAI
{
	tag = "zdo_ai";
	class Fns
	{
		file = "Functions\zdo\ai";

		class runArtilleryScanLoop {};
		class runLambsAssault {};
		class runLambsCamp {};
		class runLambsCreep {};
		class runLambsGarrison {};
		class runLambsHunt {};
		class runLambsPatrol {};
		class runLambsRush {};
		class runMove {};
		class runSeekAndDestroy {};
		class runSeekAndDestroyFrom {};
		class setLambsEnabled {};
	};
};

class TAG_ZdoDetect
{
	tag = "zdo_detect";
	class Fns
	{
		file = "Functions\zdo\detect";

		class findGroupIdsInProximity {};
		class findNearestSignOfType {};
		class findPositionsInsideBuildings {};
		class findPositionsNearTrees {};
		class getGroupById {};
		class isAnyPlayerInProximity {};
		class pickAllObjectsOfType {};
		class pickNRandomObjectsOfType {};
		class pickOtherNRandomObjects {};
		class pickOtherObjectsOfSameType {};
		class selectNRandom {};
	};
};

class TAG_ZdoExtra
{
	tag = "zdo_extra";
	class Fns
	{
		file = "Functions\zdo\extra";

		class addAceDocument{};
		class addAceNotepad{};
		class addAcePhoto{};
		class createMapMarkers {};
		class getPrintableMapLocation {};
		class limitGroupVehicles {};
		class makeSlightlyWounded {};
		class renameUnit {};
		class spawnGroup {};
		class spawnMapPositionTracker {};
	};
};

class TAG_ZdoSign
{
	tag = "zdo_sign";
	class Fns
	{
		file = "Functions\zdo\sign";

		class armex {};
		class blueking {};
		class burstkoke {};
		class idap {};
		class ion {};
		class larkin {};
		class quontrol {};
		class redburger {};
		class redstone {};
		class sponsor {};
		class suatmm {};
		class vrana {};
	};
};

class TAG_ZdoCleanup
{
	tag = "zdo_cleanup";
	class Fns
	{
		file = "Functions\zdo\cleanup";

		class deleteAllSigns {};
		class deleteOtherLayersWithSameSignType {};
		class deleteOtherObjectsOfSameType {};
		class deleteWholeLayer {};
	};
};

class TAG_ZdoPos
{
	tag = "zdo_pos";
	class Fns
	{
		file = "Functions\zdo\pos";

		class moveGroupToPosition {};
		class moveToEmptyPosition {};
		class moveToEmptyPositionCloserToRoad {};
		class moveCarsSafeWithDelay {};
		class moveLayerObjectsAsWhole {};
		class moveLayerObjectsRandomly {};
		class moveToObject {};
		class moveLayerObjectsToSameObjectInOtherLayerNearSign {};
	};
};

class TAG_ZdoPersistentGroupId
{
	tag = "zdo_persistent_group_id";
	class Fns
	{
		file = "Functions\zdo\persistent_group_id";

		class create {};
		class getGroup {};
	};
};
