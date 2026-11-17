package olympus.utils
{
   import flash.utils.Dictionary;
   import olympus.io.CommunicationManager;
   
   public class TuningTagsUtils
   {
      
      public static var sGetTagForHashFunc:Function;
      
      public static var sGetTagHashNameFunc:Function;
      
      public static var sGetTagCategoryForTagFunc:Function;
      
      protected static var mTagCache:Dictionary = new Dictionary(true);
      
      public function TuningTagsUtils()
      {
         super();
      }
      
      public static function GetTagValueFromHash(param1:uint) : uint
      {
         var _loc2_:uint = uint(mTagCache[param1]);
         if(_loc2_)
         {
            return _loc2_;
         }
         _loc2_ = TuningTagsUtils.sGetTagForHashFunc(param1);
         if(_loc2_)
         {
            mTagCache[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public static function GetTagValueFromName(param1:String) : uint
      {
         var _loc2_:uint = CommunicationManager.CallGameService("GenerateHash32",param1) as uint;
         return GetTagValueFromHash(_loc2_);
      }
      
      public static function GetGroup(param1:Array) : Array
      {
         var _loc5_:* = undefined;
         var _loc2_:* = new Array();
         if(!param1)
         {
            return _loc2_;
         }
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            _loc5_ = TuningTagsUtils.sGetTagForHashFunc(param1[_loc3_]);
            if(!_loc5_)
            {
               throw new Error("Tag " + param1[_loc3_] + " in group is not defined");
            }
            _loc2_[_loc3_] = _loc5_;
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

