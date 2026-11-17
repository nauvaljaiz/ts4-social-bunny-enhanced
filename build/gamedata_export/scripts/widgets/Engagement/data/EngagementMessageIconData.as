package widgets.Engagement.data
{
   public class EngagementMessageIconData extends EngagementMessageData
   {
      
      public var mIcons:Array = [EngagementMessageIconInfoData];
      
      public function EngagementMessageIconData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:EngagementMessageIconInfoData = null;
         super.ParseObject(param1);
         FixupArray(this.mIcons);
         var _loc2_:Array = param1["iconArray"] as Array;
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new EngagementMessageIconInfoData(_loc3_);
            if(!_loc4_.IsInvisible)
            {
               this.mIcons.push(_loc4_);
            }
         }
      }
   }
}

