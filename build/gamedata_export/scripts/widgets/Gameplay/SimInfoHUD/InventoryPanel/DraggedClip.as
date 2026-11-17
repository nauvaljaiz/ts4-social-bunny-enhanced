package widgets.Gameplay.SimInfoHUD.InventoryPanel
{
   import flash.text.TextField;
   import gamedata.Gameplay.shared.InventorySlotInfo;
   import olympus.controls.GUIComponent;
   import olympus.controls.ImageResource;
   import olympus.utils.ImageUtils;
   
   public class DraggedClip extends GUIComponent
   {
      
      public var mcDraggedIcon:ImageResource;
      
      public var txtDraggedCount:TextField;
      
      public function DraggedClip()
      {
         super();
      }
      
      public function Draw(param1:InventorySlotInfo, param2:uint) : void
      {
         if(!param1)
         {
            return;
         }
         param1.LoadThumbnail(this.mcDraggedIcon,ImageUtils.THUMBNAIL_SIZE_MEDIUM);
         this.txtDraggedCount.htmlText = param2.toString();
         this.txtDraggedCount.visible = param2 > 1;
      }
   }
}

