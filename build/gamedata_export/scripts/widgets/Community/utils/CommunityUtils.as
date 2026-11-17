package widgets.Community.utils
{
   import olympus.io.CommunicationManager;
   
   public class CommunityUtils
   {
      
      public function CommunityUtils()
      {
         super();
      }
      
      public static function PostSocialServerOp(param1:int, param2:String, param3:Object, param4:String = null) : void
      {
         var _loc5_:Object = {
            "MessageID":param1,
            "command":param2,
            "commandArgs":param3
         };
         if(param4)
         {
            _loc5_.transactionId = param4;
         }
         CommunicationManager.CallGameService("PostSocialServerOp",_loc5_);
      }
   }
}

