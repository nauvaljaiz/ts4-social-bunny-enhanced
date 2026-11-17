package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class WhimStaticData extends OlympusObject
   {
      
      public var whimId:String;
      
      public var whimDescription:LocKey = new LocKey();
      
      public var whimName:LocKey = new LocKey();
      
      public var whimIcon:String;
      
      public var whimBucks:uint;
      
      public function WhimStaticData(param1:Object = null)
      {
         super(param1);
      }
   }
}

