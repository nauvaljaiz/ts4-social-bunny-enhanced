package widgets.Gameplay.SocialMedia
{
   import flash.events.Event;
   import gamedata.Gameplay.shared.SocialMediaReaction;
   
   public class SocialMediaReactionEvent extends Event
   {
      
      public var reactionData:SocialMediaReaction;
      
      public function SocialMediaReactionEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:SocialMediaReaction = null)
      {
         super(param1,param2,param3);
         this.reactionData = param4;
      }
   }
}

