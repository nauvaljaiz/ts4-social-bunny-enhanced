package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class SmallBusinessStaticData extends OlympusObject
   {
      
      protected static var sSmallBusinessData:SmallBusinessStaticData;
      
      public var business_icons:Array = [ResourceKey];
      
      public var presets:Array = [BusinessPreset];
      
      public var rank_statistic:String;
      
      public var reputation_statistic:String;
      
      public function SmallBusinessStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : SmallBusinessStaticData
      {
         if(!sSmallBusinessData)
         {
            sSmallBusinessData = new SmallBusinessStaticData(CommunicationManager.CallGameService("GetSmallBusinessTuning"));
         }
         return sSmallBusinessData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.business_icons);
         FixupArray(this.presets);
      }
   }
}

