package gamedata.Gameplay.Pickers
{
   import gamedata.Gameplay.Clubs.ClubBuildingInfo;
   import olympus.core.OlympusObject;
   
   public class SimPickerData extends OlympusObject
   {
      
      public static const CELL_TYPE_DEFAULT:int = 0;
      
      public static const CELL_TYPE_SITUATION:int = 1;
      
      public static const CELL_TYPE_ADOPTION:int = 2;
      
      public static const CELL_TYPE_SOCIAL_MEDIA:int = 3;
      
      public static const CELL_TYPE_SELL_SIM:int = 4;
      
      public static const CELL_TYPE_SIM_SKILLS:int = 5;
      
      public static const CELL_TYPE_HOUSEHOLD:int = 6;
      
      public static const CELL_TYPE_SIM_REL_SKILLS:int = 7;
      
      public static const CELL_TYPE_DYNASTY:int = 8;
      
      public static const DEFAULT_COLUMN_COUNT:int = 3;
      
      public var row_data:Array = [SimPickerRowData];
      
      public var rel_bit_collection_ids:Array = [String];
      
      public var should_show_names:Boolean;
      
      public var club_building_info:ClubBuildingInfo = new ClubBuildingInfo();
      
      public var column_count:uint = 3;
      
      public var cell_type:int = 0;
      
      public var display_filter:Boolean = true;
      
      public var override_owner_relationships:Array = [Object];
      
      public var custom_filters:Array = [SimPickerCustomFilter];
      
      public function SimPickerData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function CellTypeSupportsEmptyCells(param1:int) : Boolean
      {
         switch(param1)
         {
            case CELL_TYPE_DEFAULT:
            case CELL_TYPE_SITUATION:
            case CELL_TYPE_ADOPTION:
            case CELL_TYPE_SELL_SIM:
            case CELL_TYPE_HOUSEHOLD:
               return true;
            case CELL_TYPE_SOCIAL_MEDIA:
               return false;
            default:
               return true;
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1 || !("club_building_info" in param1))
         {
            this.club_building_info = null;
         }
         FixupArray(this.rel_bit_collection_ids);
         FixupArray(this.row_data);
         FixupArray(this.override_owner_relationships);
         FixupArray(this.custom_filters);
      }
   }
}

