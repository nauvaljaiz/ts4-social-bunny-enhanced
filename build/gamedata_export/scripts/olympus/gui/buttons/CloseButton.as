package olympus.gui.buttons
{
   import olympus.localization.Keys;
   
   public class CloseButton extends Button
   {
      
      public function CloseButton()
      {
         super();
         mAudioExtension.CategoryName = "CloseButton";
         TooltipExt.SetText(Keys.GENERIC_CLOSE_ESC);
      }
   }
}

