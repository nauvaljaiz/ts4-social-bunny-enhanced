package gamedata.Gameplay.Buffs
{
   import gamedata.Gameplay.Buffs.definitions.BuffMotiveOverlay;
   import gamedata.Gameplay.Buffs.definitions.BuffStaticData;
   import gamedata.Gameplay.shared.GameplayStateData;
   import olympus.core.OlympusObject;
   import olympus.core.Ticker;
   import olympus.core.Time;
   import olympus.events.TickerEvent;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class BuffInfo extends OlympusObject
   {
      
      public static const BUFF_PROGRESS_NONE:uint = 0;
      
      public static const BUFF_PROGRESS_UP:uint = 1;
      
      public static const BUFF_PROGRESS_DOWN:uint = 2;
      
      public static const POLARITY_NEUTRAL:String = "0";
      
      public static const POLARITY_NEGATIVE:String = "1";
      
      public static const POLARITY_POSITIVE:String = "2";
      
      public static const BUFF_INTENSITY_INVALID:uint = 4294967295;
      
      public static const BUFF_INTENSITY_NEUTRAL:uint = 0;
      
      public static const BUFF_INTENSITY_LOW:uint = 1;
      
      public static const BUFF_INTENSITY_MED:uint = 2;
      
      public static const BUFF_INTENSITY_HI:uint = 3;
      
      public static const BUFF_UPDATE_TYPE_ADD:uint = 0;
      
      public static const BUFF_UPDATE_TYPE_UPDATE:uint = 1;
      
      public static const BUFF_UPDATE_TYPE_REMOVE:uint = 2;
      
      public static const BUFF_DISPLAY_TYPE_DEFAULT:int = 0;
      
      public static const BUFF_DISPLAY_TYPE_BURNOUT:int = 1;
      
      public var buff_id:String;
      
      public var sim_id:String;
      
      public var update_type:uint;
      
      public var reason:LocKey = new LocKey();
      
      public var timeout:String;
      
      public var is_mood_buff:Boolean;
      
      public var buff_progress:uint;
      
      public var commodity_guid:String;
      
      public var rate_multiplier:Number = 1;
      
      public var mood_type_override:String;
      
      public var transition_into_buff_id:String;
      
      public var display_type:uint;
      
      public var motive_overlays:Array = [BuffMotiveOverlay];
      
      public var elapsedSeconds:int;
      
      public var pack_specific_description:LocKey = new LocKey();
      
      public var mood_weight:uint;
      
      protected var staticData:BuffStaticData;
      
      protected var mTimeLeft:Number = 0;
      
      protected var mAccruedTime:Number = 0;
      
      public function BuffInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetMoodWeightMap(param1:Vector.<BuffInfo>) : Object
      {
         var _loc3_:BuffInfo = null;
         var _loc4_:String = null;
         var _loc2_:Object = new Object();
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_.MoodKey;
            if(_loc4_ in _loc2_)
            {
               _loc2_[_loc4_] += _loc3_.mood_weight;
            }
            else
            {
               _loc2_[_loc4_] = _loc3_.mood_weight;
            }
         }
         return _loc2_;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         var _loc2_:BuffStaticData = BuffStaticData.GetStaticData(this.buff_id);
         if(_loc2_)
         {
            this.staticData = _loc2_;
            this.mood_weight = this.staticData.moodWeight;
         }
         else
         {
            this.mood_weight = BUFF_INTENSITY_NEUTRAL;
         }
         this.elapsedSeconds = Math.max(this.elapsedSeconds,0);
         if(!this.timeout)
         {
            this.timeout = "0";
         }
         else
         {
            Ticker.Add(this,0,this.OnTick);
         }
         this.mTimeLeft = Number(CommunicationManager.CallGameService("ComputeRemainingTime",{"targetTime":this.timeout},true));
         this.mTimeLeft = Time.ConvertToSimTime(this.mTimeLeft);
         FixupArray(this.motive_overlays);
      }
      
      public function get BuffIcon() : String
      {
         return this.staticData.iconInfo.instance;
      }
      
      public function get NameKeyHash() : uint
      {
         return this.staticData.name.hash;
      }
      
      public function get Name() : String
      {
         return this.staticData.name.toString(GameplayStateData.ActiveSimToken);
      }
      
      public function get Reason() : String
      {
         return this.reason.toString(GameplayStateData.ActiveSimToken);
      }
      
      public function get Description() : String
      {
         var _loc1_:String = this.PackSpecificDescription;
         if(_loc1_ != null && _loc1_.length > 0)
         {
            return this.PackSpecificDescription;
         }
         return this.staticData.description.toString(GameplayStateData.ActiveSimToken);
      }
      
      public function get PackSpecificDescription() : String
      {
         return this.pack_specific_description != null ? this.pack_specific_description.toString() : null;
      }
      
      public function get MoodKey() : String
      {
         return this.mood_type_override ? this.mood_type_override : this.staticData.moodType;
      }
      
      public function get StaticMoodKey() : String
      {
         return this.staticData.moodType;
      }
      
      public function get AudioStingOnAdd() : String
      {
         return this.staticData.audio_sting_on_add.instance;
      }
      
      public function get AudioStingOnRemove() : String
      {
         return this.staticData.audio_sting_on_remove.instance;
      }
      
      public function get TimeoutString() : LocKey
      {
         return this.staticData.timeout_string;
      }
      
      public function get TimeoutStringNoNextBuff() : LocKey
      {
         return this.staticData.timeout_string_no_next_buff;
      }
      
      public function ContainsOverlayType(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(this.motive_overlays) && Boolean(param1))
         {
            _loc2_ = 0;
            _loc3_ = int(this.motive_overlays.length);
            while(_loc2_ < _loc3_)
            {
               if(this.motive_overlays[_loc2_]["overlay_type"] == param1)
               {
                  return true;
               }
               _loc2_++;
            }
         }
         return false;
      }
      
      public function ContainsOverlayCommodityId(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(Boolean(this.motive_overlays) && Boolean(param1))
         {
            _loc2_ = 0;
            _loc3_ = this.motive_overlays.length;
            while(_loc2_ < _loc3_)
            {
               if(this.motive_overlays[_loc2_]["commodity_guid"] == param1)
               {
                  return true;
               }
               _loc2_++;
            }
         }
         return false;
      }
      
      public function get TimeLeft() : Number
      {
         return Math.max(0,this.mTimeLeft - this.mAccruedTime * this.rate_multiplier);
      }
      
      protected function OnTick(param1:TickerEvent) : void
      {
         this.mAccruedTime += param1.deltaSimTimeUsingGameSpeed;
      }
   }
}

