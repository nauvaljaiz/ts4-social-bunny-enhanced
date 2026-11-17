package gamedata.Gameplay.University
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UniversityCourseStaticData extends OlympusObject
   {
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sUniversityCourseMap:Object = new Object();
      
      public var course_id:String;
      
      public var cost:uint;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var courses_display_data:Array = [UniversityCourseDisplayStaticData];
      
      protected var mDisplayDataMap:* = new Object();
      
      public function UniversityCourseStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : UniversityCourseStaticData
      {
         var _loc2_:UniversityCourseStaticData = sUniversityCourseMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new UniversityCourseStaticData(_loc3_[0]);
            sUniversityCourseMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc3_:UniversityCourseDisplayStaticData = null;
         super.ParseObject(param1);
         FixupArray(this.courses_display_data);
         var _loc2_:int = 0;
         while(_loc2_ < this.courses_display_data.length)
         {
            _loc3_ = this.courses_display_data[_loc2_];
            this.mDisplayDataMap[_loc3_.university_id] = _loc3_;
            _loc2_++;
         }
      }
      
      public function GetName(param1:String) : LocKey
      {
         var _loc2_:UniversityCourseDisplayStaticData = this.mDisplayDataMap[param1];
         if(_loc2_)
         {
            return _loc2_.name;
         }
         return null;
      }
      
      public function GetDescription(param1:String) : LocKey
      {
         var _loc2_:UniversityCourseDisplayStaticData = this.mDisplayDataMap[param1];
         if(_loc2_)
         {
            return _loc2_.description;
         }
         return null;
      }
   }
}

