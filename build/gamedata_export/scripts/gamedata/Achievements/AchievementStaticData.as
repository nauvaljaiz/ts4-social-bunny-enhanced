package gamedata.Achievements
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class AchievementStaticData extends OlympusObject
   {
      
      protected static var sStaticData:Vector.<AchievementStaticData>;
      
      public var categories:Array = [String];
      
      public var description:LocKey = new LocKey();
      
      public var title:LocKey = new LocKey();
      
      public var objectives:Array = [String];
      
      public var is_hidden:Boolean;
      
      public var reward:String;
      
      public var points:int;
      
      public var uid:String;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var packId:int;
      
      public function AchievementStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get STATIC_DATA() : Vector.<AchievementStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!sStaticData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetAchievementStaticData") as Array;
            sStaticData = new Vector.<AchievementStaticData>(_loc1_.length,true);
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               sStaticData[_loc3_] = new AchievementStaticData(_loc1_[_loc3_]);
               _loc3_++;
            }
         }
         return sStaticData;
      }
      
      public static function GetStaticData(param1:String) : AchievementStaticData
      {
         var _loc2_:AchievementStaticData = null;
         var _loc3_:Vector.<AchievementStaticData> = STATIC_DATA;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc3_[_loc5_].uid == param1)
            {
               _loc2_ = _loc3_[_loc5_];
               break;
            }
            _loc5_++;
         }
         if(_loc2_ == null)
         {
            return new AchievementStaticData();
         }
         return _loc2_;
      }
   }
}

