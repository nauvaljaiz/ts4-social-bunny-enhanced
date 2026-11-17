package gamedata.CAS.Relationships
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SimTropeItem extends OlympusObject
   {
      
      public static const FAMILY_TROPE:int = 0;
      
      public static const ROMANCE_TROPE:int = 1;
      
      public static const ALL_TROPE_TYPES:int = 2;
      
      public var directionality:uint;
      
      public var display_name:LocKey = new LocKey();
      
      public var trope_id:String;
      
      public var trope_type:uint;
      
      public function SimTropeItem(param1:Object = null)
      {
         super(param1);
      }
   }
}

