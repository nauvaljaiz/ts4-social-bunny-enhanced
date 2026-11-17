package gamedata.Gameplay.CivicPolicies
{
   import olympus.core.OlympusObject;
   
   public class CommunityBoardAddPolicyData extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var policy_ids:Array = [String];
      
      public var policies:Array = [CivicPolicyBoardData];
      
      public var new_policy_allowed:Boolean;
      
      public function CommunityBoardAddPolicyData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.policy_ids);
         FixupArray(this.policies);
      }
   }
}

