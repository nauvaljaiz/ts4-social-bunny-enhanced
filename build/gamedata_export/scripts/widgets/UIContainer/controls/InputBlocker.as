package widgets.UIContainer.controls
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class InputBlocker extends Sprite
   {
      
      public function InputBlocker(param1:Rectangle = null)
      {
         super();
         if(param1)
         {
            this.SetRect(param1);
         }
      }
      
      public function SetRect(param1:Rectangle) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.width = param1.width;
         this.height = param1.height;
      }
   }
}

