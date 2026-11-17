package gamedata.Gameplay.SocialMedia
{
   import olympus.core.OlympusObject;
   
   public class SocialMediaMessageItem extends OlympusObject
   {
      
      public var message_id:String;
      
      public var message_post:SocialMediaFeedItem;
      
      public var reply_post:SocialMediaFeedItem;
      
      public var ownerSimId:String;
      
      public function SocialMediaMessageItem(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if("message_id" in param1)
         {
            this.message_id = param1.message_id;
         }
         if("message_post" in param1)
         {
            this.message_post = new SocialMediaFeedItem(param1.message_post);
         }
         if("reply_post" in param1)
         {
            this.reply_post = new SocialMediaFeedItem(param1.reply_post);
         }
      }
   }
}

