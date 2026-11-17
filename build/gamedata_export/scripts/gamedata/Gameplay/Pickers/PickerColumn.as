package gamedata.Gameplay.Pickers
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class PickerColumn extends OlympusObject
   {
      
      public static const ROW_MAP_NAME_NAME:String = "name";
      
      public static const ROW_MAP_NAME_ICON:String = "icon";
      
      public static const ROW_MAP_NAME_SKILL_LEVEL:String = "skill_level";
      
      public static const ROW_MAP_NAME_PRICE:String = "price";
      
      public static const ROW_MAP_NAME_INGREDIENTS:String = "ingredients";
      
      public static const ROW_MAP_NAME_LOCKED_IN_CAS:String = "locked_in_cas_icon_info";
      
      public static const TYPE_TEXT:int = 1;
      
      public static const TYPE_ICON:int = 2;
      
      public static const TYPE_ICON_AND_TEXT:int = 3;
      
      public static const SORT_TYPE_ASCENDING:int = 0;
      
      public static const SORT_TYPE_DESCENDING:int = 1;
      
      public var type:int;
      
      public var column_data_name:String;
      
      public var column_icon_name:String;
      
      public var label:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public var width:Number = 0;
      
      public var sortable:Boolean;
      
      public var mSortType:int = 0;
      
      public var mMaxWidth:Number = 0;
      
      public var mbIsShowing:Boolean = true;
      
      public var mbShouldShowIngredients:Boolean = true;
      
      public var mbShouldShowFreshIngredients:Boolean = true;
      
      public var mbShouldShowPreppedIngredients:Boolean = true;
      
      public function PickerColumn(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("icon" in param1))
         {
            this.icon = null;
         }
      }
      
      public function get ColumnWidth() : Number
      {
         return Math.max(this.width,this.mMaxWidth);
      }
   }
}

