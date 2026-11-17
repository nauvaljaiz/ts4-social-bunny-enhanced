package gamedata.Gameplay.CivicPolicies
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class CivicPolicyData extends OlympusObject
   {
      
      protected static var sPolicyMap:Object = new Object();
      
      public var policy_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var description:LocKey = new LocKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public function CivicPolicyData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : CivicPolicyData
      {
         var _loc2_:CivicPolicyData = sPolicyMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = CommunicationManager.CallGameService("GetCivicPolicyTuningForIds",{"policy_ids":[param1]},true) as Array;
         if(_loc3_[0])
         {
            _loc2_ = new CivicPolicyData(_loc3_[0]);
            sPolicyMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

