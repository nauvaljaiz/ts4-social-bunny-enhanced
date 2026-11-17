package gamedata.shared
{
   import olympus.localization.KeysGE;
   import olympus.math.TimeSpan;
   
   public class RecoverySaveSlotData extends SaveSlotData
   {
      
      protected static const DAYS_IN_MONTH:int = 31;
      
      protected static const MS_TO_MIN:Number = 1000 * 60;
      
      protected static const MIN_TO_DAY:Number = 60 * 24;
      
      protected var mParentSlotDate:Date;
      
      public function RecoverySaveSlotData(param1:Object = null)
      {
         super(param1);
      }
      
      public function GetTimeSinceParentString() : String
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:TimeSpan = GetTimeSpan();
         var _loc2_:Date = GetDate();
         if(this.mParentSlotDate != null && !isNaN(_loc2_.valueOf()))
         {
            _loc3_ = Math.max(this.mParentSlotDate.getTime() - _loc2_.getTime(),0);
            _loc4_ = _loc3_ / MS_TO_MIN;
            _loc5_ = _loc4_ / MIN_TO_DAY;
            if(_loc5_ >= DAYS_IN_MONTH)
            {
               return KeysGE.SAVE_LOAD_RECOVERY_LONG_AGO.toString({
                  "token_type":"TimeSpan",
                  "token_data":_loc1_
               });
            }
            if(_loc5_ >= 1)
            {
               return KeysGE.SAVE_LOAD_RECOVERY_TIMESTAMP.toString({
                  "token_type":"TimeSpan",
                  "token_data":_loc1_
               },_loc4_);
            }
         }
         return KeysGE.SAVE_LOAD_TIMESTAMP.toString({
            "token_type":"TimeSpan",
            "token_data":_loc1_
         },{
            "token_type":"TimeSpan",
            "token_data":_loc1_
         });
      }
   }
}

