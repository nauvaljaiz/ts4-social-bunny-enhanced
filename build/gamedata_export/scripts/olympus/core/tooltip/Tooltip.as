package olympus.core.tooltip
{
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import olympus.controls.IconComponent;
   import olympus.events.GenericEvent;
   import olympus.localization.LocKey;
   import olympus.utils.Clamp;
   import olympus.utils.SystemUtils;
   
   public class Tooltip extends TooltipBase
   {
      
      public static const TYPE_DESCRIPTION_ONLY:String = "description";
      
      public static const TYPE_DESCRIPTION_NEW:String = "description_new";
      
      public static const TYPE_TITLE_DESCRIPTION:String = "titleDescription";
      
      public static const TYPE_TITLE_SUBTITLE_DESCRIPTION:String = "titleSubtitleDescription";
      
      public static const TYPE_TITLE_ICON_DESCRIPTION:String = "titleIconDescription";
      
      protected static const BG_NEW_COLOR_START:uint = 15718750;
      
      protected static const BG_NEW_COLOR_END:uint = 15644692;
      
      public var mcBG:Sprite;
      
      public var txtField:TextField;
      
      public var txtTitle:TextField;
      
      public var txtSubtitle:TextField;
      
      public var mcIcon:IconComponent;
      
      public var txtNewContent:TextField;
      
      protected var mData:Object;
      
      protected var mOrigTextX:Number;
      
      protected var mOrigTextY:Number;
      
      protected var mStyleSheet:StyleSheet;
      
      public function Tooltip()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         visible = false;
         this.mcBG = new Sprite();
         addChildAt(this.mcBG,0);
         this.mStyleSheet = new StyleSheet();
         ConfigureGenericTooltipStyleSheet(this.mStyleSheet);
      }
      
      protected static function ConfigureGenericTooltipStyleSheet(param1:StyleSheet) : void
      {
         param1.setStyle(".hasIngredients",{"color":"#1e81e6"});
         param1.setStyle(".noIngredients",{"color":"#8a8a8a"});
      }
      
      override public function SetData(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc9_:TextField = null;
         var _loc10_:TextFormat = null;
         var _loc18_:uint = 0;
         var _loc19_:int = 0;
         var _loc2_:String = param1["type"] || TYPE_DESCRIPTION_ONLY;
         gotoAndStop(_loc2_);
         this.mData = param1;
         var _loc3_:Number = Number(param1["maxwidth"]);
         var _loc6_:String = "";
         var _loc7_:Number = 0;
         var _loc8_:Number = TOOLTIP_PADDING.Horizontal;
         if(param1["text"] is LocKey)
         {
            _loc6_ = param1["text"].toString();
         }
         else
         {
            _loc6_ = param1["text"];
         }
         if(SystemUtils.UsingController)
         {
            _loc6_ += GetControllerHintText(param1);
         }
         if(isNaN(_loc3_) || _loc3_ <= 0)
         {
            _loc3_ = BG_DEFAULT_WIDTH;
         }
         else
         {
            _loc3_ = Clamp.Num(_loc3_,BG_MINIMUM_WIDTH,BG_MAX_WIDTH);
         }
         if(param1["textAlign"])
         {
            _loc10_ = new TextFormat();
            _loc10_.align = param1["textAlign"];
         }
         var _loc11_:Number = 0;
         if(_loc2_ == TYPE_TITLE_ICON_DESCRIPTION)
         {
            if(param1["iconSize"])
            {
               _loc11_ = Number(param1["iconSize"]);
               this.mcIcon.ResetImageSize(_loc11_,_loc11_);
            }
            else
            {
               _loc11_ = this.mcIcon.width;
            }
            _loc8_ += _loc11_;
            this.mcIcon.x = TOOLTIP_PADDING.mLeft;
            this.mcIcon.y = TOOLTIP_PADDING.mTop;
            this.mcIcon.LoadImage(param1["icon"]);
         }
         switch(_loc2_)
         {
            case TYPE_TITLE_SUBTITLE_DESCRIPTION:
               _loc9_ = this.txtSubtitle;
               _loc9_.wordWrap = true;
               _loc9_.autoSize = TextFieldAutoSize.LEFT;
               _loc9_.width = _loc3_;
               _loc9_.htmlText = param1["subtitle"] is LocKey ? param1["subtitle"].toString() : param1["subtitle"];
               if(_loc10_)
               {
                  _loc9_.setTextFormat(_loc10_,0,_loc9_.length);
               }
               _loc7_ = Math.ceil(_loc9_.textWidth + _loc8_);
               _loc9_.width = Math.min(_loc7_,_loc3_);
            case TYPE_TITLE_ICON_DESCRIPTION:
            case TYPE_TITLE_DESCRIPTION:
               _loc9_ = this.txtTitle;
               _loc9_.wordWrap = true;
               _loc9_.autoSize = TextFieldAutoSize.LEFT;
               _loc9_.width = _loc3_;
               _loc9_.htmlText = param1["title"] is LocKey ? param1["title"].toString() : param1["title"];
               if(_loc10_)
               {
                  _loc9_.setTextFormat(_loc10_,0,_loc9_.length);
               }
               _loc7_ = Math.ceil(Math.max(_loc7_,_loc9_.textWidth + _loc8_));
               _loc9_.width = Math.min(_loc7_,_loc3_);
            case TYPE_DESCRIPTION_ONLY:
            case TYPE_DESCRIPTION_NEW:
               _loc9_ = this.txtField;
               if(!_loc6_)
               {
                  _loc9_.htmlText = "";
                  break;
               }
               _loc9_.width = _loc3_;
               _loc9_.autoSize = TextFieldAutoSize.LEFT;
               _loc9_.styleSheet = this.mStyleSheet;
               _loc9_.htmlText = _loc6_;
               if(_loc10_)
               {
                  _loc9_.setTextFormat(_loc10_,0,_loc9_.length);
               }
               _loc7_ = Math.ceil(Math.max(_loc7_,_loc9_.textWidth + _loc8_));
               _loc9_.width = Math.min(_loc7_,_loc3_);
         }
         var _loc12_:Number = TOOLTIP_PADDING.mTop;
         var _loc13_:Number = TOOLTIP_PADDING.mLeft + _loc11_;
         var _loc14_:Number = 0;
         var _loc15_:Boolean = param1["textAlign"] == TextFormatAlign.CENTER;
         if(this.txtTitle)
         {
            _loc9_ = this.txtTitle;
            _loc9_.y = _loc12_;
            _loc12_ += _loc9_.height + SPACE_BETWEEN_TEXTFIELDS;
            _loc9_.x = _loc13_;
            _loc14_ = _loc15_ ? _loc9_.width : this.GetLargestLineWidth(_loc9_);
         }
         if(this.txtSubtitle)
         {
            _loc9_ = this.txtSubtitle;
            _loc9_.y = _loc12_;
            _loc12_ += _loc9_.height + SPACE_BETWEEN_TEXTFIELDS;
            _loc9_.x = _loc13_;
            _loc14_ = Math.max(_loc15_ ? _loc9_.width : this.GetLargestLineWidth(_loc9_),_loc14_);
         }
         if(this.txtNewContent)
         {
            _loc9_ = this.txtNewContent;
            _loc9_.y = _loc12_;
            _loc12_ += _loc9_.height + TOOLTIP_PADDING.mBot;
            _loc9_.x = _loc13_;
            _loc9_.width = _loc9_.textWidth + 4;
            _loc14_ = Math.max(_loc15_ ? _loc9_.width : this.GetLargestLineWidth(_loc9_),_loc14_);
         }
         if(this.txtField)
         {
            _loc9_ = this.txtField;
            _loc9_.y = _loc12_;
            _loc12_ += _loc9_.height + SPACE_BETWEEN_TEXTFIELDS;
            _loc9_.x = _loc13_;
            _loc14_ = Math.max(_loc15_ ? _loc9_.width : this.GetLargestLineWidth(_loc9_),_loc14_,_loc9_.textWidth);
         }
         _loc12_ -= SPACE_BETWEEN_TEXTFIELDS;
         var _loc16_:Number = mBoxWidth;
         var _loc17_:Number = mBoxHeight;
         mBoxWidth = _loc14_ + TOOLTIP_PADDING.Horizontal + _loc11_;
         mBoxHeight = Math.max(_loc12_,_loc11_ + TOOLTIP_PADDING.mTop) + TOOLTIP_PADDING.mBot;
         if(mBoxWidth != _loc16_ || mBoxHeight != _loc17_)
         {
            dispatchEvent(new GenericEvent(GenericEvent.RESIZE));
         }
         if(_loc2_ == TYPE_DESCRIPTION_NEW)
         {
            _loc19_ = 255 * (this.txtNewContent.y + this.txtNewContent.height + 0.5 * TOOLTIP_PADDING.mBot) / mBoxHeight;
            mBgColorArray = [BG_NEW_COLOR_START,BG_NEW_COLOR_END,BG_COLOR_ARRAY[0],BG_COLOR_ARRAY[1]];
            mBgAlphaArray = [1,1,1,1];
            mBgRatioArray = [0,_loc19_,_loc19_,1];
         }
         else
         {
            mBgColorArray = BG_COLOR_ARRAY;
            mBgAlphaArray = BG_ALPHA_ARRAY;
            mBgRatioArray = BG_RATIO_ARRAY;
         }
         if(param1["titleColor"])
         {
            _loc18_ = uint(param1["titleColor"]);
            this.SetTextColor(this.txtTitle,_loc18_);
         }
         if(param1["subtitleColor"])
         {
            _loc18_ = uint(param1["subtitleColor"]);
            this.SetTextColor(this.txtSubtitle,_loc18_);
         }
         if(param1["newContentColor"])
         {
            _loc18_ = uint(param1["newContentColor"]);
            this.SetTextColor(this.txtNewContent,_loc18_);
         }
         if(param1["textColor"])
         {
            _loc18_ = uint(param1["textColor"]);
            this.SetTextColor(this.txtField,_loc18_);
         }
      }
      
      protected function GetLargestLineWidth(param1:TextField) : Number
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Rectangle = null;
         var _loc8_:* = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.numLines)
         {
            _loc5_ = param1.getLineLength(_loc4_);
            if(_loc5_ > 0)
            {
               _loc6_ = param1.getLineOffset(_loc4_);
               _loc7_ = param1.getCharBoundaries(_loc6_);
               if(_loc7_)
               {
                  _loc3_ = Math.max(_loc3_,_loc7_.left);
               }
               _loc8_ = int(_loc6_ + _loc5_);
               do
               {
                  _loc8_--;
               }
               while(_loc7_ = param1.getCharBoundaries(_loc8_), !_loc7_ && _loc8_ > _loc6_);
               if(_loc7_)
               {
                  _loc2_ = Math.max(_loc2_,_loc7_.right);
               }
            }
            _loc4_++;
         }
         return _loc3_ + _loc2_;
      }
      
      override public function OnUpdatePosition(param1:Rectangle, param2:Number = 0, param3:Number = 0) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Point = null;
         _loc6_ = this.GetBounds();
         _loc7_ = new Point(_loc6_.width,_loc6_.height);
         var _loc8_:Point = localToGlobal(_loc7_);
         var _loc9_:Rectangle = new Rectangle();
         _loc9_.top = _loc8_.y - _loc7_.y;
         _loc9_.bottom = _loc8_.y;
         _loc9_.left = _loc8_.x - _loc7_.x;
         _loc9_.right = _loc8_.x;
         if(_loc9_.right <= param1.left + 1)
         {
            _loc4_ = DIR_RIGHT;
            x -= ARROW_LENGTH;
         }
         else if(_loc9_.left >= param1.right - 1)
         {
            _loc4_ = DIR_LEFT;
            x += ARROW_LENGTH;
         }
         else
         {
            _loc4_ = DIR_CENTER;
         }
         if(_loc9_.bottom <= param1.top + 1)
         {
            _loc5_ = DIR_DOWN;
            y -= ARROW_LENGTH;
         }
         else if(_loc9_.top >= param1.bottom - 1)
         {
            _loc5_ = DIR_UP;
            y += ARROW_LENGTH;
         }
         else
         {
            _loc5_ = DIR_CENTER;
         }
         DrawBackground(mBoxWidth,mBoxHeight,_loc4_,_loc5_,param2,param3,this.mcBG);
      }
      
      public function SetTextColor(param1:TextField, param2:uint) : void
      {
         var _loc3_:ColorTransform = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
   }
}

