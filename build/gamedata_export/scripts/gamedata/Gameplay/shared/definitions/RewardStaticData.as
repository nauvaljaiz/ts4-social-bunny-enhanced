package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class RewardStaticData extends OlympusObject
   {
      
      protected static var mRewardStaticData:Vector.<RewardStaticData>;
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sRewardMap:Object = new Object();
      
      public var id:String;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var description:LocKey = new LocKey();
      
      public function RewardStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function LoadRewardStaticData() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:RewardStaticData = null;
         if(!mRewardStaticData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetRewardStaticData",null,true) as Array;
            if(!_loc1_)
            {
               return false;
            }
            mRewardStaticData = new Vector.<RewardStaticData>(_loc1_.length);
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = new RewardStaticData(_loc1_[_loc2_]);
               mRewardStaticData[_loc2_] = _loc3_;
               _loc2_++;
            }
         }
         return true;
      }
      
      public static function GetStaticData(param1:String) : RewardStaticData
      {
         var _loc2_:RewardStaticData = sRewardMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new RewardStaticData(_loc3_[0]);
            sRewardMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
   }
}

