package gamedata.Gameplay.Calendar
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class CalendarCategoryData extends OlympusObject
   {
      
      public static var sCategories:Array;
      
      public var category_name:LocKey = new LocKey();
      
      public var filters:Array = new Array(CalendarFilterData);
      
      public function CalendarCategoryData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetAllCategories() : Array
      {
         var _loc1_:Array = null;
         if(!sCategories)
         {
            _loc1_ = CommunicationManager.CallGameService("GetCalendarFilters",null,false) as Array;
            sCategories = new Array();
            ConstructArrayFromArray(sCategories,_loc1_,CalendarCategoryData);
         }
         return sCategories;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.filters);
      }
   }
}

