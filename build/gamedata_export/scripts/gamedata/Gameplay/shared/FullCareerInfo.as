package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.CareerStaticData;
   import olympus.core.OlympusObject;
   
   public class FullCareerInfo extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var careers:Array = [CareerInfo];
      
      public var custom_name:String;
      
      public var custom_description:String;
      
      protected var mUniversityCareer:CareerInfo;
      
      protected var mSmallBusinessCareer:CareerInfo;
      
      public var virtual_careers:Array = [VirtualCareer];
      
      public function FullCareerInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:CareerInfo = null;
         var _loc4_:CareerInfo = null;
         super.ParseObject(param1);
         FixupArray(this.careers);
         FixupArray(this.virtual_careers);
         var _loc3_:Array = new Array();
         for each(_loc4_ in this.careers)
         {
            _loc4_.sim_id = this.sim_id;
            if(_loc4_.career_panel_type == CareerStaticData.PANEL_TYPE_UNIVERSITY_CAREER)
            {
               _loc2_ = _loc4_;
            }
            else if(_loc4_.career_category == CareerStaticData.CATEGORY_UNIVERSITY_COURSE)
            {
               _loc3_.push(_loc4_);
            }
            else if(Boolean(_loc4_.small_business_career_data) && _loc4_.small_business_career_data.length > 0)
            {
               this.mSmallBusinessCareer = _loc4_;
            }
         }
         if(Boolean(_loc2_) && Boolean(_loc3_.length))
         {
            for each(_loc4_ in _loc3_)
            {
               this.careers.splice(this.careers.indexOf(_loc4_),1);
            }
            _loc2_.uni_classes = _loc3_;
            if(this.careers.indexOf(_loc2_) < 0)
            {
               this.careers.push(_loc2_);
            }
            this.mUniversityCareer = _loc2_;
         }
      }
      
      public function get UniversityCareer() : CareerInfo
      {
         return this.mUniversityCareer;
      }
      
      public function get SmallBusinessCareerInfo() : Array
      {
         return this.mSmallBusinessCareer ? this.mSmallBusinessCareer.small_business_career_data : [];
      }
      
      public function HasCustomCareer() : Boolean
      {
         return this.custom_name != null;
      }
      
      public function IsRetired() : Boolean
      {
         var _loc1_:CareerInfo = null;
         if(this.careers.length == 0)
         {
            return false;
         }
         for each(_loc1_ in this.careers)
         {
            if(!_loc1_.is_retired)
            {
               return false;
            }
         }
         return true;
      }
      
      public function FindCareerForTrack(param1:String) : CareerInfo
      {
         var _loc2_:CareerInfo = null;
         for each(_loc2_ in this.careers)
         {
            if(_loc2_.HasTrackInInfo(param1))
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

