package gamedata.shared
{
   public interface ISituationReward
   {
      
      function GetTitle() : String;
      
      function GetDescription() : String;
      
      function GetRewardIcon() : ResourceKey;
      
      function GetRewardTitle() : String;
      
      function GetRewardDescription() : String;
      
      function GetRewardTooltip() : String;
      
      function GetSituationDisplayStyleId() : int;
   }
}

