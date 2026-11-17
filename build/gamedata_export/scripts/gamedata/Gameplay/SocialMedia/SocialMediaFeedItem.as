package gamedata.Gameplay.SocialMedia
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SocialMediaFeedItem extends OlympusObject
   {
      
      public static const POST_TYPE_DEFAULT:int = 0;
      
      public static const POST_TYPE_DIRECT_MESSAGE:int = 1;
      
      public static const POST_TYPE_FRIEND_REQUEST:int = 2;
      
      public static const POST_TYPE_FOLLOWERS_UPDATE:int = 3;
      
      public static const POST_TYPE_PUBLIC_POST:int = 4;
      
      public var post_id:String;
      
      public var author_sim_id:String;
      
      public var target_sim_id:String;
      
      public var post_type:int;
      
      public var post_time:String;
      
      public var post_text:LocKey = new LocKey();
      
      public var has_author_reacted:Boolean;
      
      public var reactions:Array = [SocialMediaPostReaction];
      
      public var ownerSimId:String;
      
      public var friendsIds:Array = [String];
      
      public function SocialMediaFeedItem(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.post_text = FixupLocKey(this.post_text);
         FixupArray(this.reactions);
         FixupArray(this.friendsIds);
      }
      
      public function HasSimReacted(param1:String) : Boolean
      {
         var _loc2_:SocialMediaPostReaction = null;
         for each(_loc2_ in this.reactions)
         {
            if(_loc2_.reacted_sims.indexOf(param1) != -1)
            {
               return true;
            }
         }
         return false;
      }
   }
}

