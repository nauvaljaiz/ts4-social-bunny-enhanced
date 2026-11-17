package olympus.controls
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import olympus.controls.objects.MenuItem;
   import olympus.utils.TextUtils;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.utils.Constraints;
   
   public class MenuItemRenderer extends ListItemRenderer
   {
      
      public var mcArrow:Sprite;
      
      public function MenuItemRenderer()
      {
         super();
         this.constraints.addElement("textField",textField,Constraints.ALL);
         this.constraints.addElement("mcArrow",this.mcArrow,Constraints.RIGHT);
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:MenuItem = param1 as MenuItem;
         if(_loc2_)
         {
            this.enabled = _loc2_.enabled;
            tooltipText = _loc2_.tooltipText;
         }
      }
      
      override protected function draw() : void
      {
         var _loc1_:TextField = null;
         super.draw();
         if(isInvalid(InvalidationType.SIZE))
         {
            _loc1_ = getTextField();
            if(_label != null && _loc1_ != null)
            {
               tooltipText = TextUtils.SetAndEllipsizeText(_loc1_,_label);
            }
         }
      }
   }
}

