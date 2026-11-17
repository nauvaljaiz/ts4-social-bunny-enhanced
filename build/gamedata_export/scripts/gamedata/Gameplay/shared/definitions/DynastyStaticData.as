package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class DynastyStaticData extends OlympusObject
   {
      
      protected static var sDynastyData:DynastyStaticData;
      
      public var crest_symbols:Array = [ResourceKey];
      
      public var crest_backgrounds:Array = [ResourceKey];
      
      public var total_prestige_statistic:String;
      
      public var total_unity_statistic:String;
      
      public var total_prestige_accumulated:Number;
      
      public function DynastyStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : DynastyStaticData
      {
         if(!sDynastyData)
         {
            sDynastyData = new DynastyStaticData(CommunicationManager.CallGameService("GetDynastyTuning"));
         }
         return sDynastyData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.crest_symbols);
         FixupArray(this.crest_backgrounds);
      }
   }
}

