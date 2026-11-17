package olympus.gui.buttons
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import olympus.utils.TextUtils;
   
   public class TextButton extends Button
   {
      
      public var mcButton:MovieClip;
      
      public var mcTextField:MovieClip;
      
      protected var mMinFontSize:int = 10;
      
      public function TextButton()
      {
         super();
      }
      
      public function get ButtonTextField() : TextField
      {
         return this.mcTextField.textField as TextField;
      }
      
      public function get ButtonClip() : MovieClip
      {
         var _loc1_:MovieClip = this.mcButton;
         if(_loc1_)
         {
            if(_loc1_.mcBg)
            {
               _loc1_ = _loc1_.mcBg;
            }
         }
         return _loc1_;
      }
      
      public function get htmlText() : String
      {
         return this.mcTextField.textField.htmlText;
      }
      
      public function set htmlText(param1:String) : void
      {
         if(scaleX != 1 || scaleY != 1)
         {
            this.CounterScale();
         }
         var _loc2_:TextField = this.ButtonTextField;
         TextUtils.ResizeTextToFit(_loc2_,param1,_loc2_.width,_loc2_.height,this.mMinFontSize,true,true);
      }
      
      public function set MinFontSize(param1:int) : void
      {
         this.mMinFontSize = param1;
      }
      
      public function get CurrentFontSize() : int
      {
         var _loc1_:TextField = this.ButtonTextField;
         var _loc2_:TextFormat = _loc1_.getTextFormat();
         if(!_loc2_ || !_loc2_.size)
         {
            _loc2_ = _loc1_.defaultTextFormat;
         }
         return Number(_loc2_.size);
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         this.scaleX = scaleX;
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         this.scaleY = scaleY;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         if(param1 != 1)
         {
            this.CounterScale();
         }
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         if(param1 != 1)
         {
            this.CounterScale();
         }
      }
      
      override public function SetState(param1:String) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:TextField = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:TextField = null;
         var _loc2_:MovieClip = this.ButtonClip;
         if(_loc2_)
         {
            _loc4_ = _loc2_.scaleX;
            _loc5_ = _loc2_.scaleY;
         }
         if(this.mcTextField)
         {
            _loc6_ = this.mcTextField.textField;
            _loc7_ = _loc6_.x;
            _loc8_ = _loc6_.y;
            _loc9_ = _loc6_.scaleX;
            _loc10_ = _loc6_.scaleY;
         }
         super.SetState(param1);
         var _loc3_:MovieClip = this.ButtonClip;
         if(_loc3_)
         {
            _loc3_.scaleX = _loc4_;
            _loc3_.scaleY = _loc5_;
         }
         if(this.mcTextField)
         {
            _loc11_ = this.mcTextField.textField;
            _loc11_.x = _loc7_;
            _loc11_.y = _loc8_;
            _loc11_.scaleX = _loc9_;
            _loc11_.scaleY = _loc10_;
         }
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         this.CounterScale();
      }
      
      protected function CounterScale() : void
      {
         var _loc1_:MovieClip = null;
         var _loc3_:MovieClip = null;
         _loc1_ = this.mcButton;
         var _loc2_:Sprite = mcHitArea;
         _loc3_ = this.mcTextField;
         var _loc4_:TextField = _loc3_.textField;
         var _loc5_:Number = this.scaleX;
         var _loc6_:Number = this.scaleY;
         var _loc7_:Number = _loc1_ ? _loc1_.x : 0;
         var _loc8_:Number = _loc1_ ? _loc1_.y : 0;
         var _loc9_:Number = _loc3_.x + _loc4_.x - _loc7_;
         var _loc10_:Number = _loc3_.y + _loc4_.y - _loc8_;
         var _loc11_:MovieClip = this.ButtonClip;
         if(_loc11_)
         {
            _loc11_.scaleX *= _loc5_;
            _loc11_.scaleY *= _loc6_;
         }
         if(_loc2_)
         {
            _loc2_.scaleX *= _loc5_;
            _loc2_.scaleY *= _loc6_;
         }
         _loc4_.width *= _loc5_;
         _loc4_.height *= _loc6_;
         _loc4_.x = _loc7_ + _loc9_ * _loc5_ - _loc3_.x;
         _loc4_.y = _loc8_ + _loc10_ * _loc6_ - _loc3_.y;
         this.scaleX = this.scaleY = 1;
      }
   }
}

