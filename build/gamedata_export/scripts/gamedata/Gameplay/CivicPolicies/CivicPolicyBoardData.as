package gamedata.Gameplay.CivicPolicies
{
   import olympus.core.OlympusObject;
   
   public class CivicPolicyBoardData extends OlympusObject
   {
      
      public var policy_id:String;
      
      public var count:int;
      
      public var max_count:int;
      
      public var policy:CivicPolicyData;
      
      public var temporary_count:int;
      
      public var disabled_tooltip:String;
      
      public var name:String;
      
      public function CivicPolicyBoardData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         this.policy_id = param1["policy_id"];
         if("count" in param1)
         {
            this.count = param1["count"];
         }
         else
         {
            this.count = -1;
         }
         if("max_count" in param1)
         {
            this.max_count = param1["max_count"];
         }
         else
         {
            this.max_count = -1;
         }
         this.policy = CivicPolicyData.GetStaticData(this.policy_id);
         this.name = this.policy.name.toString();
      }
   }
}

