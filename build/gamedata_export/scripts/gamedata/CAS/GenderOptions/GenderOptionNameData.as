package gamedata.CAS.GenderOptions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public final class GenderOptionNameData extends OlympusObject
   {
      
      public var age:int;
      
      public var name:LocKey = new LocKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public function GenderOptionNameData(param1:Object = null)
      {
         super(param1);
      }
   }
}

