package widgets.BuildBuy.Magalog.controls
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import olympus.controls.GUIComponent;
   import olympus.extensions.TooltipExtension;
   import olympus.utils.TextUtils;
   
   public class ShowcaseRoomName extends GUIComponent
   {
      
      public var mcName:MovieClip;
      
      protected var mText:String;
      
      protected var mTooltipExtension:TooltipExtension;
      
      public function ShowcaseRoomName()
      {
         super();
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.mTooltipExtension = GetExtension(TooltipExtension) as TooltipExtension;
      }
      
      public function set State(param1:String) : void
      {
         this.mcName.gotoAndStop(param1);
         this.Text = this.mText;
      }
      
      public function set Text(param1:String) : void
      {
         this.mText = param1;
         var _loc2_:TextField = this.mcName.getChildByName("txtName") as TextField;
         TextUtils.SetAndEllipsizeText(_loc2_,param1);
         _loc2_.height = _loc2_.textHeight + (_loc2_.getTextFormat().leading as int) * 2;
         if(_loc2_.text != param1)
         {
            this.mTooltipExtension.Text = param1;
         }
         else
         {
            this.mTooltipExtension.Text = null;
         }
      }
   }
}

