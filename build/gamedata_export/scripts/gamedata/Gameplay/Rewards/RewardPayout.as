package gamedata.Gameplay.Rewards
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class RewardPayout extends OlympusObject
   {
      
      public var reward_id:String;
      
      public var money:Array = [uint];
      
      public var object_names:Array = [LocKey];
      
      public var cas_part_keys:Array = [String];
      
      public var trait_ids:Array = [String];
      
      public var casNames:Object;
      
      public var totalMoney:int;
      
      public function RewardPayout(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc5_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         super.ParseObject(param1);
         FixupArray(this.money);
         FixupArray(this.object_names);
         FixupArray(this.cas_part_keys);
         FixupArray(this.trait_ids);
         this.casNames = new Object();
         var _loc3_:Array = this.cas_part_keys;
         var _loc4_:int = int(_loc3_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc8_ = this.cas_part_keys[_loc2_];
            _loc9_ = CommunicationManager.CallGameService("GetCASPartInfo",_loc8_,true);
            if(_loc9_)
            {
               this.casNames[_loc8_] = {
                  "title":new LocKey(_loc9_.title).toString(),
                  "desc":new LocKey(_loc9_.description).toString()
               };
            }
            _loc2_++;
         }
         _loc5_ = this.money;
         var _loc6_:int = int(_loc5_.length);
         var _loc7_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc6_)
         {
            _loc7_ += _loc5_[_loc2_];
            _loc2_++;
         }
         this.totalMoney = _loc7_;
      }
   }
}

