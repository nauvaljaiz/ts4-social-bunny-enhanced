package gamedata.Gameplay.HorseCompetition.StaticData
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class HorseCompetitionPlacementData extends OlympusObject
   {
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var large_icon:ResourceKey = new ResourceKey();
      
      public var simoleon_amount:Number;
      
      public var name:LocKey = new LocKey();
      
      public var narrative_description:* = new LocKey();
      
      public var frame_name:String;
      
      public var medal_name:LocKey = new LocKey();
      
      public var results_title_text:LocKey = new LocKey();
      
      public function HorseCompetitionPlacementData(param1:Object = null)
      {
         super(param1);
      }
   }
}

