package olympus.effects
{
   import flash.display.MovieClip;
   import olympus.controls.ImageResource;
   import olympus.effects.interfaces.IHUDEffectClip;
   
   public class IconClip extends MovieClip implements IHUDEffectClip
   {
      
      public var mcIcon:ImageResource;
      
      public function IconClip()
      {
         super();
         this.mcIcon.scaleMode = "noScale";
         this.mcIcon.align = "center";
      }
      
      public function SetData(param1:Object) : void
      {
         this.mcIcon.LoadImage(param1["icon"]);
      }
      
      public function PlayAnimation() : void
      {
      }
   }
}

