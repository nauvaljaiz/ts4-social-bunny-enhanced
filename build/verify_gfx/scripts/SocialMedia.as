package
{
   import flash.display.Sprite;
   import widgets.Gameplay.SocialMedia.SocialMediaMain;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [SWF(frameRate="24",backgroundColor="#ffffff",width="500",height="375")]
   public class SocialMedia extends Sprite
   {
      
      public var widget:SocialMediaMain;
      
      public function SocialMedia()
      {
         super();
         this.widget = new SocialMediaMain();
         addChild(this.widget);
      }
   }
}

