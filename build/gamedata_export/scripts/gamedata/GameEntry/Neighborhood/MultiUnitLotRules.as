package gamedata.GameEntry.Neighborhood
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class MultiUnitLotRules extends OlympusObject
   {
      
      public var description:LocKey = new LocKey();
      
      public var fine:uint;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var name:LocKey = new LocKey();
      
      public var state:uint;
      
      public function MultiUnitLotRules(param1:Object = null)
      {
         super(param1);
      }
   }
}

