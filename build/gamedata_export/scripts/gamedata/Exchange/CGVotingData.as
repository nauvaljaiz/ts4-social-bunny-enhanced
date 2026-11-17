package gamedata.Exchange
{
   import olympus.localization.KeysEXCH;
   import olympus.localization.LocKey;
   import widgets.shared.data.UMMainMenuTemplateData;
   
   public class CGVotingData extends UMMainMenuTemplateData
   {
      
      public var startTime:Date;
      
      public var hashTagKey:LocKey;
      
      public var hashTag:String;
      
      public var dialogImageUrl:String;
      
      protected var mbActive:Boolean = false;
      
      public function CGVotingData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:Date = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         super.ParseObject(param1);
         if(param1.hashTagKey)
         {
            this.hashTagKey = new LocKey(param1.hashTagKey);
         }
         if(param1.hashTag)
         {
            this.hashTag = param1.hashTag;
         }
         if(Boolean(param1.startTime) && param1.startTime is Object)
         {
            this.startTime = new Date(0);
            this.startTime.setUTCFullYear(param1.startTime.fullYear,param1.startTime.month,param1.startTime.date);
            this.startTime.setUTCHours(param1.startTime.hours,param1.startTime.minutes,param1.startTime.seconds,param1.startTime.milliseconds);
         }
         if(Boolean(param1.endTime) && param1.endTime is Object)
         {
            endTime = new Date(0);
            endTime.setUTCFullYear(param1.endTime.fullYear,param1.endTime.month,param1.endTime.date);
            endTime.setUTCHours(param1.endTime.hours,param1.endTime.minutes,param1.endTime.seconds,param1.endTime.milliseconds);
         }
         this.mbActive = false;
         if(Boolean(this.startTime) && Boolean(endTime))
         {
            _loc2_ = new Date();
            _loc3_ = _loc2_.getTime();
            _loc4_ = this.startTime.getTime();
            _loc5_ = endTime.getTime();
            if(_loc3_ >= this.startTime.getTime() && _loc3_ < endTime.getTime())
            {
               this.mbActive = true;
            }
         }
         if(param1.imageUrl)
         {
            imageUrl = param1.imageUrl;
         }
         if(param1.dialogImageUrl)
         {
            this.dialogImageUrl = param1.dialogImageUrl;
         }
         title = KeysEXCH.CG_VOTING_BANNER_TEXT.toString();
         buttonText = KeysEXCH.CG_VOTING_BANNER_BUTTON_TEXT.toString();
      }
      
      public function get HashTag() : String
      {
         if(this.hashTagKey)
         {
            return this.hashTagKey.toString();
         }
         return this.hashTag;
      }
      
      public function get Active() : Boolean
      {
         return this.mbActive;
      }
   }
}

