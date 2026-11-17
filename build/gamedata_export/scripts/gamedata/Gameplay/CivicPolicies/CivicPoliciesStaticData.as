package gamedata.Gameplay.CivicPolicies
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class CivicPoliciesStaticData extends OlympusObject
   {
      
      protected static var sCivicPoliciesData:CivicPoliciesStaticData;
      
      public var influence_to_vote_cost:int;
      
      public var repeal_petition_threshold:int;
      
      public function CivicPoliciesStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : CivicPoliciesStaticData
      {
         if(!sCivicPoliciesData)
         {
            sCivicPoliciesData = new CivicPoliciesStaticData(CommunicationManager.CallGameService("GetCivicPoliciesModuleTuning",null,true));
         }
         return sCivicPoliciesData;
      }
   }
}

