package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.AspirationTrackStaticData;
   import olympus.localization.LocKey;
   
   public class AspirationTrackInfo
   {
      
      protected var mStaticInfo:AspirationTrackStaticData;
      
      protected var mbPrimary:Boolean;
      
      protected var mbCompleted:Boolean;
      
      public function AspirationTrackInfo(param1:AspirationTrackStaticData)
      {
         super();
         this.mStaticInfo = param1;
      }
      
      public function MergeInformation(param1:String = null, param2:AspirationUpdate = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         if(!this.mStaticInfo)
         {
            return;
         }
         if(param1)
         {
            this.mbPrimary = param1 == this.mStaticInfo.uid;
         }
         if(param2)
         {
            _loc3_ = this.mStaticInfo.aspirations;
            _loc4_ = param2.aspirations_completed;
            _loc5_ = true;
            for each(_loc6_ in _loc3_)
            {
               if(_loc4_.indexOf(_loc6_) < 0)
               {
                  _loc5_ = false;
                  break;
               }
            }
            this.mbCompleted = _loc5_;
         }
      }
      
      public function get IsPrimaryTrack() : Boolean
      {
         return this.mbPrimary;
      }
      
      public function get IsCompletedTrack() : Boolean
      {
         return this.mbCompleted;
      }
      
      public function get display_text() : LocKey
      {
         return this.mStaticInfo.display_text;
      }
      
      public function get icon() : String
      {
         return this.mStaticInfo.icon.instance;
      }
      
      public function get category() : String
      {
         return this.mStaticInfo.category;
      }
      
      public function get aspirations() : Array
      {
         return this.mStaticInfo.aspirations;
      }
      
      public function get uid() : String
      {
         return this.mStaticInfo.uid;
      }
      
      public function get rewardId() : String
      {
         return this.mStaticInfo.rewardId;
      }
      
      public function get primary_trait() : String
      {
         return this.mStaticInfo.primary_trait;
      }
      
      public function get staticData() : AspirationTrackStaticData
      {
         return this.mStaticInfo;
      }
   }
}

