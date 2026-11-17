package gamedata.Gameplay.University
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class UniversityMajorStaticData extends OlympusObject
   {
      
      protected static var sDataMap:Object;
      
      public var major_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var icon_prestige:ResourceKey = new ResourceKey();
      
      public var icon_high_res:ResourceKey = new ResourceKey();
      
      public var icon_prestige_high_res:ResourceKey = new ResourceKey();
      
      public var major_benefits:Array = [UniversityMajorBenefitData];
      
      public var career_track_ids:Array = [String];
      
      protected var mBenefitDataMap:* = new Object();
      
      public function UniversityMajorStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get StaticDataMap() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:UniversityMajorStaticData = null;
         if(!sDataMap)
         {
            sDataMap = new Object();
            _loc1_ = CommunicationManager.CallGameService("GetAllUniversityMajors") as Array;
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new UniversityMajorStaticData(_loc1_[_loc3_]);
               sDataMap[_loc4_.major_id] = _loc4_;
               _loc3_++;
            }
         }
         return sDataMap;
      }
      
      public static function GetStaticData(param1:String) : UniversityMajorStaticData
      {
         return StaticDataMap[param1];
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc3_:UniversityMajorBenefitData = null;
         super.ParseObject(param1);
         FixupArray(this.major_benefits);
         FixupArray(this.career_track_ids);
         var _loc2_:int = 0;
         while(_loc2_ < this.major_benefits.length)
         {
            _loc3_ = this.major_benefits[_loc2_];
            this.mBenefitDataMap[_loc3_.university_id] = _loc3_;
            _loc2_++;
         }
      }
      
      public function GetBenefit(param1:String) : LocKey
      {
         var _loc2_:UniversityMajorBenefitData = this.mBenefitDataMap[param1];
         if(_loc2_)
         {
            return _loc2_.benefit;
         }
         return null;
      }
      
      public function IsPrestige(param1:String) : Boolean
      {
         var _loc2_:UniversityStaticData = UniversityStaticData.GetStaticData(param1);
         if(_loc2_)
         {
            return _loc2_.prestige_degree_ids.indexOf(this.major_id) > -1;
         }
         return false;
      }
      
      public function GetIcon(param1:String) : ResourceKey
      {
         if(this.IsPrestige(param1))
         {
            return this.icon_prestige;
         }
         return this.icon;
      }
   }
}

