package gamedata.BuildBuy.Venues
{
   import olympus.core.OlympusObject;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   
   public class VenueObjectInfo extends OlympusObject
   {
      
      public static const VOT_OPTIONAL:uint = 0;
      
      public static const VOT_REQUIRED:uint = 1;
      
      public static const VOT_REQUIRED_MAX:uint = 2;
      
      public static const VOT_LOT_REQUIRED:uint = 3;
      
      public static const VOT_FORBIDDEN:uint = 4;
      
      public static const VOT_RESTRICTION:uint = 5;
      
      public var nameKey:LocKey = new LocKey();
      
      public var tooltipOverride:LocKey = new LocKey();
      
      public var current:int;
      
      public var min:int;
      
      public var max:int;
      
      public var requiredType:uint;
      
      public var searchTags:Array = [uint];
      
      public var productType:int = 2;
      
      public var flags:uint;
      
      public var showProgress:Boolean = true;
      
      public var enabled:Boolean = true;
      
      public var filtersBB:Boolean = true;
      
      public function VenueObjectInfo(param1:Object, param2:Boolean = true)
      {
         super(param1);
         if(param2)
         {
            this.nameKey = Keys.CreateCatalogNameLocKey(this.nameKey);
         }
         FixupArray(this.searchTags);
      }
      
      public function get label() : String
      {
         return this.nameKey.toString();
      }
      
      public function get isFulfilled() : Boolean
      {
         if(this.requiredType == VOT_FORBIDDEN)
         {
            return this.current == 0;
         }
         return this.current >= this.min && this.current <= this.max;
      }
      
      public function HasFlag(param1:uint) : Boolean
      {
         return this.flags & param1;
      }
   }
}

