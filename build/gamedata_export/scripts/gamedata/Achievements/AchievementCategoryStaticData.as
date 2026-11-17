package gamedata.Achievements
{
   import flash.utils.getDefinitionByName;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class AchievementCategoryStaticData extends OlympusObject
   {
      
      protected static var sCategoryStaticData:Vector.<AchievementCategoryStaticData>;
      
      public var title:LocKey = new LocKey();
      
      public var uid:String;
      
      public function AchievementCategoryStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get CATEGORIES() : Vector.<AchievementCategoryStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!sCategoryStaticData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetAchievementCategoryStaticData",null) as Array;
            sCategoryStaticData = new Vector.<AchievementCategoryStaticData>(_loc1_.length,true);
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               sCategoryStaticData[_loc3_] = new AchievementCategoryStaticData(_loc1_[_loc3_]);
               _loc3_++;
            }
         }
         return sCategoryStaticData;
      }
   }
}

