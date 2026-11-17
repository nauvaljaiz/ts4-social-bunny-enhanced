package gamedata.Gameplay.University
{
   import olympus.core.OlympusObject;
   
   public class UniversityMajorData extends OlympusObject
   {
      
      public static const NOT_ACCEPTED:int = 0;
      
      public static const ACCEPTED:int = 1;
      
      public static const GRADUATED:int = 2;
      
      public var major_id:String;
      
      public var core_class_ids:Array = [String];
      
      public var class_remaining:int;
      
      public var status:int;
      
      protected var mUniversityId:String;
      
      protected var mbPrestige:Object;
      
      protected var mClassRequired:int;
      
      public function UniversityMajorData(param1:Object = null)
      {
         super(param1);
         this.mClassRequired = UniversityDegreeTrackerStaticData.GetStaticData().credits_required;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.core_class_ids);
      }
      
      public function set UniversityId(param1:String) : void
      {
         this.mUniversityId = param1;
      }
      
      public function get UniversityId() : String
      {
         return this.mUniversityId;
      }
      
      public function get ClassRequired() : int
      {
         return this.mClassRequired;
      }
      
      public function get IsPrestige() : Boolean
      {
         var _loc1_:UniversityStaticData = null;
         if(this.mbPrestige == null)
         {
            _loc1_ = UniversityStaticData.GetStaticData(this.mUniversityId);
            if(_loc1_)
            {
               this.mbPrestige = _loc1_.prestige_degree_ids.indexOf(this.major_id) > -1;
            }
         }
         return this.mbPrestige;
      }
   }
}

