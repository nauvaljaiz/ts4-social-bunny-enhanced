package gamedata.Gameplay.shared.definitions
{
   import gamedata.Gameplay.shared.SocialMediaReaction;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class SocialMediaStaticData extends OlympusObject
   {
      
      protected static var sSocialMediaStaticData:SocialMediaStaticData = null;
      
      public var social_media_post_reactions:Array = [SocialMediaReaction];
      
      public var new_direct_message_picker_interaction:String;
      
      public var new_event_post_picker_interaction:String;
      
      public var new_friend_picker_interaction:String;
      
      public var new_message_type_picker_interaction:String;
      
      public var new_post_picker_interaction:String;
      
      public function SocialMediaStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : SocialMediaStaticData
      {
         var _loc1_:Object = null;
         if(!sSocialMediaStaticData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetSocialMediaData");
            if(!_loc1_)
            {
               return null;
            }
            sSocialMediaStaticData = new SocialMediaStaticData(_loc1_);
         }
         return sSocialMediaStaticData;
      }
      
      public static function GetPostReaction(param1:int, param2:int) : SocialMediaReaction
      {
         var _loc3_:SocialMediaReaction = null;
         for each(_loc3_ in GetStaticData().social_media_post_reactions)
         {
            if(_loc3_.narrative == param1 && _loc3_.polarity == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(param1)
         {
            super.ParseObject(param1);
            FixupArray(this.social_media_post_reactions);
         }
      }
   }
}

