package gamedata.CAS.shared
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class AspirationCategoryData extends OlympusObject
   {
      
      public static const ENABLED:int = 0;
      
      public static const DISABLED_ACTIVE:int = 1;
      
      public static const DISABLED_INACTIVE:int = 2;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var uid:String;
      
      public var bShowBonusTrait:Boolean;
      
      public var bDisplayTrackAsCategory:Boolean = false;
      
      public var state:int = 0;
      
      public var simId:String = "0";
      
      public function AspirationCategoryData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function SortingFunction(param1:AspirationCategoryData, param2:AspirationCategoryData) : Number
      {
         return param1.name.toString().localeCompare(param2.name.toString());
      }
   }
}

