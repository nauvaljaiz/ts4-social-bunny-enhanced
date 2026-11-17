package gamedata.Gameplay.Pickers
{
   import gamedata.Gameplay.shared.definitions.SkillStaticData;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SimPickerSkillRowData extends OlympusObject
   {
      
      public var skill_id:String;
      
      public var current_points:uint;
      
      public var tooltip:LocKey = new LocKey();
      
      protected var mStaticData:SkillStaticData;
      
      public function SimPickerSkillRowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.mStaticData = SkillStaticData.GetStaticData(this.skill_id);
         if(!this.mStaticData)
         {
            throw new Error("Static data not found for SimPickerSkillRowData: " + this.skill_id);
         }
         if(!("tooltip" in param1))
         {
            this.tooltip = null;
         }
      }
      
      public function get Title() : LocKey
      {
         return this.mStaticData.skillTitle;
      }
      
      public function get Description() : LocKey
      {
         return this.mStaticData.skillDescription;
      }
      
      public function get Icon() : ResourceKey
      {
         return this.mStaticData.skillIconResId;
      }
      
      public function get CurrentLevel() : uint
      {
         var _loc3_:int = 0;
         var _loc1_:Array = this.mStaticData.endPointsAccumulated;
         var _loc2_:uint = _loc1_.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            if(this.current_points < _loc1_[_loc4_])
            {
               return int(_loc4_);
            }
            _loc4_++;
         }
         return int(this.mStaticData.maxSkillLevel);
      }
      
      public function get MaxLevel() : uint
      {
         return this.mStaticData.maxSkillLevel;
      }
   }
}

