package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   
   public class AspirationCareerStaticData extends OlympusObject
   {
      
      public var uid:uint;
      
      public var objectiveUids:Array = [String];
      
      public function AspirationCareerStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.objectiveUids);
      }
   }
}

