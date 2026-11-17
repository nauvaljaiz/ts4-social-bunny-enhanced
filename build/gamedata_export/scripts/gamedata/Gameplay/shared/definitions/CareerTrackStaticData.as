package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CareerTrackStaticData extends OlympusObject
   {
      
      protected static var sCareerTrackStaticData:Vector.<CareerTrackStaticData>;
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sTrackMap:Object = new Object();
      
      public var uid:String;
      
      public var name:LocKey = new LocKey();
      
      public var name_gender_neutral:LocKey = new LocKey();
      
      public var image:String;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var icon_high_res:ResourceKey = new ResourceKey();
      
      public var description:LocKey = new LocKey();
      
      public var branch_ids:Array = [String];
      
      public var career_levels:Array = [CareerLevelStaticData];
      
      public var branchesData:Array = [CareerTrackStaticData];
      
      public var busy_time_situation_picker_tooltip:LocKey = new LocKey();
      
      public var show_now_hiring_string:Boolean;
      
      public function CareerTrackStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : CareerTrackStaticData
      {
         var _loc2_:CareerTrackStaticData = sTrackMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new CareerTrackStaticData(_loc3_[0]);
            sTrackMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      public function get nameGenderNeutral() : String
      {
         return this.name_gender_neutral.toString();
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.career_levels);
         FixupArray(this.branch_ids);
         var _loc2_:int = int(this.branch_ids.length);
         this.branchesData.length = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.branchesData[_loc3_] = GetStaticData(this.branch_ids[_loc3_]);
            _loc3_++;
         }
      }
   }
}

