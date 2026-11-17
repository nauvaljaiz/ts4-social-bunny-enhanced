package gamedata.Gameplay.CivicPolicies
{
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class CommunityBoardShowData extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var influence_points:int;
      
      public var title:LocKey;
      
      public var enacted_policies:Array;
      
      public var balloted_policies:Array;
      
      public var new_policy_allowed:Boolean;
      
      public var disabled_tooltip:LocKey;
      
      public var provider_type:int;
      
      public var policy_disabled_tooltip:LocKey;
      
      public var new_policy_disabled_tooltip:LocKey;
      
      public var target_id:String;
      
      public var schedule_text:LocKey;
      
      public function CommunityBoardShowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.sim_id = param1["sim_id"];
         this.influence_points = param1["influence_points"];
         if("title" in param1 && Boolean(param1.title))
         {
            this.title = new LocKey(param1.title);
         }
         this.enacted_policies = new Array();
         if("enacted_policies" in param1)
         {
            ConstructArrayFromArray(this.enacted_policies,param1.enacted_policies,CivicPolicyBoardData);
         }
         this.balloted_policies = new Array();
         if("balloted_policies" in param1)
         {
            ConstructArrayFromArray(this.balloted_policies,param1.balloted_policies,CivicPolicyBoardData);
         }
         if("new_policy_allowed" in param1)
         {
            this.new_policy_allowed = param1["new_policy_allowed"];
         }
         else
         {
            this.new_policy_allowed = false;
         }
         if("disabled_tooltip" in param1 && Boolean(param1.disabled_tooltip))
         {
            this.disabled_tooltip = new LocKey(param1.disabled_tooltip);
         }
         this.provider_type = param1["provider_type"];
         if("policy_disabled_tooltip" in param1 && Boolean(param1.policy_disabled_tooltip))
         {
            this.policy_disabled_tooltip = new LocKey(param1.policy_disabled_tooltip);
         }
         if("new_policy_disabled_tooltip" in param1 && Boolean(param1.new_policy_disabled_tooltip))
         {
            this.new_policy_disabled_tooltip = new LocKey(param1.new_policy_disabled_tooltip);
         }
         if("target_id" in param1)
         {
            this.target_id = param1["target_id"];
         }
         if("schedule_text" in param1)
         {
            this.schedule_text = LocKey.GetValidatedLocKey(param1.schedule_text);
         }
         if(this.schedule_text == null)
         {
            this.schedule_text = KeysGP.CIVICPOLICIES_COMMUNITYBOARD_SCHEDULE;
         }
      }
   }
}

