package gamedata.Gameplay.University
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class UniversityScholarshipStaticData extends OlympusObject
   {
      
      protected static var sDataMap:Object;
      
      public var scholarship_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public function UniversityScholarshipStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get StaticDataMap() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:UniversityScholarshipStaticData = null;
         if(!sDataMap)
         {
            sDataMap = new Object();
            _loc1_ = CommunicationManager.CallGameService("GetAllScholarships") as Array;
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new UniversityScholarshipStaticData(_loc1_[_loc3_]);
               sDataMap[_loc4_.scholarship_id] = _loc4_;
               _loc3_++;
            }
         }
         return sDataMap;
      }
      
      public static function GetStaticData(param1:String) : UniversityScholarshipStaticData
      {
         return StaticDataMap[param1];
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
         this.description = FixupLocKey(this.description);
         this.tooltip = FixupLocKey(this.tooltip);
      }
   }
}

