package gamedata.Gameplay.SituationRewards
{
   import gamedata.Gameplay.SituationDisplay.SituationLevelUpdate;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public class SituationEnded extends OlympusObject
   {
      
      public var situation_id:String;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public var final_score:uint;
      
      public var final_level:SituationLevelUpdate = new SituationLevelUpdate();
      
      public var sim_ids:Array = [String];
      
      public var audio_sting:ResourceKey = new ResourceKey();
      
      public function SituationEnded(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_ids);
      }
   }
}

