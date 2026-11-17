package gamedata.Gameplay.SocialMedia
{
   import olympus.core.OlympusObject;
   
   public class SocialMediaDialog extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var followers_count:uint;
      
      public var feed_items:Array = [SocialMediaFeedItem];
      
      public var messages_items:Array = [SocialMediaMessageItem];
      
      public var is_update:Boolean;
      
      public var has_new_posts:Boolean;
      
      public var has_new_messages:Boolean;
      
      public var can_make_context_post:Boolean;
      
      public var can_add_contacts:Boolean;
      
      public function SocialMediaDialog(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:SocialMediaFeedItem = null;
         var _loc3_:SocialMediaMessageItem = null;
         super.ParseObject(param1);
         FixupArray(this.feed_items);
         FixupArray(this.messages_items);
         for each(_loc2_ in this.feed_items)
         {
            _loc2_.ownerSimId = this.sim_id;
         }
         for each(_loc3_ in this.messages_items)
         {
            _loc3_.ownerSimId = this.sim_id;
            _loc3_.message_post.ownerSimId = this.sim_id;
         }
      }
   }
}

