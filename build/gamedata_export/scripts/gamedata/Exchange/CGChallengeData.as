package gamedata.Exchange
{
   import olympus.localization.LocKey;
   import olympus.objects.UMBaseData;
   
   public class CGChallengeData extends UMBaseData
   {
      
      protected var hashTagKey:LocKey;
      
      protected var nameKey:LocKey;
      
      protected var hashTag:String;
      
      protected var name:String;
      
      public var startTime:Date;
      
      public var endTime:Date;
      
      protected var mbActive:Boolean = false;
      
      protected var mbStarted:Boolean = false;
      
      public function CGChallengeData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param1.hashTagKey)
         {
            this.hashTagKey = new LocKey(param1.hashTagKey);
         }
         if(param1.nameKey)
         {
            this.nameKey = new LocKey(param1.nameKey);
         }
         if(param1.hashTag)
         {
            this.hashTag = param1.hashTag;
         }
         if(param1.name)
         {
            this.name = param1.name;
         }
         if(Boolean(param1.startTime) && param1.startTime is Object)
         {
            this.startTime = new Date(0);
            this.startTime.setUTCFullYear(param1.startTime.fullYear,param1.startTime.month,param1.startTime.date);
            this.startTime.setUTCHours(param1.startTime.hours,param1.startTime.minutes,param1.startTime.seconds,param1.startTime.milliseconds);
         }
         if(Boolean(param1.endTime) && param1.endTime is Object)
         {
            this.endTime = new Date(0);
            this.endTime.setUTCFullYear(param1.endTime.fullYear,param1.endTime.month,param1.endTime.date);
            this.endTime.setUTCHours(param1.endTime.hours,param1.endTime.minutes,param1.endTime.seconds,param1.endTime.milliseconds);
         }
         this.mbStarted = false;
         var _loc2_:Date = new Date();
         var _loc3_:Number = _loc2_.getTime();
         if(this.startTime)
         {
            _loc4_ = this.startTime.getTime();
            if(_loc3_ >= this.startTime.getTime())
            {
               this.mbStarted = true;
            }
         }
         this.mbActive = false;
         if(this.mbStarted && Boolean(this.endTime))
         {
            _loc5_ = this.endTime.getTime();
            if(_loc3_ < this.endTime.getTime())
            {
               this.mbActive = true;
            }
         }
      }
      
      public function get HashTag() : String
      {
         if(this.hashTagKey)
         {
            return this.hashTagKey.toString();
         }
         return this.hashTag;
      }
      
      public function get Name() : String
      {
         if(this.nameKey)
         {
            return this.nameKey.toString();
         }
         return this.name;
      }
      
      public function get Active() : Boolean
      {
         return this.mbActive;
      }
      
      public function get Started() : Boolean
      {
         return this.mbStarted;
      }
   }
}

