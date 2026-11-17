package gamedata.Gameplay.SituationHUD
{
   import gamedata.shared.ISituationReward;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationOutcomeData extends OlympusObject implements ISituationReward
   {
      
      public var situation_name:LocKey = new LocKey();
      
      public var outcome_title:LocKey = new LocKey();
      
      public var outcome_description:LocKey = new LocKey();
      
      public var next_steps_description:LocKey = new LocKey();
      
      public var reward_1_icon:ResourceKey = new ResourceKey();
      
      public var reward_1_name:LocKey = new LocKey();
      
      public var reward_1_tooltip:LocKey = new LocKey();
      
      public var situation_display_style:int = 0;
      
      public function SituationOutcomeData(param1:Object = null)
      {
         super(param1);
      }
      
      public function GetTitle() : String
      {
         return this.outcome_title.toString(this.situation_name.toString());
      }
      
      public function GetDescription() : String
      {
         return this.outcome_description.toString();
      }
      
      public function GetRewardIcon() : ResourceKey
      {
         return this.reward_1_icon;
      }
      
      public function GetRewardTitle() : String
      {
         return this.reward_1_name.toString();
      }
      
      public function GetRewardDescription() : String
      {
         return this.next_steps_description.toString();
      }
      
      public function GetRewardTooltip() : String
      {
         return this.reward_1_tooltip.toString();
      }
      
      public function GetSituationDisplayStyleId() : int
      {
         return this.situation_display_style;
      }
   }
}

