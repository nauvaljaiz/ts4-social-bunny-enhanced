package widgets.BuildBuy.data
{
   import gamedata.BuildBuy.constants.FilterCategories;
   import gamedata.BuildBuy.constants.ProductTypes;
   import gamedata.GameContent;
   import olympus.controls.objects.MenuItem;
   import olympus.localization.Keys;
   import olympus.localization.KeysBB;
   import olympus.utils.TuningTagsUtils;
   import scaleform.clik.data.DataProvider;
   import widgets.BuildBuy.constants.Icons;
   import widgets.BuildBuy.constants.LotLevelHeights;
   import widgets.BuildBuy.constants.ProductStateUsage;
   
   public final class CatalogData
   {
      
      public static var ROOM_CATEGORIES:DataProvider;
      
      public static var MAGALOG_ROOM_CATEGORIES:Array;
      
      public static var EMPTY_BLOCK_CATEGORY:MenuItem;
      
      public static var INVENTORY_ALL:Array;
      
      public static var FUNCTION_ALL:Array;
      
      public static var BUY_CATEGORIES:Array;
      
      public static var FUNCTION_VENUE:Array;
      
      public static var FUNCTION_HOLIDAY:Array;
      
      public static var FUNCTION_REQUIREMENTS_ITEM:MenuItem;
      
      public static var INVENTORY_CATEGORIES:Array;
      
      public static var FUNCTION_CATEGORIES:Array;
      
      public static var FUNCTION_CATEGORIES_VENUE:Array;
      
      public static var FUNCTION_CATEGORIES_HOLIDAY:Array;
      
      public static var FUNCTION_CATEGORIES_SMALL_BUSINESS:Array;
      
      public static var OUTDOOR_CATEGORIES:DataProvider;
      
      public static var TERRAIN_PAINT_CATEGORIES:DataProvider;
      
      public static var TERRAIN_MANIP_CATEGORIES:DataProvider;
      
      public static var POND_CATEGORIES:DataProvider;
      
      public static var FLOOR_PATTERN_FILTERS:DataProvider;
      
      public static var WALL_PATTERN_FILTERS:DataProvider;
      
      public static var POOL_AND_FOUNTAIN_FILTERS:DataProvider;
      
      public static var OUTDOOR_WATER_FILTERS:DataProvider;
      
      public static var OBJECTS_BY_FUNCTION_FILTERS:DataProvider;
      
      public static var BLOCK_FILTERS:DataProvider;
      
      public static var STAIRS_FILTERS:DataProvider;
      
      public static const CONTENT_FILTERS:Array = [new MenuItem(Keys.FILTER_PANEL_UNLOCKS.toString(),{"filterByGameplayUnlocks":true}),new MenuItem(Keys.FILTER_PANEL_MTX.toString(),{"filterPurchasedProducts":true})];
      
      public static const CONTENT_FILTER_MODS:MenuItem = new MenuItem(Keys.FILTER_PANEL_MODS.toString(),{"filterModdedContent":true});
      
      public static const CONTENT_FILTER_HIDDEN:MenuItem = new MenuItem(Keys.FILTER_PANEL_HIDDEN.toString(),{"filterHiddenObjects":true});
      
      public static const COUNTER_SHAPES:Array = [new MenuItem(null,1,true,null,KeysBB.BB_COUNTER_SHAPE_LEFT_END.toString()),new MenuItem(null,0,true,null,KeysBB.BB_COUNTER_SHAPE_TILE.toString()),new MenuItem(null,2,true,null,KeysBB.BB_COUNTER_SHAPE_RIGHT_END.toString()),new MenuItem(null,3,true,null,KeysBB.BB_COUNTER_SHAPE_OUTER.toString()),new MenuItem(null,4,true,null,KeysBB.BB_COUNTER_SHAPE_INNER.toString())];
      
      public static const ISLAND_COUNTER_SHAPES:Array = [new MenuItem(null,1,true,null,KeysBB.BB_COUNTER_SHAPE_LEFT_END.toString()),new MenuItem(null,0,true,null,KeysBB.BB_COUNTER_SHAPE_TILE.toString()),new MenuItem(null,2,true,null,KeysBB.BB_COUNTER_SHAPE_RIGHT_END.toString()),new MenuItem(null,5,true,null,KeysBB.BB_COUNTER_SHAPE_ROUNDED_OUTER.toString()),new MenuItem(null,3,true,null,KeysBB.BB_COUNTER_SHAPE_OUTER.toString()),new MenuItem(null,6,true,null,KeysBB.BB_COUNTER_SHAPE_ROUNDED_INNER.toString()),new MenuItem(null,4,true,null,KeysBB.BB_COUNTER_SHAPE_INNER.toString())];
      
      public static const CABINET_SHAPES:Array = [new MenuItem(null,6,true,null,KeysBB.BB_COUNTER_SHAPE_LEFT_END.toString()),new MenuItem(null,0,true,null,KeysBB.BB_COUNTER_SHAPE_TILE.toString()),new MenuItem(null,5,true,null,KeysBB.BB_COUNTER_SHAPE_RIGHT_END.toString()),new MenuItem(null,3,true,null,KeysBB.BB_COUNTER_SHAPE_OUTER.toString()),new MenuItem(null,4,true,null,KeysBB.BB_COUNTER_SHAPE_INNER.toString()),new MenuItem(null,1,true,null,KeysBB.BB_COUNTER_SHAPE_DOUBLE_TILE.toString()),new MenuItem(null,2,true,null,KeysBB.BB_COUNTER_SHAPE_HALF_TILE.toString())];
      
      public static const SIT_SECTIONAL_SHAPES:Array = [new MenuItem(null,4,true,null,KeysBB.BB_SITSECTIONAL_SHAPE_END_WEST.toString()),new MenuItem(null,0,true,null,KeysBB.BB_SITSECTIONAL_SHAPE_TILE.toString()),new MenuItem(null,3,true,null,KeysBB.BB_SITSECTIONAL_SHAPE_END_EAST.toString()),new MenuItem(null,2,true,null,KeysBB.BB_SITSECTIONAL_SHAPE_OUTER.toString()),new MenuItem(null,1,true,null,KeysBB.BB_SITSECTIONAL_SHAPE_INNER.toString()),new MenuItem(null,5,true,null,KeysBB.BB_SITSECTIONAL_SHAPE_SINGLE.toString()),new MenuItem(null,6,true,null,KeysBB.BB_SITSECTIONAL_SHAPE_FLAT.toString()),new MenuItem(null,7,true,null,KeysBB.BB_SITSECTIONAL_SHAPE_LARGE_INNER.toString())];
      
      public static const SIT_LOUNGE_CHAISE_SHAPES:Array = [new MenuItem(null,0,true,null,KeysBB.BB_SITLOUNGECHAISE_SHAPE_TILE.toString()),new MenuItem(null,1,true,null,KeysBB.BB_SITLOUNGECHAISE_SHAPE_END_EAST.toString()),new MenuItem(null,2,true,null,KeysBB.BB_SITLOUNGECHAISE_SHAPE_END_WEST.toString()),new MenuItem(null,3,true,null,KeysBB.BB_SITLOUNGECHAISE_SHAPE_SINGLE.toString())];
      
      public static const BED_BUNK_SHAPES:Array = [new MenuItem(null,0,true,null,KeysBB.BB_BEDBUNK_SHAPE_BOTH.toString()),new MenuItem(null,1,true,null,KeysBB.BB_BEDBUNK_SHAPE_EAST.toString()),new MenuItem(null,2,true,null,KeysBB.BB_BEDBUNK_SHAPE_WEST.toString())];
      
      public static const AUTO_SHAPE_SETTING_DEFAULT:MenuItem = new MenuItem(KeysBB.BB_NAVIGATION_COUNTER_MODE.toString(),{
         "stateUsage":ProductStateUsage.COUNTER,
         "settingsFlag":"BBIsCounterSelectionManual",
         "tooltipManual":KeysBB.BB_COUNTER_TOOLTIP_COUNTER_MANUAL_PLACE,
         "tooltipAuto":KeysBB.BB_COUNTER_TOOLTIP_COUNTER_AUTO_PLACE
      });
      
      public static const AUTO_SHAPE_SETTING_SOFA:MenuItem = new MenuItem(KeysBB.BB_NAVIGATION_SOFA_MODE.toString(),{
         "stateUsage":ProductStateUsage.SIT_SECTIONAL,
         "settingsFlag":"BBIsSofaSelectionManual",
         "tooltipManual":KeysBB.BB_COUNTER_TOOLTIP_SOFA_MANUAL_PLACE,
         "tooltipAuto":KeysBB.BB_COUNTER_TOOLTIP_SOFA_AUTO_PLACE
      });
      
      public static const AUTO_SHAPE_SETTING_BED_BUNK:MenuItem = new MenuItem(KeysBB.BB_NAVIGATION_BED_BUNK_MODE.toString(),{
         "stateUsage":ProductStateUsage.BED_BUNK,
         "settingsFlag":"BBIsBedBunkSelectionManual",
         "tooltipManual":KeysBB.BB_COUNTER_TOOLTIP_BED_BUNK_MANUAL_PLACE,
         "tooltipAuto":KeysBB.BB_COUNTER_TOOLTIP_BED_BUNK_AUTO_PLACE
      });
      
      public static const FUNCTION_COMFORT_INDEX:int = 1;
      
      public static const FUNCTION_PETS_INDEX:int = 5;
      
      public static var FUNCTION_SMALL_BUSINESS_INDEX:int = 0;
      
      public static var FUNCTION_VENUE_INDEX:int = 11;
      
      public static var FUNCTION_HOLIDAY_INDEX:int = 11;
      
      public static const FUNCTION_SHOWALL_INDEX:int = 0;
      
      public static const WINDOW_HEIGHT_FILTERS:Array = [new MenuItem(null,LotLevelHeights.ALL,true,null,Keys.GENERIC_SHOW_ALL.toString()),new MenuItem(null,LotLevelHeights.SHORT,true,null,KeysBB.BB_CATALOG_TOOLTIP_WALLHEIGHT_FILTERSHORT_WINDOWS.toString()),new MenuItem(null,LotLevelHeights.MEDIUM,true,null,KeysBB.BB_CATALOG_TOOLTIP_WALLHEIGHT_FILTERMEDIUM_WINDOWS.toString()),new MenuItem(null,LotLevelHeights.TALL,true,null,KeysBB.BB_CATALOG_TOOLTIP_WALLHEIGHT_FILTERTALL_WINDOWS.toString())];
      
      public static const DOOR_HEIGHT_FILTERS:Array = [new MenuItem(null,LotLevelHeights.ALL,true,null,Keys.GENERIC_SHOW_ALL.toString()),new MenuItem(null,LotLevelHeights.SHORT,true,null,KeysBB.BB_CATALOG_TOOLTIP_WALLHEIGHT_FILTERSHORT_DOORS.toString()),new MenuItem(null,LotLevelHeights.MEDIUM,true,null,KeysBB.BB_CATALOG_TOOLTIP_WALLHEIGHT_FILTERMEDIUM_DOORS.toString()),new MenuItem(null,LotLevelHeights.TALL,true,null,KeysBB.BB_CATALOG_TOOLTIP_WALLHEIGHT_FILTERTALL_DOORS.toString())];
      
      public static const FRIEZES_FILTERS:DataProvider = new DataProvider([new MenuItem(KeysBB.BB_FILTER_BUILD_FRIEZES.toString(),{"productType":ProductTypes.FRIEZE},true,[Icons.ICON_SUB_FILTER_FRIEZE,Icons.ICON_SUB_FILTER_FRIEZE_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_FLOOR_TRIMS.toString(),{"productType":ProductTypes.FLOOR_TRIM},true,[Icons.ICON_SUB_FILTER_FLOORTRIM,Icons.ICON_SUB_FILTER_FLOORTRIM_SELECTED])]);
      
      public function CatalogData()
      {
         super();
      }
      
      public static function Create() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MenuItem = null;
         var _loc3_:MenuItem = null;
         if(ROOM_CATEGORIES)
         {
            return;
         }
         ROOM_CATEGORIES = new DataProvider([new MenuItem(KeysBB.BB_FILTER_ROOM_KITCHEN.toString(),{
            "frameLabel":"kitchen",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "telemetryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_KITCHEN)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_KITCHEN_SMALL),new MenuItem(KeysBB.BB_FILTER_ROOM_BATH.toString(),{
            "frameLabel":"bath",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "telemetryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_BATHROOM)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_BATH_SMALL),new MenuItem(KeysBB.BB_FILTER_ROOM_BEDROOM.toString(),{
            "frameLabel":"bed",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "telemetryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_BEDROOM)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_BED_SMALL),new MenuItem(KeysBB.BB_FILTER_ROOM_LIVING.toString(),{
            "frameLabel":"living",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "telemetryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_LIVINGROOM)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_LIVING_SMALL),new MenuItem(KeysBB.BB_FILTER_ROOM_DINING.toString(),{
            "frameLabel":"dining",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "telemetryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_DINNINGROOM)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_DINING_SMALL),new MenuItem(KeysBB.BB_FILTER_ROOM_STUDY.toString(),{
            "frameLabel":"study",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "telemetryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_STUDY)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_STUDY_SMALL),new MenuItem(KeysBB.BB_FILTER_ROOM_KIDS.toString(),{
            "frameLabel":"kids",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "telemetryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_MISC)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_KIDS_SMALL),new MenuItem(KeysBB.BB_FILTER_ROOM_OUTDOOR.toString(),{
            "frameLabel":"outdoor",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "telemetryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_OUTDOOR)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_OUTDOOR_SMALL)]);
         MAGALOG_ROOM_CATEGORIES = [new MenuItem(KeysBB.BB_FILTER_ROOM_ALL.toString(),{
            "frameLabel":"all",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[],
            "categoryPriorityTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_MAGALOG)
         },true,Icons.ANIMATED_ICON_ROOM_ALL),new MenuItem(KeysBB.BB_FILTER_ROOM_KITCHEN.toString(),{
            "frameLabel":"kitchen",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_KITCHEN)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_KITCHEN),new MenuItem(KeysBB.BB_FILTER_ROOM_BATH.toString(),{
            "frameLabel":"bath",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_BATHROOM)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_BATH),new MenuItem(KeysBB.BB_FILTER_ROOM_BEDROOM.toString(),{
            "frameLabel":"bed",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_BEDROOM)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_BED),new MenuItem(KeysBB.BB_FILTER_ROOM_LIVING.toString(),{
            "frameLabel":"living",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_LIVINGROOM)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_LIVING),new MenuItem(KeysBB.BB_FILTER_ROOM_DINING.toString(),{
            "frameLabel":"dining",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_DINNINGROOM)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_DINING),new MenuItem(KeysBB.BB_FILTER_ROOM_STUDY.toString(),{
            "frameLabel":"study",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_STUDY)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_STUDY),new MenuItem(KeysBB.BB_FILTER_ROOM_KIDS.toString(),{
            "frameLabel":"kids",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_KIDS)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_KIDS),new MenuItem(KeysBB.BB_FILTER_ROOM_OUTDOOR.toString(),{
            "frameLabel":"outdoor",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_OUTDOOR)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_OUTDOOR),new MenuItem(KeysBB.BB_FILTER_ROOM_CAREER.toString(),{
            "frameLabel":"career",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_CAREER)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_CAREER),new MenuItem(KeysBB.BB_FILTER_MISCELLANEOUS.toString(),{
            "frameLabel":"misc",
            "productType":ProductTypes.MAGAZINECOLLECTION,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_MAG_MISC)],
            "categoryPriorityTags":[]
         },true,Icons.ANIMATED_ICON_ROOM_MISC)];
         EMPTY_BLOCK_CATEGORY = new MenuItem(KeysBB.BB_FILTER_ROOM_EMPTY.toString(),{
            "productType":ProductTypes.BLOCK,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BLOCK),TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BLOCK_WALLTOOL)],
            "categoryPriorityTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_BLOCK_SORT)
         },true,Icons.ANIMATED_ICON_ROOM_EMPTY);
         INVENTORY_ALL = [new MenuItem(Keys.GENERIC_SHOW_ALL.toString(),{"categoryTags":[]},true)];
         FUNCTION_ALL = [new MenuItem(Keys.GENERIC_SHOW_ALL.toString(),{
            "frameLabel":"showAll",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_FUNCTION_ALL),
            "categoryPriorityTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_FUNCTION_ALL_SORT)
         },true)];
         BUY_CATEGORIES = [new MenuItem(KeysBB.BB_FILTER_BUY_COMFORT.toString(),{
            "frameLabel":"comfort",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_COMFORT)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_SURFACES.toString(),{
            "frameLabel":"surfaces",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_SURFACES)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_PLUMBING.toString(),{
            "frameLabel":"plumbing",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_PLUMBING)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_ENTERTAINMENT.toString(),{
            "frameLabel":"entertainment",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_ENTERTAINMENT)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_DECOR.toString(),{
            "frameLabel":"decorations",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_DECORATION)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_KIDS.toString(),{
            "frameLabel":"kids",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_KIDS)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_LIGHTING.toString(),{
            "frameLabel":"lighting",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_LIGHTING)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_ELECTRONICS.toString(),{
            "frameLabel":"electronics",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_ELECTRONICS)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_APPLIANCES.toString(),{
            "frameLabel":"appliances",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_APPLIANCES)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_STORAGE.toString(),{
            "frameLabel":"storage",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_STORAGE)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_OFFTHEGRID.toString(),{
            "frameLabel":"offthegrid",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_OFFTHEGRID)
         },true),new MenuItem(KeysBB.BB_FILTER_BUY_WATERFEATURES.toString(),{
            "frameLabel":"waterfeatures",
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_WATERFEATURES)
         },true)];
         if(GameContent.HAS_EP04 || GameContent.HAS_EP14)
         {
            BUY_CATEGORIES.splice(FUNCTION_PETS_INDEX,0,new MenuItem(KeysBB.BB_FILTER_BUY_PETS.toString(),{
               "frameLabel":"pets",
               "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_PET_ALL)
            },true));
         }
         if(GameContent.HAS_EP07 || GameContent.HAS_EP08 || GameContent.HAS_EP13 || GameContent.HAS_EP18)
         {
            _loc1_ = int(BUY_CATEGORIES.length);
            _loc2_ = new MenuItem(KeysBB.BB_FILTER_BUY_TRANSPORTATION.toString(),{
               "frameLabel":"transportation",
               "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_TRANSPORTATION)
            },true);
            BUY_CATEGORIES.splice(_loc1_,0,_loc2_);
         }
         FUNCTION_VENUE = [new MenuItem(KeysBB.BB_FILTER_BUY_VENUE.toString(),{
            "frameLabel":"venue",
            "categoryTags":[]
         })];
         FUNCTION_REQUIREMENTS_ITEM = new MenuItem(KeysBB.BB_FILTER_BUY_REQUIREMENTS.toString(),{
            "frameLabel":"requirements",
            "categoryTags":[]
         });
         INVENTORY_CATEGORIES = INVENTORY_ALL.concat(MenuItem.CloneArray(BUY_CATEGORIES));
         FUNCTION_CATEGORIES = FUNCTION_ALL.concat(BUY_CATEGORIES);
         FUNCTION_VENUE_INDEX = FUNCTION_CATEGORIES.length;
         FUNCTION_CATEGORIES_VENUE = FUNCTION_CATEGORIES.concat(FUNCTION_VENUE);
         if(GameContent.HAS_EP05)
         {
            FUNCTION_HOLIDAY = [new MenuItem(KeysBB.BB_FILTER_BUY_HOLIDAY.toString(),{
               "frameLabel":"holiday",
               "categoryTags":[]
            })];
            FUNCTION_HOLIDAY_INDEX = FUNCTION_CATEGORIES.length;
            FUNCTION_CATEGORIES_HOLIDAY = FUNCTION_CATEGORIES.concat(FUNCTION_HOLIDAY);
         }
         if(GameContent.HAS_EP18)
         {
            _loc3_ = new MenuItem(KeysBB.BB_FILTER_BUY_SMALL_BUSINESS.toString(),{
               "frameLabel":"smallbusiness",
               "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUYGROUP_SMALL_BUSINESS_ALL)
            },true);
            FUNCTION_SMALL_BUSINESS_INDEX = FUNCTION_CATEGORIES.length;
            FUNCTION_CATEGORIES_SMALL_BUSINESS = FUNCTION_CATEGORIES.concat(_loc3_);
         }
         OUTDOOR_CATEGORIES = new DataProvider([new MenuItem(KeysBB.BB_FILTER_BUILD_TREE.toString(),{
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_TREE)],
            "categoryPriorityTags":[]
         },true,[Icons.ICON_OUTDOOR_TREES,Icons.ICON_OUTDOOR_TREES_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_SHRUB.toString(),{
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_SHRUB)],
            "categoryPriorityTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_SHRUBS_SORT)
         },true,[Icons.ICON_OUTDOOR_BUSHES,Icons.ICON_OUTDOOR_BUSHES_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_FLOWER.toString(),{
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_FLOWER)],
            "categoryPriorityTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_FLOWERS_SORT)
         },true,[Icons.ICON_OUTDOOR_FLOWERS,Icons.ICON_OUTDOOR_FLOWERS_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_ROCK.toString(),{
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_ROCK)],
            "categoryPriorityTags":[]
         },true,[Icons.ICON_OUTDOOR_ROCKS,Icons.ICON_OUTDOOR_ROCKS_SELECTED]),new MenuItem(Keys.GENERIC_SHOW_ALL.toString(),{
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_OUTDOOR),
            "categoryPriorityTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_OUTDOOR_SORT)
         },true,[Icons.ICON_BUILDCATEGORY_ALL,Icons.ICON_BUILDCATEGORY_ALL_SELECTED])]);
         TERRAIN_PAINT_CATEGORIES = new DataProvider([new MenuItem(KeysBB.BB_TERRAIN_PAINT_GRASS.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.TERRAIN_PAINT_GRASS)]},true,[Icons.ICON_FLOORPATTERN_OUTDOOR,Icons.ICON_FLOORPATTERN_OUTDOOR_SELECTED]),new MenuItem(KeysBB.BB_TERRAIN_PAINT_STONE.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.TERRAIN_PAINT_STONE)]},true,[Icons.ICON_FLOORPATTERN_STONE,Icons.ICON_FLOORPATTERN_STONE_SELECTED]),new MenuItem(KeysBB.BB_TERRAIN_PAINT_DIRT.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.TERRAIN_PAINT_DIRT)]},true,[Icons.ICON_TERRAINPAINT_DIRT,Icons.ICON_TERRAINPAINT_DIRT_SELECTED]),new MenuItem(Keys.GENERIC_SHOW_ALL.toString(),{"categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_TERRAIN_PAINT)},true,[Icons.ICON_BUILDCATEGORY_ALL,Icons.ICON_BUILDCATEGORY_ALL_SELECTED])]);
         TERRAIN_MANIP_CATEGORIES = new DataProvider([new MenuItem(Keys.GENERIC_SHOW_ALL.toString(),{},true,[Icons.ICON_BUILDCATEGORY_ALL,Icons.ICON_BUILDCATEGORY_ALL_SELECTED])]);
         POND_CATEGORIES = new DataProvider([new MenuItem(Keys.GENERIC_SHOW_ALL.toString(),{},true,[Icons.ICON_BUILDCATEGORY_ALL,Icons.ICON_BUILDCATEGORY_ALL_SELECTED])]);
         FLOOR_PATTERN_FILTERS = new DataProvider([new MenuItem(KeysBB.BB_FILTER_FLOORPATTERN_WOOD.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.FLOORPATTERN_WOOD)]},true,[Icons.ICON_FLOORPATTERN_WOOD,Icons.ICON_FLOORPATTERN_WOOD_SELECTED]),new MenuItem(KeysBB.BB_FILTER_FLOORPATTERN_CARPET.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.FLOORPATTERN_CARPET)]},true,[Icons.ICON_FLOORPATTERN_CARPET,Icons.ICON_FLOORPATTERN_CARPET_SELECTED]),new MenuItem(KeysBB.BB_FILTER_FLOORPATTERN_TILE.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.FLOORPATTERN_TILE)]},true,[Icons.ICON_FLOORPATTERN_TILE,Icons.ICON_FLOORPATTERN_TILE_SELECTED]),new MenuItem(KeysBB.BB_FILTER_FLOORPATTERN_STONE.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.FLOORPATTERN_STONE)]},true,[Icons.ICON_FLOORPATTERN_STONE,Icons.ICON_FLOORPATTERN_STONE_SELECTED]),new MenuItem(KeysBB.BB_FILTER_FLOORPATTERN_MASONRY
         .toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.FLOORPATTERN_MASONRY)]},true,[Icons.ICON_FLOORPATTERN_MASONRY,Icons.ICON_FLOORPATTERN_MASONRY_SELECTED]),new MenuItem(KeysBB.BB_FILTER_FLOORPATTERN_LINOLEUM.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.FLOORPATTERN_LINOLEUM)]},true,[Icons.ICON_FLOORPATTERN_LINOLEUM,Icons.ICON_FLOORPATTERN_LINOLEUM_SELECTED]),new MenuItem(KeysBB.BB_FILTER_FLOORPATTERN_METAL.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.FLOORPATTERN_METAL)]},true,[Icons.ICON_FLOORPATTERN_METAL,Icons.ICON_FLOORPATTERN_METAL_SELECTED]),new MenuItem(KeysBB.BB_FILTER_FLOORPATTERN_OUTDOOR.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.FLOORPATTERN_OUTDOOR)]},true,[Icons.ICON_FLOORPATTERN_OUTDOOR,Icons.ICON_FLOORPATTERN_OUTDOOR_SELECTED]),new MenuItem(KeysBB.BB_FILTER_MISCELLANEOUS.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories
         .FLOORPATTERN_MISC)]},true,[Icons.ICON_BUILD_MISC,Icons.ICON_BUILD_MISC_SELECTED]),new MenuItem(Keys.GENERIC_SHOW_ALL.toString(),{"categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_FLOORPATTERNS)},true,[Icons.ICON_BUILDCATEGORY_ALL,Icons.ICON_BUILDCATEGORY_ALL_SELECTED])]);
         WALL_PATTERN_FILTERS = new DataProvider([new MenuItem(KeysBB.BB_FILTER_WALLPATTERN_PAINT.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.WALLPATTERN_PAINT)]},true,[Icons.ICON_WALLPATTERN_PAINT,Icons.ICON_WALLPATTERN_PAINT_SELECTED]),new MenuItem(KeysBB.BB_FILTER_WALLPATTERN_WALLPAPER.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.WALLPATTERN_WALLPAPER)]},true,[Icons.ICON_WALLPATTERN_WALLPAPER,Icons.ICON_WALLPATTERN_WALLPAPER_SELECTED]),new MenuItem(KeysBB.BB_FILTER_WALLPATTERN_TILE.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.WALLPATTERN_TILE)]},true,[Icons.ICON_WALLPATTERN_TILE,Icons.ICON_WALLPATTERN_TILE_SELECTED]),new MenuItem(KeysBB.BB_FILTER_WALLPATTERN_PANELING.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.WALLPATTERN_PANELING)]},true,[Icons.ICON_WALLPATTERN_PANELING,Icons.ICON_WALLPATTERN_PANELING_SELECTED]),new MenuItem(KeysBB.BB_FILTER_WALLPATTERN_MASONRY
         .toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.WALLPATTERN_MASONRY)]},true,[Icons.ICON_WALLPATTERN_MASONRY,Icons.ICON_WALLPATTERN_MASONRY_SELECTED]),new MenuItem(KeysBB.BB_FILTER_WALLPATTERN_ROCKANDSTONE.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.WALLPATTERN_ROCKANDSTONE)]},true,[Icons.ICON_WALLPATTERN_ROCKANDSTONE,Icons.ICON_WALLPATTERN_ROCKANDSTONE_SELECTED]),new MenuItem(KeysBB.BB_FILTER_WALLPATTERN_SIDING.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.WALLPATTERN_SIDING)]},true,[Icons.ICON_WALLPATTERN_SIDING,Icons.ICON_WALLPATTERN_SIDING_SELECTED]),new MenuItem(KeysBB.BB_FILTER_MISCELLANEOUS.toString(),{"categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.WALLPATTERN_MISC)]},true,[Icons.ICON_BUILD_MISC,Icons.ICON_BUILD_MISC_SELECTED]),new MenuItem(Keys.GENERIC_SHOW_ALL.toString(),{"categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_WALLPATTERNS)}
         ,true,[Icons.ICON_BUILDCATEGORY_ALL,Icons.ICON_BUILDCATEGORY_ALL_SELECTED])]);
         POOL_AND_FOUNTAIN_FILTERS = new DataProvider([new MenuItem(KeysBB.BB_FILTER_BUILD_POOLTOOL.toString(),{
            "productType":ProductTypes.BLOCK,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BLOCK_POOL_TOOL),TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BLOCK_POOL)]
         },true,[Icons.ICON_POOL_BLOCKS,Icons.ICON_POOL_BLOCKS_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_POOL_TRIM.toString(),{
            "productType":ProductTypes.POOL_TRIM,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_POOL_TRIM)]
         },true,[Icons.ICON_POOL_TRIM,Icons.ICON_POOL_TRIM_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_FOUNTAIN_BLOCKS.toString(),{
            "productType":ProductTypes.BLOCK,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BLOCK_FOUNTAIN_TOOL),TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BLOCK_FOUNTAIN)]
         },true,[Icons.ICON_FOUNTAIN_BLOCKS,Icons.ICON_FOUNTAIN_BLOCKS_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_FOUNTAIN_TRIM.toString(),{
            "productType":ProductTypes.FOUNTAIN_TRIM,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_FOUNTAINTRIM)]
         },true,[Icons.ICON_FOUNTAIN_TRIM,Icons.ICON_FOUNTAIN_TRIM_SELECTED])]);
         OUTDOOR_WATER_FILTERS = new DataProvider([new MenuItem(KeysBB.BB_FILTER_BUILD_WATER_STYLES.toString(),{
            "productType":ProductTypes.FLOOR_PATTERN,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_BUILD_WATER_STYLES)]
         },true,[Icons.ICON_POOL_STYLES,Icons.ICON_POOL_STYLES_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_POND_OBJECTS.toString(),{
            "productType":ProductTypes.OBJECT,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_BUILD_POND_ITEMS)]
         },true,[Icons.ICON_POND_ITEMS,Icons.ICON_POND_ITEMS_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_FOUNTAIN_DECOR.toString(),{
            "productType":ProductTypes.OBJECT,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_BUILD_FOUNTAIN_DECOR)]
         },true,[Icons.ICON_FOUNTAIN_DECOR,Icons.ICON_FOUNTAIN_DECOR_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_POOL_OBJECTS.toString(),{
            "productType":ProductTypes.OBJECT,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_BUILD_POOL_OBJECTS)]
         },true,[Icons.ICON_POOL_OBJECTS,Icons.ICON_POOL_OBJECTS_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUY_ATTRACTORS.toString(),{
            "productType":ProductTypes.OBJECT,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUYCAT_BUILD_ATTRACTORS)]
         },true,[Icons.ICON_WATER_ATTRACTOR,Icons.ICON_WATER_ATTRACTOR_SELECTED])]);
         OBJECTS_BY_FUNCTION_FILTERS = new DataProvider([new MenuItem(KeysBB.BB_FILTER_BUILD_WATER_STYLES.toString(),{
            "productType":ProductTypes.FLOOR_PATTERN,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_FUNCTION_WATER_STYLES)]
         },true,[Icons.ICON_POOL_STYLES,Icons.ICON_POOL_STYLES_SELECTED])]);
         BLOCK_FILTERS = new DataProvider([new MenuItem(KeysBB.BB_MAGALOG_EMPTY_ROOMS.toString(),{
            "productType":ProductTypes.BLOCK,
            "categoryTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_WALLS),
            "categoryPriorityTags":TuningTagsUtils.GetGroup(FilterCategories.BUILDGROUP_BLOCK_SORT)
         },true,[Icons.ICON_BUILD_WALLS,Icons.ICON_BUILD_WALLS_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_HALFWALLS.toString(),{
            "productType":ProductTypes.WALL,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_HALFWALL)]
         },true,[Icons.ICON_BUILD_HALFWALLS,Icons.ICON_BUILD_HALFWALLS_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_HALFWALL_TRIMS.toString(),{
            "productType":ProductTypes.HALFWALL_TRIM,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_HALFWALL_TRIM)]
         },true,[Icons.ICON_BUILD_HALFWALLTRIM,Icons.ICON_BUILD_HALFWALLTRIM_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_PLATFORM_TRIMS.toString(),{
            "productType":ProductTypes.PLATFORM_TRIM,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_PLATFORM_TRIM)]
         },true,[Icons.ICON_BUILD_PLATFORMTRIM,Icons.ICON_BUILD_PLATFORMTRIM_SELECTED])]);
         STAIRS_FILTERS = new DataProvider([new MenuItem(KeysBB.BB_FILTER_BUILD_STAIRS.toString(),{
            "productType":ProductTypes.STAIR,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_STAIR)]
         },true,[Icons.ICON_BUILD_STAIRS,Icons.ICON_BUILD_STAIRS_SELECTED]),new MenuItem(KeysBB.BB_FILTER_BUILD_LADDERS.toString(),{
            "productType":ProductTypes.LADDER,
            "categoryTags":[TuningTagsUtils.GetTagValueFromHash(FilterCategories.BUILDTAG_LADDER)]
         },true,[Icons.ICON_BUILD_LADDER,Icons.ICON_BUILD_LADDER_SELECTED])]);
      }
      
      public static function GetAutoShapeSetting(param1:int) : MenuItem
      {
         if(param1 == ProductStateUsage.SIT_SECTIONAL || param1 == ProductStateUsage.CHAISE_LOUNGE)
         {
            return AUTO_SHAPE_SETTING_SOFA;
         }
         if(param1 == ProductStateUsage.BED_BUNK)
         {
            return AUTO_SHAPE_SETTING_BED_BUNK;
         }
         return AUTO_SHAPE_SETTING_DEFAULT;
      }
   }
}

