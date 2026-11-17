package olympus.input.helpers
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import olympus.gamepad.HighlightRequestEvent;
   import olympus.input.constants.InputAdapterTunables;
   
   public class LinkInputProxy extends MovieClip
   {
      
      protected var mTextField:TextField;
      
      protected var mTextRegion:Rectangle;
      
      public function LinkInputProxy(param1:TextField, param2:Rectangle)
      {
         super();
         this.mTextField = param1;
         this.mTextRegion = param2.clone();
         this.mTextRegion.inflate(InputAdapterTunables.DEFAULT_LINK_PROXY_OUTLINE_THICKNESS,InputAdapterTunables.DEFAULT_LINK_PROXY_OUTLINE_THICKNESS);
         this.Redraw(false);
         addEventListener(HighlightRequestEvent.HIGHLIGHT_REQUEST,this.OnHighlight,false,0,true);
         addEventListener(MouseEvent.CLICK,this.OnClick,false,0,true);
      }
      
      public static function Create(param1:TextField, param2:Rectangle) : DisplayObject
      {
         var _loc3_:DisplayObject = new LinkInputProxy(param1,param2);
         param1.parent.addChild(_loc3_);
         return _loc3_;
      }
      
      protected function Redraw(param1:Boolean) : void
      {
         x = this.mTextField.x + this.mTextRegion.x;
         y = this.mTextField.y + this.mTextRegion.y;
         graphics.clear();
         graphics.beginFill(16777215,0);
         if(param1)
         {
            graphics.lineStyle(InputAdapterTunables.DEFAULT_LINK_PROXY_OUTLINE_THICKNESS,InputAdapterTunables.DEFAULT_LINK_PROXY_HIGHLIGHT_COLOR,InputAdapterTunables.DEFAULT_LINK_PROXY_HIGHLIGHT_ALPHA);
         }
         else
         {
            graphics.lineStyle(null,0,0);
         }
         graphics.drawRect(0,0,this.mTextRegion.width,this.mTextRegion.height);
         graphics.endFill();
      }
      
      protected function OnHighlight(param1:HighlightRequestEvent) : void
      {
         this.Redraw(param1.shouldHighlight);
      }
      
      protected function OnClick(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.mTextRegion.left + this.mTextRegion.width * 0.5;
         var _loc3_:Number = this.mTextRegion.top + this.mTextRegion.height * 0.5;
         var _loc4_:int = this.mTextField.getCharIndexAtPoint(_loc2_,_loc3_);
         var _loc5_:TextFormat = this.mTextField.getTextFormat(_loc4_,_loc4_ + 1);
         var _loc6_:TextEvent = new TextEvent(TextEvent.LINK);
         _loc6_.text = _loc5_.url.replace(/^event:/,"");
         this.mTextField.dispatchEvent(_loc6_);
      }
   }
}

