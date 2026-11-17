package gamedata.Gameplay.Memories
{
   import flash.utils.getDefinitionByName;
   import gamedata.Gameplay.shared.definitions.MoodStaticData;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class MemoryTypeStaticData extends OlympusObject
   {
      
      public static var sGetAllStaticDataFunc:Function;
      
      protected static var mStaticDataMap:Object;
      
      public var displayText:LocKey = new LocKey();
      
      public var uid:String;
      
      public var mood_id:String;
      
      public function MemoryTypeStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get MEMORY_TYPES() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!mStaticDataMap)
         {
            mStaticDataMap = new Object();
            _loc1_ = sGetAllStaticDataFunc([]) as Array;
            if(!_loc1_)
            {
               return mStaticDataMap;
            }
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               switch(_loc1_[_loc3_].uid)
               {
                  case "66":
                     _loc1_[_loc3_].mood_id = "14638";
                     break;
                  case "67":
                     _loc1_[_loc3_].mood_id = "14634";
                     break;
                  case "68":
                     _loc1_[_loc3_].mood_id = "14639";
                     break;
                  case "69":
                     _loc1_[_loc3_].mood_id = "14632";
                     break;
                  case "70":
                     _loc1_[_loc3_].mood_id = "14635";
                     break;
                  case "64":
                     _loc1_[_loc3_].mood_id = "14640";
                     break;
                  case "65":
                     _loc1_[_loc3_].mood_id = "14643";
                     break;
                  case "71":
                     _loc1_[_loc3_].mood_id = "251719";
               }
               mStaticDataMap[_loc1_[_loc3_].uid] = new MemoryTypeStaticData(_loc1_[_loc3_]);
               _loc3_++;
            }
         }
         return mStaticDataMap;
      }
      
      public static function GetUidFromMoodId(param1:String) : String
      {
         var _loc2_:String = MoodStaticData.GetMoodByKey(param1).GetPortraitFrame(0);
         switch(_loc2_)
         {
            case "Flirty":
            case "Passionate":
               return "66";
            case "Confident":
            case "Fearless":
            case "Energized":
            case "Pumped":
            case "Focused":
            case "In The Zone":
               return "67";
            case "Angry":
            case "Furious":
            case "Enraged":
               return "69";
            case "Inspired":
            case "Imaginative":
            case "Musing":
               return "68";
            case "Embarrassed":
            case "Humiliated":
            case "Mortified":
               return "70";
            case "Fine":
            case "Happy":
            case "Elated":
            case "Playful":
            case "Silly":
            case "Hysterical":
            case "Dazed":
               return "64";
            case "Bored":
            case "Sad":
            case "Depressed":
            case "Tense":
            case "Stressed":
            case "Uncomfortable":
            case "Miserable":
               return "65";
            case "Scared":
            case "Terrified":
               return "71";
            case "Asleep":
               return "-1";
            default:
               return "-1";
         }
      }
      
      public static function GetMemoryTypeById(param1:String) : MemoryTypeStaticData
      {
         if(!mStaticDataMap)
         {
            MEMORY_TYPES;
         }
         return mStaticDataMap[param1];
      }
   }
}

