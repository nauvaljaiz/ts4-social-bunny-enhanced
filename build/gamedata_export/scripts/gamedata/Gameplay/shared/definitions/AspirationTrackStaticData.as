package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.Gameplay.shared.AspirationUpdate;
   import gamedata.Gameplay.shared.UnfinishedBusinessAspirationUpdate;
   import gamedata.shared.ResourceKey;
   import gamedata.shared.SimAgeTypes;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class AspirationTrackStaticData extends OlympusObject
   {
      
      protected static var sTracksPerCategory:Object;
      
      public static const ASPIRATION_AGE_TYPE_NONE:int = -1;
      
      public var description_text:LocKey = new LocKey();
      
      public var display_text:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var category:String;
      
      public var aspirations:Array = [String];
      
      public var uid:String;
      
      public var rewardId:String;
      
      public var primary_trait:String;
      
      public var iconHighRes:ResourceKey = new ResourceKey();
      
      public var isHiddenUnlockable:Boolean;
      
      public var packId:int;
      
      public var is_liveevent_reward:Boolean;
      
      public function AspirationTrackStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      protected static function INIT_DATA() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:AspirationTrackStaticData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Vector.<AspirationTrackStaticData> = null;
         var _loc9_:String = null;
         var _loc10_:AspirationStaticData = null;
         if(!sTracksPerCategory)
         {
            _loc1_ = CommunicationManager.CallGameService("GetAspirationTrackStaticData",null,true) as Array;
            if(!_loc1_)
            {
               return;
            }
            sTracksPerCategory = new Object();
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new AspirationTrackStaticData(_loc1_[_loc3_]);
               _loc5_ = int(_loc4_.aspirations.length);
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc9_ = _loc4_.aspirations[_loc6_];
                  _loc10_ = AspirationStaticData.GetStaticData(_loc9_);
                  if(_loc10_)
                  {
                     _loc10_.level = _loc6_ + 1;
                  }
                  _loc6_++;
               }
               _loc7_ = _loc4_.category;
               _loc8_ = sTracksPerCategory[_loc7_];
               if(!_loc8_)
               {
                  _loc8_ = new Vector.<AspirationTrackStaticData>();
                  sTracksPerCategory[_loc7_] = _loc8_;
               }
               _loc8_.push(_loc4_);
               _loc3_++;
            }
         }
      }
      
      protected static function get STATIC_DATA_PER_CATEGORY() : Object
      {
         if(!sTracksPerCategory)
         {
            INIT_DATA();
         }
         return sTracksPerCategory;
      }
      
      public static function GetTrackData(param1:String) : AspirationTrackStaticData
      {
         var _loc3_:Vector.<AspirationTrackStaticData> = null;
         var _loc4_:AspirationTrackStaticData = null;
         var _loc2_:Object = STATIC_DATA_PER_CATEGORY;
         for each(_loc3_ in _loc2_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.uid == param1)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public static function GetTracksInCategory(param1:uint) : Array
      {
         var _loc2_:Object = null;
         _loc2_ = STATIC_DATA_PER_CATEGORY;
         var _loc3_:Vector.<AspirationTrackStaticData> = _loc2_[param1] as Vector.<AspirationTrackStaticData>;
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_.push(_loc3_[_loc6_]);
            _loc6_++;
         }
         return _loc5_;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.aspirations);
      }
      
      public function GetCurrentAspirationInTrack(param1:AspirationUpdate) : AspirationStaticData
      {
         var _loc2_:Array = null;
         var _loc5_:String = null;
         var _loc8_:String = null;
         _loc2_ = this.aspirations;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:Array = param1.aspirations_completed;
         var _loc6_:int = int(_loc2_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc2_[_loc7_] as String;
            if(_loc4_.indexOf(_loc8_) < 0)
            {
               _loc5_ = _loc8_;
               break;
            }
            if(_loc7_ == _loc6_ - 1)
            {
               _loc5_ = _loc8_;
            }
            _loc7_++;
         }
         return AspirationStaticData.GetStaticData(_loc5_);
      }
      
      public function GetCurrentUnfinishedBusinessAspirationInTrack(param1:UnfinishedBusinessAspirationUpdate) : AspirationStaticData
      {
         var _loc2_:Array = this.aspirations;
         return AspirationStaticData.GetStaticData(this.aspirations[0] as String);
      }
      
      public function AspirationTrackAgeType() : int
      {
         var _loc1_:Array = this.aspirations;
         if(_loc1_.length == 0)
         {
            return ASPIRATION_AGE_TYPE_NONE;
         }
         var _loc2_:String = _loc1_[0] as String;
         return AspirationStaticData.GetStaticData(_loc2_).aspirationValidAgeType;
      }
      
      public function IsChildOnlyspirationTrack() : Boolean
      {
         return this.AspirationTrackAgeType() == SimAgeTypes.CHILD;
      }
      
      public function IsTeenOnlyAspirationTrack() : Boolean
      {
         return this.AspirationTrackAgeType() == SimAgeTypes.TEEN;
      }
   }
}

