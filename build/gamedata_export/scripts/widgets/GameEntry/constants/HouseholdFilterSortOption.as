package widgets.GameEntry.constants
{
   import gamedata.GameEntry.shared.NeighborhoodStateData;
   import olympus.controls.objects.MenuItem;
   import olympus.localization.KeysGE;
   
   public class HouseholdFilterSortOption
   {
      
      public static const SORT_ICON_PROTECTED:String = "0x060a9bedbe658963";
      
      public static const SORT_ICON_NON_PROTECTED:String = "0x591ddffa730a8fe2";
      
      public static const SORT_LAST_EDITED:int = 0;
      
      public static const SORT_A_TO_Z:int = 1;
      
      public static const SORT_Z_TO_A:int = 2;
      
      public static const SORT_DATE_CREATED:int = 3;
      
      public static const HOUSEHOLD_CONVERSION_DISABLE:int = 0;
      
      public static const HOUSEHOLD_CONVERSION_KEEP:int = 1;
      
      public static const HOUSEHOLD_CONVERSION_ENABLE:int = 2;
      
      public static const FILTER_INCLUDE_PLAYED:int = 1 << 0;
      
      public static const FILTER_INCLUDE_UNPLAYED:int = 1 << 1;
      
      public static const FILTER_INCLUDE_PLAYER_PROTECTED:int = 1 << 2;
      
      public static const FILTER_INCLUDE_NON_PLAYER_PROTECTED:int = 1 << 3;
      
      public static const FILTER_INCLUDE_STORY_PROGRESSION_DEFAULT:int = 1 << 4;
      
      public static const FILTER_INCLUDE_STORY_PROGRESSION_CUSTOM:int = 1 << 5;
      
      public static const FILTER_PLAYED_UNPLAYED:int = FILTER_INCLUDE_PLAYED | FILTER_INCLUDE_UNPLAYED;
      
      public static const FILTER_STORY_PROGRESSION_ALL:int = FILTER_INCLUDE_STORY_PROGRESSION_DEFAULT | FILTER_INCLUDE_STORY_PROGRESSION_CUSTOM;
      
      public static const SORT_LIST_DATA:Array = [new MenuItem(KeysGE.HOUSEHOLD_SORT_LAST_EDITED.toString(),SORT_LAST_EDITED),new MenuItem(KeysGE.HOUSEHOLD_SORT_DATE_CREATED.toString(),SORT_DATE_CREATED),new MenuItem(KeysGE.HOUSEHOLD_SORT_A_TO_Z.toString(),SORT_A_TO_Z),new MenuItem(KeysGE.HOUSEHOLD_SORT_Z_TO_A.toString(),SORT_Z_TO_A)];
      
      public static const FILTER_LIST_DATA:Array = [new MenuItem(KeysGE.HOUSEHOLD_FILTER_ALL.toString(),{"filter":FILTER_PLAYED_UNPLAYED}),new MenuItem(KeysGE.HOUSEHOLD_FILTER_PLAYED_UNPLAYED_LABEL.toString(),null),new MenuItem(KeysGE.HOUSEHOLD_PANEL_LABEL_PLAYED.toString(),{"filter":FILTER_INCLUDE_PLAYED}),new MenuItem(KeysGE.HOUSEHOLD_PANEL_LABEL_UNPLAYED.toString(),{"filter":FILTER_INCLUDE_UNPLAYED}),new MenuItem(KeysGE.HOUSEHOLD_FILTER_NEIGHBORHOODS.toString(),null),new MenuItem(KeysGE.HOUSEHOLD_FILTER_HOUSELESS.toString(),{"filter":NeighborhoodStateData.HOUSELESS_NHD_ID})];
      
      public static const DEFAULT_SORT_INDEX:int = 0;
      
      public static const DEFAULT_SORT_ID:int = SORT_LIST_DATA[DEFAULT_SORT_INDEX].data;
      
      public static const DEFAULT_FILTER_INDEX:int = 0;
      
      public static const DEFAULT_FILTER_FLAGS_ARRAY:Array = [FILTER_PLAYED_UNPLAYED,FILTER_INCLUDE_PLAYED,FILTER_INCLUDE_UNPLAYED,FILTER_INCLUDE_STORY_PROGRESSION_DEFAULT,FILTER_INCLUDE_STORY_PROGRESSION_CUSTOM];
      
      public static const DEFAULT_FILTER_FLAGS:int = FILTER_PLAYED_UNPLAYED | FILTER_STORY_PROGRESSION_ALL;
      
      public static const STORY_PROGRESSION_FILTERS_INDEX:int = 4;
      
      public function HouseholdFilterSortOption()
      {
         super();
      }
   }
}

