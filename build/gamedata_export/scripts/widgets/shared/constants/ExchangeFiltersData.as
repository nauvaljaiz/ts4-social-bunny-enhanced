package widgets.shared.constants
{
   import gamedata.Exchange.ExchangeData;
   import gamedata.shared.Species;
   import gamedata.shared.TattooBodyData;
   import olympus.controls.objects.MenuItem;
   import olympus.localization.KeysBB;
   import olympus.localization.KeysCAS;
   import olympus.localization.KeysConsole;
   import olympus.localization.KeysEXCH;
   import olympus.utils.SystemUtils;
   import widgets.shared.utils.SharedExchangeUtils;
   
   public class ExchangeFiltersData
   {
      
      public static const FILTERS_CHANGED:String = "share_filters_changed";
      
      public static const FILTER_SEARCH_CHANGED:String = "share_filter_search_changed";
      
      public static const FILTER_CURATOR_TYPE_CHANGED:String = "share_filters_curator_type_changed";
      
      public static const FILTER_SORT_BY_CHANGED:String = "share_filters_sort_by_changed";
      
      public static const FILTER_CATEGORY_TYPE_CHANGED:String = "share_filters_category_changed";
      
      public static const FILTER_LAYOUT_CHANGED:String = "share_filters_layout_changed";
      
      public static const ALL:int = 0;
      
      public static const DEFAULT_INCLUDE_LOCKED:Boolean = true;
      
      public static const DEFAULT_INCLUDE_MODDED:Boolean = false;
      
      public static const DEFAULT_TYPE_OPTION:int = ExchangeData.TYPE_ALL;
      
      public static const TYPE_OPTIONS:Array = [new MenuItem(KeysEXCH.FILTERS_TYPE_LABEL_ALL.toString(),ExchangeData.TYPE_ALL),new MenuItem(KeysEXCH.FILTERS_TYPE_LABEL_HOUSEHOLDS.toString(),ExchangeData.TYPE_HOUSEHOLD),new MenuItem(KeysEXCH.FILTERS_TYPE_LABEL_BLUEPRINTS.toString(),ExchangeData.TYPE_BLUEPRINT),new MenuItem(KeysEXCH.FILTERS_TYPE_LABEL_ROOMS.toString(),ExchangeData.TYPE_ROOM),new MenuItem(KeysEXCH.FILTERS_TYPE_LABEL_PARTS.toString(),ExchangeData.TYPE_BODY_PART)];
      
      public static const TYPE_OPTIONS_CG:Array = [new MenuItem(KeysEXCH.FILTERS_TYPE_LABEL_ALL.toString(),ExchangeData.TYPE_ALL),new MenuItem(KeysEXCH.FILTERS_TYPE_LABEL_BUILDER.toString(),ExchangeData.TYPE_BLUEPRINT),new MenuItem(KeysEXCH.FILTERS_TYPE_LABEL_STYLIST.toString(),ExchangeData.TYPE_HOUSEHOLD)];
      
      public static const CREATEDBY_SUBSCRIPTIONS:uint = 1;
      
      public static const CREATEDBY_GLOBAL:uint = 2;
      
      public static const CREATEDBY_MAXIS:uint = 3;
      
      public static const CREATEDBY_RECOMMENDED:uint = 4;
      
      public static const CREATEDBY_CURRENT_PLATFORM:uint = 5;
      
      public static const CREATEDBY_INVALID:uint = 10;
      
      public static const CREATEDBY_ALL:uint = 11;
      
      public static const CREATEDBY_MINE_ONLY:uint = 12;
      
      public static const CREATEDBY_OTHERS:uint = 13;
      
      public static const TAB_INDEX_CREATIONS:uint = 0;
      
      public static const TAB_INDEX_FAVORITES:uint = 1;
      
      public static const PACK_DD_SHOW_ALL:int = int.MAX_VALUE - 1;
      
      public static const PACK_DD_SHOW_OWNED:int = int.MAX_VALUE - 2;
      
      public static const PACK_DD_SHOW_BASE_GAME:int = int.MAX_VALUE - 3;
      
      public static const PACK_DD_SHOW_CUSTOM:int = int.MAX_VALUE - 4;
      
      public static const PACK_DD_SHOW_RECOMMENDED:int = int.MAX_VALUE - 5;
      
      protected static const menuItemFriends:MenuItem = new MenuItem(KeysEXCH.GALLERY_CREATEDBY_FRIENDS_TOOLTIP.toString(),CREATEDBY_SUBSCRIPTIONS);
      
      protected static const menuItemGlobal:MenuItem = new MenuItem(KeysEXCH.GALLERY_CREATEDBY_WORLD_TOOLTIP.toString(),CREATEDBY_GLOBAL);
      
      protected static const menuItemMaxis:MenuItem = new MenuItem(KeysEXCH.GALLERY_CREATEDBY_MAXIS_TOOLTIP.toString(),CREATEDBY_MAXIS);
      
      protected static const menuItemMaxisCurated:MenuItem = new MenuItem(KeysEXCH.GALLERY_CREATEDBY_MAXIS_CURATED_TOOLTIP.toString(),CREATEDBY_MAXIS);
      
      protected static const menuItemAll:MenuItem = new MenuItem(KeysEXCH.GALLERY_CREATEDBY_WORLD_TOOLTIP.toString(),CREATEDBY_ALL);
      
      protected static const menuItemMine:MenuItem = new MenuItem(KeysEXCH.GALLERY_CREATEDBY_ME_TOOLTIP.toString(),CREATEDBY_MINE_ONLY);
      
      protected static const menuItemOthers:MenuItem = new MenuItem(KeysEXCH.GALLERY_CREATEDBY_OTHERS_TOOLTIP.toString(),CREATEDBY_OTHERS);
      
      protected static const menuItemCurrentPlatform:MenuItem = new MenuItem(SystemUtils.IsPS4 ? KeysConsole.GALLERY_CREATEDBY_PLATFORM_PS4.toString() : (SystemUtils.IsXB1 ? KeysConsole.GALLERY_CREATEDBY_PLATFORM_XB1.toString() : KeysConsole.GALLERY_CREATEDBY_PLATFORM.toString()),CREATEDBY_CURRENT_PLATFORM);
      
      public static const DEFAULT_CREATEDBY_GROUP_COMMUNITY:uint = CREATEDBY_GLOBAL;
      
      public static const DEFAULT_CREATEDBY_GROUP_CG:uint = CREATEDBY_GLOBAL;
      
      public static const DEFAULT_CREATEDBY_GROUP_LIBRARY:uint = CREATEDBY_ALL;
      
      public static const DEFAULT_CREATEDBY_GROUP_MY_PROFILE:uint = CREATEDBY_GLOBAL;
      
      public static const DEFAULT_CREATEDBY_GROUP_OTHER_PROFILE:uint = CREATEDBY_GLOBAL;
      
      public static const DEFAULT_CREATEDBY_GROUP_MAXIS_PROFILE:uint = CREATEDBY_MAXIS;
      
      public static const DD_CURATOR_COMMUNITY:Array = [menuItemGlobal,menuItemMaxisCurated,menuItemFriends];
      
      public static const DD_CURATOR_COMMUNITY_CONSOLE:Array = [menuItemGlobal,menuItemMaxisCurated,menuItemFriends,menuItemCurrentPlatform];
      
      public static const DD_CURATOR_CG:Array = [menuItemGlobal];
      
      public static const DD_CURATOR_CG_CONSOLE:Array = [menuItemGlobal,menuItemCurrentPlatform];
      
      public static const DD_CURATOR_LIBRARY:Array = [menuItemAll,menuItemMaxis,menuItemMine,menuItemOthers];
      
      public static const DD_CURATOR_MY_PROFILE:Array = [new MenuItem(KeysEXCH.PLAYERPROFILE_LABEL_MY_SHARED.toString(),TAB_INDEX_CREATIONS),new MenuItem(KeysEXCH.PLAYERPROFILE_LABEL_MY_FAVORITES.toString(),TAB_INDEX_FAVORITES)];
      
      public static const DD_CURATOR_OTHER_PLAYER_PROFILE:* = [new MenuItem(KeysEXCH.PLAYERPROFILE_LABEL_SHARED.toString(),TAB_INDEX_CREATIONS),new MenuItem(KeysEXCH.PLAYERPROFILE_LABEL_FAVORITES.toString(),TAB_INDEX_FAVORITES)];
      
      public static const DD_CURATOR_MAXIS_PROFILE:Array = [new MenuItem(KeysEXCH.PLAYERPROFILE_LABEL_MY_SHARED.toString(),TAB_INDEX_CREATIONS),new MenuItem(KeysEXCH.GALLERY_CREATEDBY_MAXIS_CURATED_TOOLTIP.toString(),TAB_INDEX_FAVORITES)];
      
      public static const FEATURE_PARAMETER_ENABLE_EXTENDED_GALLERY_SEARCH:String = "0x53c13a32f4e497a7";
      
      public static const FILTERS_MENU_ITEM_LOCKED:MenuItem = new MenuItem(KeysEXCH.FILTERS_LABEL_LOCKED.toString(),501);
      
      public static const FILTERS_MENU_ITEM_MODDED:MenuItem = new MenuItem(KeysEXCH.FILTERS_LABEL_MODDED.toString(),502,true,null,KeysEXCH.FILTERS_LABEL_MODDED_TOOLTIP.toString());
      
      public static const PACK_DROPDOWN_DEFAULT_SELECTION:MenuItem = new MenuItem(KeysEXCH.FILTERS_PACK_DROPDOWN_SHOW_ALL.toString(),PACK_DD_SHOW_ALL);
      
      public static const PACK_DROPDOWN_DEFAULT_VALUES:Array = [PACK_DROPDOWN_DEFAULT_SELECTION,new MenuItem(KeysEXCH.FILTERS_PACK_DROPDOWN_SHOW_OWNED.toString(),PACK_DD_SHOW_OWNED),new MenuItem(KeysEXCH.FILTERS_PACK_DROPDOWN_SHOW_BASEGAME.toString(),PACK_DD_SHOW_BASE_GAME)];
      
      public static const PACK_DROPDOWN_DEFAULT_VALUES_ONLINE:Array = [PACK_DROPDOWN_DEFAULT_SELECTION,new MenuItem(KeysEXCH.FILTERS_PACK_DROPDOWN_SHOW_OWNED.toString(),PACK_DD_SHOW_OWNED),new MenuItem(KeysEXCH.FILTERS_PACK_DROPDOWN_SHOW_BASEGAME.toString(),PACK_DD_SHOW_BASE_GAME),new MenuItem(KeysEXCH.FILTERS_PACK_DROPDOWN_SHOW_RECOMMENDED.toString(),PACK_DD_SHOW_RECOMMENDED)];
      
      public static const PACK_DROPDOWN_CUSTOM_VALUES:Array = [new MenuItem(KeysEXCH.FILTERS_PACK_DROPDOWN_SHOW_CUSTOM.toString(),PACK_DD_SHOW_CUSTOM)];
      
      public static const SEARCH_TYPE_ITEM_NAME:uint = 1;
      
      public static const SEARCH_TYPE_HASHTAG:uint = 2;
      
      public static const SEARCH_TYPE_ORIGIN:uint = 3;
      
      public static const SEARCH_TYPE_PS4_NAME:uint = 4;
      
      public static const SEARCH_TYPE_XBOX_NAME:uint = 5;
      
      public static const SEARCH_TYPE_TEXT_TO_TEXT:uint = 6;
      
      public static const SEARCH_TYPE_TEXT_TO_IMAGE:uint = 7;
      
      public static const DD_FILTER_SEARCH:Array = [new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_ITEM.toString(),SEARCH_TYPE_ITEM_NAME),new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_HASHTAG.toString(),SEARCH_TYPE_HASHTAG),new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_ORIGIN.toString(),SEARCH_TYPE_ORIGIN)];
      
      public static const DD_EXPANDED_FILTER_SEARCH:Array = [new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_ITEM.toString(),SEARCH_TYPE_ITEM_NAME),new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_HASHTAG.toString(),SEARCH_TYPE_HASHTAG),new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_ORIGIN.toString(),SEARCH_TYPE_ORIGIN),new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_TEXT_TO_TEXT.toString(),SEARCH_TYPE_TEXT_TO_TEXT),new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_TEXT_TO_IMAGE.toString(),SEARCH_TYPE_TEXT_TO_IMAGE)];
      
      public static const DD_FILTER_ONLINE_DISABLED:Array = [new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_ITEM.toString(),SEARCH_TYPE_ITEM_NAME),new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_HASHTAG.toString(),SEARCH_TYPE_HASHTAG)];
      
      public static const DD_FILTER_NAME_ONLY:Array = [new MenuItem(KeysEXCH.FILTERS_SEARCHBAR_LABEL_ITEM.toString(),SEARCH_TYPE_ITEM_NAME)];
      
      public static const TOP_FAVORITES:int = 0;
      
      public static const MOST_DOWNLOADED:int = 1;
      
      public static const WEEKLY_FAVORITES:int = 2;
      
      public static const WEEKLY_DOWNLOADED:int = 3;
      
      public static const MOST_RECENT:int = 4;
      
      public static const MOST_RECENT_MENU_ITEM:MenuItem = new MenuItem(KeysEXCH.FILTERS_MOST_RECENT.toString(),MOST_RECENT);
      
      public static const WEEKLY_DOWNLOADED_MENU_ITEM:MenuItem = new MenuItem(KeysEXCH.FILTERS_DOWNLOADS_WEEKLY.toString(),WEEKLY_DOWNLOADED);
      
      public static const MOST_DOWNLOADED_MENU_ITEM:MenuItem = new MenuItem(KeysEXCH.FILTERS_DOWNLOADS_TOP.toString(),MOST_DOWNLOADED);
      
      public static const SHOW_OPTIONS_COMMUNITY:Array = [WEEKLY_DOWNLOADED_MENU_ITEM,MOST_DOWNLOADED_MENU_ITEM,MOST_RECENT_MENU_ITEM];
      
      public static const SHOW_OPTIONS_CG:Array = [WEEKLY_DOWNLOADED_MENU_ITEM,MOST_DOWNLOADED_MENU_ITEM,MOST_RECENT_MENU_ITEM];
      
      public static const SHOW_OPTIONS_DEFAULT:Array = [MOST_RECENT_MENU_ITEM,MOST_DOWNLOADED_MENU_ITEM];
      
      public static const DEFAULT_HOUSEHOLD_SIZE_VALUE:int = ALL;
      
      protected static const ONE_SIM:int = 1001;
      
      protected static const TWOTOTHREE_SIMS:int = 1002;
      
      protected static const FOURTOSIX_SIMS:int = 1003;
      
      protected static const SEVENTOEIGHT_SIMS:int = 1004;
      
      public static const HOUSEHOLD_SIZE_OPTIONS:Array = [new MenuItem(KeysEXCH.FILTERS_HH_ALL.toString(),ALL),new MenuItem(KeysEXCH.FILTERS_HH_ONE_SIM.toString(),ONE_SIM),new MenuItem(KeysEXCH.FILTERS_HH_TWOTOTHREE_SIMS.toString(),TWOTOTHREE_SIMS),new MenuItem(KeysEXCH.FILTERS_HH_FOURTOSIX_SIMS.toString(),FOURTOSIX_SIMS),new MenuItem(KeysEXCH.FILTERS_HH_SEVENTOEIGHT_SIMS.toString(),SEVENTOEIGHT_SIMS)];
      
      public static const DEFAULT_HOUSEHOLD_SPECIES_VALUE:int = ALL;
      
      protected static const DOGS:int = 1;
      
      protected static const CATS:int = 2;
      
      protected static const FOXES:int = 3;
      
      protected static const HORSES:int = 4;
      
      protected static const WITH_PETS:int = 5;
      
      protected static const NO_PETS:int = 6;
      
      public static const HOUSEHOLD_SPECIES_OPTIONS:Array = [new MenuItem(KeysEXCH.FILTERS_HH_SPECIES_ALL.toString(),ALL),new MenuItem(KeysEXCH.FILTERS_HH_SPECIES_DOGS.toString(),DOGS),new MenuItem(KeysEXCH.FILTERS_HH_SPECIES_CATS.toString(),CATS),new MenuItem(KeysEXCH.FILTERS_HH_SPECIES_HORSES.toString(),HORSES),new MenuItem(KeysEXCH.FILTERS_HH_SPECIES_WITH_PETS.toString(),WITH_PETS),new MenuItem(KeysEXCH.FILTERS_HH_SPECIES_NO_PETS.toString(),NO_PETS)];
      
      public static const DEFAULT_LOT_COST_VALUE:int = ALL;
      
      public static const DEFAULT_LOT_SIZE_VALUE:int = ALL;
      
      public static const DEFAULT_LOT_TYPE_VALUE:String = "0";
      
      protected static const LOTS_20x15:int = 2001;
      
      protected static const LOTS_30x20:int = 2002;
      
      protected static const LOTS_40x30:int = 2003;
      
      protected static const LOTS_50x50:int = 2004;
      
      protected static const LOTS_50x40:int = 2005;
      
      protected static const LOTS_40x20:int = 2006;
      
      protected static const LOTS_30x30:int = 2007;
      
      protected static const LOTS_20x20:int = 2008;
      
      protected static const LOTS_64x64:int = 2009;
      
      protected static const LOTS_40x40:int = 2010;
      
      public static const LOT_SIZE_OPTIONS:Array = [new MenuItem(KeysEXCH.FILTERS_BP_ALL.toString(),ALL),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(20,15),LOTS_20x15),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(20,20),LOTS_20x20),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(30,20),LOTS_30x20),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(30,30),LOTS_30x30),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(40,20),LOTS_40x20),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(40,30),LOTS_40x30),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(40,40),LOTS_40x40),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(50,40),LOTS_50x40),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(50,50),LOTS_50x50),new MenuItem(KeysEXCH.DETAIL_LABEL_SIZE_VALUE.toString(64,64),LOTS_64x64)];
      
      protected static const PRICE_RANGE_1:int = 1;
      
      protected static const PRICE_RANGE_2:int = 2;
      
      protected static const PRICE_RANGE_3:int = 3;
      
      protected static const PRICE_RANGE_4:int = 4;
      
      protected static const PRICE_RANGE_5:int = 5;
      
      protected static const PRICE_RANGE_6:int = 6;
      
      public static const LOT_COST_OPTIONS:Array = [new MenuItem(KeysEXCH.FILTERS_BP_ALL.toString(),ALL),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE.toString(int(0),10000),PRICE_RANGE_1),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE.toString(10000,20000),PRICE_RANGE_2),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE.toString(20000,40000),PRICE_RANGE_3),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE.toString(40000,80000),PRICE_RANGE_4),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE.toString(80000,150000),PRICE_RANGE_5),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE_PLUS.toString(150000),PRICE_RANGE_6)];
      
      public static const DEFAULT_ROOM_TYPE_VALUE:int = ROOM_TYPE_ALL;
      
      public static const DEFAULT_ROOM_SIZE_VALUE:int = ALL;
      
      public static const DEFAULT_ROOM_COST_VALUE:int = ALL;
      
      public static const DEFAULT_BODY_PART_VALUE:int = ALL;
      
      protected static const ROOM_TYPE_ALL:int = 0;
      
      protected static const ROOM_TYPE_BEDROOM:int = 272;
      
      protected static const ROOM_TYPE_BATHROOM:int = 271;
      
      protected static const ROOM_TYPE_KITCHEN:int = 274;
      
      protected static const ROOM_TYPE_LIVING:int = 270;
      
      protected static const ROOM_TYPE_STUDY:int = 276;
      
      protected static const ROOM_TYPE_OUTDOOR:int = 275;
      
      protected static const ROOM_TYPE_DINING:int = 273;
      
      protected static const ROOM_TYPE_KIDS:int = 864;
      
      protected static const ROOM_TYPE_MISC:int = 407;
      
      public static const ROOM_TYPE_OPTIONS:Array = [new MenuItem(KeysEXCH.FILTERS_RM_TYPE_ALL.toString(),ROOM_TYPE_ALL),new MenuItem(KeysBB.BB_FILTER_ROOM_KITCHEN.toString(),ROOM_TYPE_KITCHEN),new MenuItem(KeysBB.BB_FILTER_ROOM_BATH.toString(),ROOM_TYPE_BATHROOM),new MenuItem(KeysBB.BB_FILTER_ROOM_BEDROOM.toString(),ROOM_TYPE_BEDROOM),new MenuItem(KeysBB.BB_FILTER_ROOM_LIVING.toString(),ROOM_TYPE_LIVING),new MenuItem(KeysBB.BB_FILTER_ROOM_DINING.toString(),ROOM_TYPE_DINING),new MenuItem(KeysBB.BB_FILTER_ROOM_STUDY.toString(),ROOM_TYPE_STUDY),new MenuItem(KeysBB.BB_FILTER_ROOM_OUTDOOR.toString(),ROOM_TYPE_OUTDOOR),new MenuItem(KeysBB.BB_FILTER_ROOM_KIDS.toString(),ROOM_TYPE_KIDS),new MenuItem(KeysBB.BB_FILTER_ROOM_MISC_CAREERS.toString(),ROOM_TYPE_MISC)];
      
      protected static const SMALL_ROOMS:int = 3000;
      
      protected static const MEDIUM_ROOMS:int = 3001;
      
      protected static const LARGE_ROOMS:int = 3002;
      
      protected static const EXTRALARGE_ROOMS:int = 3003;
      
      public static const ROOM_SIZE_OPTIONS:Array = [new MenuItem(KeysEXCH.FILTERS_RM_SIZE_ALL.toString(),ALL),new MenuItem(KeysEXCH.FILTERS_RM_SMALL_ROOMS.toString(),SMALL_ROOMS),new MenuItem(KeysEXCH.FILTERS_RM_MEDIUM_ROOMS.toString(),MEDIUM_ROOMS),new MenuItem(KeysEXCH.FILTERS_RM_LARGE_ROOMS.toString(),LARGE_ROOMS),new MenuItem(KeysEXCH.FILTERS_RM_EXTRALARGE_ROOMS.toString(),EXTRALARGE_ROOMS)];
      
      public static const ROOM_COST_OPTIONS:Array = [new MenuItem(KeysEXCH.FILTERS_BP_ALL.toString(),ALL),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE.toString(int(0),5000),PRICE_RANGE_1),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE.toString(5000,10000),PRICE_RANGE_2),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE.toString(10000,30000),PRICE_RANGE_3),new MenuItem(KeysEXCH.FILTERS_BP_PRICE_RANGE_PLUS.toString(30000),PRICE_RANGE_4)];
      
      public static const BODY_PART_OPTIONS:Array = [new MenuItem(KeysEXCH.FILTERS_BODY_PART_ALL.toString(),ALL),new MenuItem(KeysCAS.TATTOO_ARM_LOWER_LEFT.toString(),TattooBodyData.TATTOO_ARM_LOWER_LEFT),new MenuItem(KeysCAS.TATTOO_ARM_UPPER_LEFT.toString(),TattooBodyData.TATTOO_ARM_UPPER_LEFT),new MenuItem(KeysCAS.TATTOO_ARM_LOWER_RIGHT.toString(),TattooBodyData.TATTOO_ARM_LOWER_RIGHT),new MenuItem(KeysCAS.TATTOO_ARM_UPPER_RIGHT.toString(),TattooBodyData.TATTOO_ARM_UPPER_RIGHT),new MenuItem(KeysCAS.TATTOO_LEG_LEFT.toString(),TattooBodyData.TATTOO_LEG_LEFT),new MenuItem(KeysCAS.TATTOO_LEG_RIGHT.toString(),TattooBodyData.TATTOO_LEG_RIGHT),new MenuItem(KeysCAS.TATTOO_TORSO_BACK_LOWER.toString(),TattooBodyData.TATTOO_TORSO_BACK_LOWER),new MenuItem(KeysCAS.TATTOO_TORSO_BACK_UPPER.toString(),TattooBodyData.TATTOO_TORSO_BACK_UPPER),new MenuItem(KeysCAS.TATTOO_TORSO_FRONT_LOWER.toString(),TattooBodyData.TATTOO_TORSO_FRONT_LOWER),new MenuItem(KeysCAS.TATTOO_TORSO_FRONT_UPPER.toString(),TattooBodyData
      .TATTOO_TORSO_FRONT_UPPER),new MenuItem(KeysCAS.TATTOO_HEAD.toString(),TattooBodyData.TATTOO_HEAD)];
      
      public function ExchangeFiltersData()
      {
         super();
      }
      
      public static function GetCuratorFilterOptions(param1:int) : Object
      {
         switch(param1)
         {
            case ExchangeShareMode.COMMUNITY:
               if(SystemUtils.IsConsole)
               {
                  if(SharedExchangeUtils.CheckCrossPlatformPlayPermitted())
                  {
                     return {
                        "options":DD_CURATOR_COMMUNITY_CONSOLE,
                        "defaultValue":DEFAULT_CREATEDBY_GROUP_COMMUNITY
                     };
                  }
                  return {
                     "options":DD_CURATOR_COMMUNITY_CONSOLE,
                     "defaultValue":CREATEDBY_CURRENT_PLATFORM
                  };
               }
               return {
                  "options":DD_CURATOR_COMMUNITY,
                  "defaultValue":DEFAULT_CREATEDBY_GROUP_COMMUNITY
               };
               break;
            case ExchangeShareMode.CG:
               if(SystemUtils.IsConsole)
               {
                  if(SharedExchangeUtils.CheckCrossPlatformPlayPermitted())
                  {
                     return {
                        "options":DD_CURATOR_CG_CONSOLE,
                        "defaultValue":DEFAULT_CREATEDBY_GROUP_CG
                     };
                  }
                  return {
                     "options":DD_CURATOR_CG_CONSOLE,
                     "defaultValue":CREATEDBY_CURRENT_PLATFORM
                  };
               }
               return {
                  "options":DD_CURATOR_CG,
                  "defaultValue":DEFAULT_CREATEDBY_GROUP_CG
               };
               break;
            case ExchangeShareMode.LIBRARY:
               return {
                  "options":DD_CURATOR_LIBRARY,
                  "defaultValue":DEFAULT_CREATEDBY_GROUP_LIBRARY
               };
            case ExchangeShareMode.MY_PROFILE:
               return {
                  "options":DD_CURATOR_MY_PROFILE,
                  "defaultValue":DEFAULT_CREATEDBY_GROUP_MY_PROFILE
               };
            default:
               return null;
         }
      }
      
      public static function GetDefaultSortFilter(param1:int) : int
      {
         return MOST_RECENT;
      }
      
      public static function GetSortFilterOptions(param1:int) : Array
      {
         switch(param1)
         {
            case ExchangeShareMode.COMMUNITY:
               return SHOW_OPTIONS_COMMUNITY;
            case ExchangeShareMode.CG:
               return SHOW_OPTIONS_CG;
            case ExchangeShareMode.LIBRARY:
            case ExchangeShareMode.MY_PROFILE:
         }
         return SHOW_OPTIONS_DEFAULT;
      }
      
      public static function GetFilterTypeOptions(param1:int) : Array
      {
         switch(param1)
         {
            case ExchangeShareMode.CG:
               return TYPE_OPTIONS_CG;
            default:
               return TYPE_OPTIONS;
         }
      }
      
      public static function GetSpeciesFilterForSpecies(param1:int) : int
      {
         if(Species.IsCat(param1))
         {
            return ExchangeFiltersData.CATS;
         }
         if(Species.IsDog(param1))
         {
            return ExchangeFiltersData.DOGS;
         }
         if(Species.IsHorse(param1))
         {
            return ExchangeFiltersData.HORSES;
         }
         return ExchangeFiltersData.NO_PETS;
      }
   }
}

