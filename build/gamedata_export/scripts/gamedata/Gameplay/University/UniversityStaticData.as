package gamedata.Gameplay.University
{
   import flash.utils.getDefinitionByName;
   import gamedata.Gameplay.Organizations.OrganizationData;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class UniversityStaticData extends OlympusObject
   {
      
      protected static var sDataMap:Object;
      
      public var university_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var mascot_label:String;
      
      public var prestige_degree_ids:Array = [String];
      
      public var organization_ids:Array = [String];
      
      protected var mOrganizationNames:Array;
      
      public function UniversityStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get StaticDataMap() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:UniversityStaticData = null;
         if(!sDataMap)
         {
            sDataMap = new Object();
            _loc1_ = CommunicationManager.CallGameService("GetAllUniversities") as Array;
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new UniversityStaticData(_loc1_[_loc3_]);
               sDataMap[_loc4_.university_id] = _loc4_;
               _loc3_++;
            }
         }
         return sDataMap;
      }
      
      public static function GetStaticData(param1:String) : UniversityStaticData
      {
         return StaticDataMap[param1];
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.prestige_degree_ids);
         FixupArray(this.organization_ids);
      }
      
      public function get OrganizationNames() : Array
      {
         var _loc1_:String = null;
         var _loc2_:OrganizationData = null;
         if(!this.mOrganizationNames)
         {
            this.mOrganizationNames = new Array();
            for each(_loc1_ in this.organization_ids)
            {
               _loc2_ = OrganizationData.GetStaticData(_loc1_);
               if(Boolean(_loc2_) && !_loc2_.hidden)
               {
                  this.mOrganizationNames.push(_loc2_.name.toString());
               }
            }
         }
         return this.mOrganizationNames;
      }
   }
}

