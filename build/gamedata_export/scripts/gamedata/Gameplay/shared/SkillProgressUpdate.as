package gamedata.Gameplay.shared
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import gamedata.Gameplay.shared.definitions.SkillStaticData;
   import olympus.core.OlympusObject;
   import olympus.core.Ticker;
   import olympus.events.TickerEvent;
   import olympus.localization.LocKey;
   
   public class SkillProgressUpdate extends OlympusObject implements IEventDispatcher
   {
      
      public static const SKILL_PROGRESS_TICK:String = "skillProgressTick";
      
      public static const UPDATE_DELAY_TIME:Number = 20000;
      
      public var skill_id:String;
      
      public var change_rate:Number = 0;
      
      public var curr_points:Number = 0;
      
      public var hide_progress_bar:Boolean = false;
      
      public var mood_id:String;
      
      public var sim_id:String;
      
      public var elapsedSeconds:int;
      
      public var isUpdate:Boolean;
      
      public var skillTitle:LocKey = new LocKey();
      
      protected var staticData:SkillStaticData;
      
      protected var skillLevel:uint;
      
      protected var mAccruedTime:Number = 0;
      
      protected var mNextUpdateTime:Number = 0;
      
      protected var mEventDispatcher:EventDispatcher;
      
      public function SkillProgressUpdate(param1:Object = null)
      {
         super(param1);
         this.mEventDispatcher = new EventDispatcher(this);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.staticData = SkillStaticData.GetStaticData(this.skill_id);
         if(!this.staticData)
         {
            throw new Error("Unable to retrieve static data for skill with skill id: " + this.skill_id);
         }
         this.mood_id = this.staticData.mood_id;
         this.skillTitle = this.staticData.skillTitle;
         this.skillLevel = this.CalculateCurrentLevel;
         this.elapsedSeconds = Math.max(this.elapsedSeconds,0);
         if(this.change_rate > 0)
         {
            this.curr_points += this.elapsedSeconds / 60 * this.change_rate;
            Ticker.Add(this,0,this.OnTick);
         }
      }
      
      public function get SkillIcon() : String
      {
         return this.staticData.skillIconResId.instance;
      }
      
      public function get SkillDescription() : String
      {
         var _loc1_:Object = null;
         if(this.sim_id)
         {
            _loc1_ = {"simId":this.sim_id};
            return this.staticData.skillDescription.toString(_loc1_);
         }
         return this.staticData.skillDescription.toString();
      }
      
      public function get SkillProgress() : Number
      {
         if(this.CurrentLevel == 0)
         {
            return 0;
         }
         if(this.CurrentLevel == this.MaxLevel)
         {
            return 1;
         }
         var _loc1_:uint = this.LevelStartRange;
         return (this.curr_points - _loc1_) / (this.LevelEndRange - _loc1_);
      }
      
      public function get SkillPriority() : uint
      {
         return this.staticData.priority;
      }
      
      public function get MoodId() : String
      {
         return this.mood_id;
      }
      
      public function get TooltipIcons() : Array
      {
         return this.staticData.tooltip_icon_list;
      }
      
      public function get CurrentLevel() : uint
      {
         return this.skillLevel;
      }
      
      public function get MaxLevel() : uint
      {
         return this.staticData.maxSkillLevel;
      }
      
      public function get LevelStartRange() : uint
      {
         if(this.CurrentLevel == 0)
         {
            return 0;
         }
         return this.staticData.endPointsAccumulated[this.CurrentLevel - 1];
      }
      
      public function get LevelEndRange() : uint
      {
         if(this.CurrentLevel >= this.MaxLevel)
         {
            return this.staticData.endPointsAccumulated[this.staticData.endPointsAccumulated.length - 1];
         }
         return this.staticData.endPointsAccumulated[this.CurrentLevel];
      }
      
      public function get IsMastered() : Boolean
      {
         return this.CurrentLevel == this.MaxLevel;
      }
      
      public function get NextLevelTeaser() : String
      {
         var _loc1_:int = this.skillLevel - 1;
         var _loc2_:Array = this.staticData.nextLevelTeaser;
         if(_loc1_ > -1 && _loc1_ < _loc2_.length && Boolean(_loc2_[_loc1_]))
         {
            return (this.staticData.nextLevelTeaser[this.skillLevel] as LocKey).toString(GameplayStateData.ActiveSimToken);
         }
         return "";
      }
      
      public function get CurrentPoints() : Number
      {
         var _loc1_:Number = this.mAccruedTime * 0.00001667;
         return this.curr_points + _loc1_ * this.change_rate;
      }
      
      protected function get CalculateCurrentLevel() : uint
      {
         var _loc1_:Array = null;
         _loc1_ = this.staticData.endPointsAccumulated;
         var _loc2_:uint = _loc1_.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.curr_points < _loc1_[_loc3_])
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return this.staticData.maxSkillLevel;
      }
      
      public function get GetSkillCategory() : uint
      {
         return this.staticData.skillCategory;
      }
      
      protected function OnTick(param1:TickerEvent) : void
      {
         var _loc2_:Number = param1.deltaSimTimeUsingGameSpeed;
         if(_loc2_ == 0)
         {
            return;
         }
         this.mAccruedTime += _loc2_;
         if(this.mAccruedTime > this.mNextUpdateTime)
         {
            this.dispatchEvent(new Event(SKILL_PROGRESS_TICK));
            this.mNextUpdateTime = this.mAccruedTime + UPDATE_DELAY_TIME;
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this.mEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.mEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this.mEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.mEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this.mEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
   }
}

