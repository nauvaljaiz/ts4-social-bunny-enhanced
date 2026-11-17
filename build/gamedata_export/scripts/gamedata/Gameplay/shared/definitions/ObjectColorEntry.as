package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ObjectColorEntry extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var color:Array = [uint];
      
      public function ObjectColorEntry(param1:Object = null)
      {
         super(param1);
      }
   }
}

