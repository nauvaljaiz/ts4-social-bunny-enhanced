package gamedata.Gameplay.Rewards
{
   import olympus.localization.LocKey;
   
   public interface IReward
   {
      
      function get Id() : String;
      
      function get Name() : String;
      
      function get Description() : String;
      
      function get Icon() : String;
      
      function get Cost() : uint;
      
      function get Affordable() : Boolean;
      
      function set Affordable(param1:Boolean) : void;
      
      function get Available() : Boolean;
      
      function get Locked() : Boolean;
      
      function get DisabledTooltip() : LocKey;
   }
}

