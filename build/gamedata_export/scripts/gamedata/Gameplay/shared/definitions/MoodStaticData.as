package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.Gameplay.shared.SimTraitsInfo;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class MoodStaticData extends OlympusObject
   {
      
      protected static var sMoodList:Vector.<MoodStaticData>;
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sMoodMap:Object = new Object();
      
      public var mood_key:String;
      
      public var descriptions:Array = [LocKey];
      
      public var icons:Array = [ResourceKey];
      
      public var mood_names:Array = [LocKey];
      
      public var mood_text_color:uint;
      
      public var portrait_frames:Array = [String];
      
      public var portrait_pose_indexes:Array = [int];
      
      public var audio_stings_on_add:Array = [ResourceKey];
      
      public var buff_polarity:String;
      
      public var descriptions_age_override:Array = [MoodAgePair];
      
      public var descriptions_trait_override:MoodTraitOverridePair = new MoodTraitOverridePair();
      
      public function MoodStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetMoodByKey(param1:String) : MoodStaticData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:MoodStaticData = sMoodMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new MoodStaticData(_loc3_[0]);
            sMoodMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.descriptions_age_override);
         if(!("descriptions_trait_override" in param1) || !param1.descriptions_trait_override)
         {
            this.descriptions_trait_override = null;
         }
      }
      
      public function GetDescription(param1:int, param2:String = null) : String
      {
         var _loc3_:int = int(this.descriptions.length);
         if(_loc3_ == 0)
         {
            return "";
         }
         var _loc4_:LocKey = param1 >= _loc3_ ? this.descriptions[_loc3_ - 1] : this.descriptions[param1];
         if(!param2)
         {
            param2 = GameplayStateData.ActiveSimId;
         }
         return _loc4_.toString({"simId":param2});
      }
      
      public function GetAgeOverrideDescription(param1:uint, param2:int, param3:String = null) : String
      {
         var _loc9_:MoodAgePair = null;
         var _loc4_:int = int(this.descriptions_age_override.length);
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc9_ = this.descriptions_age_override[_loc6_] as MoodAgePair;
            if(_loc9_.Age == param1.toString())
            {
               _loc5_ = _loc9_.description_text;
               break;
            }
            _loc6_++;
         }
         if(!_loc5_)
         {
            return null;
         }
         var _loc7_:int = int(_loc5_.length);
         if(_loc7_ == 0)
         {
            return null;
         }
         var _loc8_:LocKey = param2 >= _loc7_ ? _loc5_[_loc7_ - 1] : _loc5_[param2];
         if(!param3)
         {
            param3 = GameplayStateData.ActiveSimId;
         }
         return _loc8_.toString({"simId":param3});
      }
      
      public function GetTraitOverrideDescription(param1:Vector.<SimTraitsInfo>, param2:int, param3:String = null) : String
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = int(param1.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(param1[_loc6_].trait_id == this.descriptions_trait_override.trait)
            {
               _loc4_ = true;
               break;
            }
            _loc6_++;
         }
         if(!_loc4_)
         {
            return null;
         }
         var _loc7_:int = int(this.descriptions_trait_override.descriptions.length);
         if(_loc7_ == 0)
         {
            return null;
         }
         var _loc8_:LocKey = param2 >= _loc7_ ? this.descriptions_trait_override.descriptions[_loc7_ - 1] : this.descriptions_trait_override.descriptions[param2];
         if(!param3)
         {
            param3 = GameplayStateData.ActiveSimId;
         }
         return _loc8_.toString({"simId":param3});
      }
      
      public function GetIcon(param1:int) : String
      {
         var _loc2_:int = int(this.icons.length);
         if(_loc2_ == 0)
         {
            return null;
         }
         if(param1 >= _loc2_)
         {
            return (this.icons[_loc2_ - 1] as ResourceKey).instance;
         }
         return (this.icons[param1] as ResourceKey).instance;
      }
      
      public function GetMoodName(param1:int, param2:String = null) : String
      {
         var _loc3_:int = int(this.mood_names.length);
         if(_loc3_ == 0)
         {
            return "";
         }
         var _loc4_:LocKey = param1 >= _loc3_ ? this.mood_names[_loc3_ - 1] : this.mood_names[param1];
         if(!param2)
         {
            param2 = GameplayStateData.ActiveSimId;
         }
         return _loc4_.toString({"simId":param2});
      }
      
      public function GetPortraitFrame(param1:int) : String
      {
         var _loc2_:int = int(this.portrait_frames.length);
         if(_loc2_ == 0)
         {
            return "";
         }
         if(param1 >= _loc2_)
         {
            return this.portrait_frames[_loc2_ - 1];
         }
         return this.portrait_frames[param1];
      }
      
      public function GetPortraitPose(param1:int) : int
      {
         var _loc2_:int = int(this.portrait_pose_indexes.length);
         if(_loc2_ == 0)
         {
            return 0;
         }
         if(param1 >= _loc2_)
         {
            return this.portrait_pose_indexes[_loc2_ - 1];
         }
         return this.portrait_pose_indexes[param1];
      }
      
      public function GetAudioSting(param1:int) : String
      {
         var _loc2_:int = int(this.audio_stings_on_add.length);
         if(_loc2_ == 0)
         {
            return "";
         }
         if(param1 >= _loc2_)
         {
            return this.audio_stings_on_add[_loc2_ - 1].instance;
         }
         return this.audio_stings_on_add[param1].instance;
      }
   }
}

