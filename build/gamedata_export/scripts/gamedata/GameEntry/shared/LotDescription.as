package gamedata.GameEntry.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class LotDescription extends OlympusObject
   {
      
      public static const LOT_TUTORIAL_TYPE_STARTER:* = 1;
      
      public static const LOT_TUTORIAL_TYPE_EMPTY:* = 2;
      
      public var id:String;
      
      public var lotSizeX:int;
      
      public var lotSizeY:int;
      
      public var price:int;
      
      public var name:LocKey = new LocKey();
      
      public var lotRequirementVenueId:String;
      
      public var disableBuildBuy:Boolean;
      
      public var isVenueLocked:Boolean;
      
      public var lotTutorialType:int;
      
      public var instanceName:String;
      
      public function LotDescription(param1:Object = null)
      {
         super(param1);
      }
   }
}

