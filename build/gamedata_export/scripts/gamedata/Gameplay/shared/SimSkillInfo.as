package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.SkillStaticData;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SimSkillInfo extends OlympusObject
   {
      
      public var skill_id:String;
      
      public var curr_points:uint;
      
      public var sim_id:String;
      
      public var skillTitle:LocKey = new LocKey();
      
      public var currSkillLevel:uint;
      
      public var skillProgressDisplay:Number = 0;
      
      protected var staticData:SkillStaticData;
      
      public function SimSkillInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.staticData = SkillStaticData.GetStaticData(this.skill_id);
         if(!this.staticData)
         {
            throw new Error("Unable to retrieve static data for skill with skill id: " + this.skill_id);
         }
         this.skillTitle = this.staticData.skillTitle;
         this.currSkillLevel = this.currentLevel;
         this.skillProgressDisplay = this.skillProgress;
      }
      
      public function get skillProgress() : Number
      {
         var _loc1_:int = int(this.currentLevelMin);
         var _loc2_:int = int(this.currentLevelMax);
         if(this.currSkillLevel == 0)
         {
            return 0;
         }
         if(this.currSkillLevel == this.maxSkillLevel)
         {
            return 1;
         }
         return (this.curr_points - _loc1_) / (_loc2_ - _loc1_);
      }
      
      public function get skillProgressSort() : Number
      {
         if(this.currSkillLevel == 0)
         {
            return -1;
         }
         return this.skillProgress;
      }
      
      public function get currentLevelMin() : uint
      {
         if(this.currSkillLevel == 0)
         {
            return 0;
         }
         return this.staticData.endPointsAccumulated[this.currSkillLevel - 1];
      }
      
      public function get currentLevelMax() : uint
      {
         if(this.currSkillLevel >= this.maxSkillLevel)
         {
            return this.staticData.endPointsAccumulated[this.staticData.endPointsAccumulated.length - 1];
         }
         return this.staticData.endPointsAccumulated[this.currSkillLevel];
      }
      
      public function get skillIcon() : String
      {
         return this.staticData.skillIconResId.instance;
      }
      
      protected function get currentLevel() : uint
      {
         var _loc3_:int = 0;
         var _loc1_:Array = this.staticData.endPointsAccumulated;
         var _loc2_:uint = _loc1_.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            if(this.curr_points < _loc1_[_loc4_])
            {
               return int(_loc4_);
            }
            _loc4_++;
         }
         return int(this.staticData.maxSkillLevel);
      }
      
      public function get maxSkillLevel() : uint
      {
         return this.staticData.maxSkillLevel;
      }
      
      public function get lockedDescription() : String
      {
         return this.staticData.lockedDescription.toString();
      }
      
      public function get skillDescription() : String
      {
         var _loc1_:Object = null;
         if(this.sim_id)
         {
            _loc1_ = {"simId":this.sim_id};
            return this.staticData.skillDescription.toString(_loc1_);
         }
         return this.staticData.skillDescription.toString();
      }
      
      public function get skillLevelType() : uint
      {
         return this.staticData.skillLevelType;
      }
      
      public function get skillPriority() : uint
      {
         return this.staticData.priority;
      }
   }
}

