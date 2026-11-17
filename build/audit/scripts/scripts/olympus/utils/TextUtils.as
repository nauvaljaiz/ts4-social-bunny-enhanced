package olympus.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import olympus.controls.GUIComponent;
   import olympus.extensions.TooltipExtension;
   import olympus.input.helpers.LinkInputProxy;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   import scaleform.gfx.TextFieldEx;
   
   public class TextUtils
   {
      
      public static const PIXEL_GUTTER:Number = 2;
      
      public static const RESIZE_BY_TWO_MIN_FONT_SIZE:int = 12;
      
      public static const RESIZE_DEFAULT_MIN_FONT_SIZE:int = 10;
      
      public static const EVEN_OUT_MULTILINE_SHRINK_FACTOR:Number = 0.9;
      
      public static const TEXT_STRIKE_THROUGH_HEIGHT_PERCENT:Number = 0.1;
      
      public static const TEXT_STRIKE_THROUGH_WIDTH_OVERFLOW_PERCENT:Number = 0.06;
      
      protected static const FILE_SIZE_TIER_KEYS:Array = [Keys.DETAIL_LABEL_FILE_SIZE_BYTE,Keys.DETAIL_LABEL_FILE_SIZE_KB,Keys.DETAIL_LABEL_FILE_SIZE_MB,Keys.DETAIL_LABEL_FILE_SIZE_GB,Keys.DETAIL_LABEL_FILE_SIZE_TB];
      
      public function TextUtils()
      {
         super();
      }
      
      public static function ResizeTextToFit(param1:TextField, param2:String, param3:Number = 0, param4:Number = 0, param5:int = 10, param6:Boolean = true, param7:Boolean = true) : Boolean
      {
         var _loc9_:Number = NaN;
         TextFieldEx.setVerticalAlign(param1,TextFieldEx.VALIGN_NONE);
         if(param7)
         {
            param1.htmlText = param2;
         }
         else
         {
            param1.text = param2;
         }
         if(param2 == "")
         {
            TextFieldEx.setVerticalAlign(param1,TextFieldEx.VALIGN_CENTER);
            return true;
         }
         param3 = param3 == 0 ? param1.width : param3;
         param4 = param4 == 0 ? param1.height : param4;
         var _loc8_:TextFormat = param1.getTextFormat();
         if(!_loc8_ || !_loc8_.size)
         {
            _loc8_ = param1.defaultTextFormat;
         }
         _loc9_ = Number(_loc8_.size);
         var _loc10_:Number = _loc9_ / Math.ceil(param1.textWidth);
         var _loc11_:* = param1.textWidth != 0 ? int(_loc10_ * param3) : int(_loc9_);
         if(_loc11_ >= _loc9_)
         {
            TextFieldEx.setVerticalAlign(param1,TextFieldEx.VALIGN_CENTER);
            return true;
         }
         if(param6 && _loc11_ > RESIZE_BY_TWO_MIN_FONT_SIZE && _loc11_ % 2 != 0)
         {
            _loc11_--;
         }
         if(_loc11_ < param5)
         {
            SetAndEllipsizeText(param1,param2,param5);
            TextFieldEx.setVerticalAlign(param1,TextFieldEx.VALIGN_CENTER);
            return false;
         }
         if(param7)
         {
            param1.htmlText = param2;
         }
         else
         {
            param1.text = param2;
         }
         _loc8_ = new TextFormat(null,_loc11_);
         param1.setTextFormat(_loc8_);
         TextFieldEx.setVerticalAlign(param1,TextFieldEx.VALIGN_CENTER);
         return true;
      }
      
      public static function SetAndEllipsizeText(param1:TextField, param2:String, param3:int = 0, param4:TextFormat = null) : String
      {
         var _loc9_:int = 0;
         var _loc5_:String = "";
         param1.htmlText = param2;
         if(param3 == 0 && param1.textWidth + PIXEL_GUTTER * 2 <= param1.width && param1.textHeight + PIXEL_GUTTER * 2 <= param1.height)
         {
            return _loc5_;
         }
         var _loc6_:TextFormat = param4;
         if(param3)
         {
            if(_loc6_ == null)
            {
               _loc6_ = new TextFormat(null,param3);
            }
            else
            {
               _loc6_.size = param3;
            }
         }
         if(_loc6_)
         {
            param1.setTextFormat(_loc6_);
         }
         var _loc7_:int = FindLastFullyVisibleCharIndex(param1);
         var _loc8_:String = Keys.GENERIC_ELLIPSES.toString();
         while(_loc7_ < param1.length - 1)
         {
            _loc9_ = Math.max(0,_loc7_ - (_loc8_.length - 1));
            param1.htmlText = param2.slice(0,_loc9_).concat(_loc8_);
            if(_loc6_)
            {
               param1.setTextFormat(_loc6_);
            }
            _loc7_ = FindLastFullyVisibleCharIndex(param1);
            _loc5_ = param2;
         }
         return _loc5_;
      }
      
      public static function TryReduceFontSize(param1:TextField, param2:int = 10) : Boolean
      {
         var _loc3_:TextFormat = param1.getTextFormat();
         var _loc4_:Number = Number(_loc3_.size);
         var _loc5_:Number = _loc4_ % 2 == 0 ? _loc4_ - 2 : _loc4_ - 1;
         if(_loc5_ < param2)
         {
            return false;
         }
         _loc3_.size = _loc5_;
         param1.setTextFormat(_loc3_);
         return true;
      }
      
      public static function SetFontSize(param1:TextField, param2:int) : void
      {
         var _loc3_:TextFormat = param1.getTextFormat();
         _loc3_.size = param2;
         param1.setTextFormat(_loc3_);
      }
      
      public static function SetShrinkAndEllipsizeForSpaceWordWrap(param1:TextField, param2:String, param3:Boolean = false, param4:Boolean = true, param5:Boolean = false, param6:int = 10) : Boolean
      {
         var _loc13_:String = null;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:Boolean = false;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:Rectangle = null;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc7_:RegExp = /(\s)/gi;
         var _loc8_:Array = param2.split(_loc7_);
         var _loc9_:Number = param1.width;
         var _loc10_:Number = param1.height;
         var _loc11_:String = param1.autoSize;
         var _loc12_:Array = new Array();
         param1.multiline = false;
         param1.wordWrap = false;
         param1.autoSize = TextFieldAutoSize.LEFT;
         var _loc14_:String = Keys.GENERIC_ELLIPSES.toString();
         param1.htmlText = _loc14_;
         var _loc15_:Number = Number(param1.getTextFormat().size);
         if(!param3)
         {
            param6 = _loc15_;
         }
         var _loc16_:TextFormat = param1.getTextFormat();
         _loc16_.size = param6;
         param1.setTextFormat(_loc16_);
         var _loc17_:Number = param1.width;
         var _loc18_:Number = _loc9_ - _loc17_;
         var _loc19_:Boolean = false;
         _loc16_.size = _loc15_;
         param1.setTextFormat(_loc16_);
         for each(_loc20_ in _loc8_)
         {
            if(_loc20_.length === 0)
            {
               _loc12_.push(_loc20_);
            }
            else
            {
               param1.htmlText = _loc20_;
               param1.setTextFormat(_loc16_);
               _loc22_ = false;
               while(param1.textWidth + PIXEL_GUTTER * 2 > _loc9_)
               {
                  if(!TryReduceFontSize(param1,param6))
                  {
                     _loc23_ = 0;
                     _loc24_ = param1.length;
                     _loc23_ = 0;
                     while(_loc23_ < _loc24_)
                     {
                        _loc25_ = param1.getCharBoundaries(_loc23_);
                        if(_loc25_.right >= _loc18_)
                        {
                           break;
                        }
                        _loc23_++;
                     }
                     _loc13_ = _loc20_.slice(0,_loc23_).concat(_loc14_);
                     _loc12_.push(_loc13_);
                     _loc19_ = true;
                     break;
                  }
                  _loc22_ = true;
               }
               if(_loc22_)
               {
                  _loc15_ = Number(param1.getTextFormat().size);
                  _loc15_ = Math.max(_loc15_,param6);
                  _loc16_.size = _loc15_;
               }
               if(_loc19_)
               {
                  break;
               }
               _loc12_.push(_loc20_);
            }
         }
         _loc21_ = _loc12_.join(" ");
         param1.wordWrap = true;
         param1.htmlText = _loc21_;
         _loc16_ = param1.getTextFormat();
         _loc16_.size = _loc15_;
         param1.setTextFormat(_loc16_);
         param1.autoSize = _loc11_;
         param1.width = _loc9_;
         if(param4)
         {
            param1.height = _loc10_;
            if(param5)
            {
               while(param1.textHeight + PIXEL_GUTTER * 2 > _loc10_)
               {
                  if(!TryReduceFontSize(param1,param6))
                  {
                     _loc26_ = FindLastFullyVisibleCharIndex(param1);
                     _loc15_ = Number(param1.getTextFormat().size);
                     while(_loc26_ < param1.length - 1)
                     {
                        _loc27_ = Math.max(0,_loc26_ - (_loc14_.length - 1));
                        param1.htmlText = _loc21_.slice(0,_loc27_).concat(_loc14_);
                        _loc16_.size = _loc15_;
                        param1.setTextFormat(_loc16_);
                        _loc26_ = FindLastFullyVisibleCharIndex(param1);
                        _loc19_ = true;
                     }
                     break;
                  }
               }
            }
         }
         return _loc19_;
      }
      
      public static function SetEllipsizeAddTooltipToText(param1:TextField, param2:String, param3:GUIComponent = null) : String
      {
         var _loc5_:GUIComponent = null;
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:TooltipExtension = null;
         var _loc4_:String = SetAndEllipsizeText(param1,param2);
         if(_loc4_ != "")
         {
            _loc5_ = param3;
            if(!_loc5_)
            {
               _loc6_ = param1.parent;
               if(_loc6_)
               {
                  _loc5_ = _loc6_.getChildByName("mcEllipsizeTooltip") as GUIComponent || new GUIComponent();
                  _loc5_.name = "mcEllipsizeTooltip";
                  _loc5_.graphics.clear();
                  _loc5_.graphics.beginFill(0,0);
                  _loc5_.graphics.drawRect(0,0,param1.textWidth,param1.textHeight);
                  _loc5_.graphics.endFill();
                  _loc5_.x = param1.x + param1.getLineMetrics(0).x;
                  _loc5_.y = param1.y + param1.getCharBoundaries(0).y;
                  _loc6_.addChild(_loc5_);
               }
            }
            if(_loc5_)
            {
               _loc7_ = _loc5_.GetExtension(TooltipExtension) as TooltipExtension;
               _loc7_.Text = param2;
            }
         }
         return _loc4_;
      }
      
      public static function FindLastFullyVisibleCharIndex(param1:TextField) : int
      {
         var _loc7_:Rectangle = null;
         var _loc2_:Number = param1.width;
         var _loc3_:int = param1.bottomScrollV - 1;
         var _loc4_:int = param1.getLineOffset(_loc3_);
         var _loc5_:int;
         var _loc6_:* = _loc5_ = _loc4_ + param1.getLineLength(_loc3_) - 1;
         while(_loc6_ >= _loc4_)
         {
            _loc7_ = param1.getCharBoundaries(_loc6_);
            if((Boolean(_loc7_)) && Boolean(_loc7_.right <= _loc2_) && param1.text.substr(_loc6_,1) != " ")
            {
               return _loc6_;
            }
            _loc6_--;
         }
         return _loc5_;
      }
      
      public static function GetBulletedList(param1:Array, param2:String = null) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc3_:String = "";
         for each(_loc4_ in param1)
         {
            _loc6_ = Keys.GENERIC_BULLET_POINT.toString(_loc4_);
            _loc3_ = _loc3_.concat(_loc6_);
         }
         _loc5_ = Keys.GENERIC_BULLET_POINT_LIST.toString(_loc3_);
         if(param2)
         {
            _loc5_ = Keys.GENERIC_NEWLINE.toString(param2,_loc5_);
         }
         return _loc5_;
      }
      
      public static function GetStringList(param1:Array) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc4_ = Keys.GENERIC_STRING_LINE_BREAK.toString(_loc3_);
            _loc2_ = _loc2_.concat(_loc4_);
         }
         return Keys.GENERIC_BULLET_POINT_LIST.toString(_loc2_);
      }
      
      public static function GetStringListAsLocKey(param1:Array) : LocKey
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc4_ = Keys.GENERIC_STRING_LINE_BREAK.toString(_loc3_);
            _loc2_ = _loc2_.concat(_loc4_);
         }
         return new LocKey({
            "hash":Keys.GENERIC_BULLET_POINT_LIST.hash,
            "tokens":[_loc2_]
         });
      }
      
      public static function TrimWhitespace(param1:String, param2:Boolean = true, param3:Boolean = true) : String
      {
         var _loc7_:* = 0;
         var _loc4_:int;
         var _loc5_:int = _loc4_ = param1.length;
         var _loc6_:int = 0;
         var _loc8_:Number = 0;
         if(param3)
         {
            _loc7_ = int(_loc4_ - 1);
            while(_loc7_ >= 0)
            {
               _loc8_ = param1.charCodeAt(_loc7_);
               if(_loc8_ > Keyboard.SPACE)
               {
                  _loc6_ = _loc7_;
                  break;
               }
               _loc7_--;
            }
         }
         else
         {
            _loc6_ = _loc4_ - 1;
         }
         if(param2)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               _loc8_ = param1.charCodeAt(_loc7_);
               if(_loc8_ > Keyboard.SPACE)
               {
                  _loc5_ = _loc7_;
                  break;
               }
               _loc7_++;
            }
         }
         else
         {
            _loc5_ = 0;
         }
         if(_loc5_ <= _loc6_)
         {
            return param1.substring(_loc5_,_loc6_ + 1);
         }
         return "";
      }
      
      public static function ColorLabelAndValueText(param1:TextField, param2:String, param3:String, param4:uint, param5:uint) : void
      {
         var _loc6_:int = 0;
         var _loc7_:TextFormat = param1.getTextFormat();
         _loc7_.color = param5;
         param1.textColor = param4;
         param1.htmlText = param2;
         _loc6_ = param1.text.length;
         param1.appendText(" ");
         param1.appendText(param3);
         param1.setTextFormat(_loc7_,_loc6_,param1.text.length);
      }
      
      public static function JoinRestrictStrings(... rest) : String
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:int = int(rest.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = rest[_loc5_];
            _loc7_ = _loc6_.split("^");
            _loc2_.push(_loc7_[0]);
            if(_loc7_.length > 1)
            {
               _loc3_.push(_loc7_[1]);
            }
            _loc5_++;
         }
         return _loc2_.join("") + "^" + _loc3_.join("");
      }
      
      public static function EscapeHtml(param1:String) : String
      {
         if(!param1)
         {
            return param1;
         }
         param1 = param1.replace(/</g,"&lt;");
         return param1.replace(/>/g,"&gt;");
      }
      
      public static function ResolveHtmlEntities(param1:String) : String
      {
         var _loc3_:Object = null;
         var _loc4_:RegExp = null;
         if(!param1)
         {
            return param1;
         }
         var _loc2_:Array = [{
            "regex":/&apos;/g,
            "str":"\'"
         },{
            "regex":/&quot;/g,
            "str":"\""
         },{
            "regex":/&amp;/g,
            "str":"&"
         }];
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.regex;
            if(_loc4_.test(param1))
            {
               _loc4_.lastIndex = 0;
               param1 = param1.split(_loc3_.regex).join(_loc3_.str);
            }
         }
         return param1;
      }
      
      public static function SetAndEscapeHtmlText(param1:TextField, param2:String) : void
      {
         param1.htmlText = EscapeHtml(param2);
      }
      
      public static function ShrinkTextToTargetHeight(param1:TextField, param2:String, param3:Number, param4:int = 10, param5:Number = 8) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:TextFormat = null;
         param1.htmlText = param2;
         if(param2 == "")
         {
            return;
         }
         var _loc6_:int = 0;
         while(_loc6_ < param4)
         {
            if(param1.height <= param3)
            {
               return;
            }
            _loc7_ = Number(param1.getTextFormat().size);
            if(_loc7_ > RESIZE_BY_TWO_MIN_FONT_SIZE)
            {
               _loc7_ = _loc7_ % 2 == 0 ? _loc7_ - 2 : _loc7_ - 1;
            }
            else
            {
               _loc7_--;
            }
            if(_loc7_ < param5)
            {
               break;
            }
            _loc8_ = param1.getTextFormat();
            _loc8_.size = _loc7_;
            param1.setTextFormat(_loc8_);
            _loc6_++;
         }
      }
      
      public static function ShrinkTextToFitMultiline(param1:TextField, param2:String, param3:Number = 0, param4:Number = 0, param5:int = 10, param6:Number = 0, param7:Number = 10) : Boolean
      {
         var _loc8_:TextFormat = null;
         param1.htmlText = param2;
         if(param2 == "")
         {
            return false;
         }
         var _loc9_:Number = Number(param1.getTextFormat().size);
         if(param6 != 0 && _loc9_ != param6)
         {
            _loc9_ = param6;
            _loc8_ = param1.getTextFormat();
            _loc8_.size = _loc9_;
            param1.setTextFormat(_loc8_);
         }
         param3 = param3 == 0 ? param1.width : param3;
         param4 = param4 == 0 ? param1.height : param4;
         var _loc10_:int = 0;
         while(_loc10_ < param5)
         {
            if(param1.textWidth + PIXEL_GUTTER * 2 <= param3 && param1.textHeight + PIXEL_GUTTER * 2 <= param4)
            {
               return true;
            }
            if(!TryReduceFontSize(param1,param7))
            {
               return false;
            }
            _loc10_++;
         }
         return false;
      }
      
      public static function ShrinkTextToFitSingleLine(param1:TextField, param2:String, param3:Number = 0, param4:Number = 0, param5:int = 10, param6:Number = 0, param7:Number = 10) : Boolean
      {
         var _loc8_:TextFormat = null;
         param1.htmlText = param2;
         if(param2 == "")
         {
            return false;
         }
         var _loc9_:Number = Number(param1.getTextFormat().size);
         if(param6 != 0 && _loc9_ != param6)
         {
            _loc9_ = param6;
            _loc8_ = param1.getTextFormat();
            _loc8_.size = _loc9_;
            param1.setTextFormat(_loc8_);
         }
         param3 = param3 == 0 ? param1.width : param3;
         param4 = param4 == 0 ? param1.height : param4;
         var _loc10_:int = 0;
         while(_loc10_ < param5)
         {
            if(param1.textWidth + PIXEL_GUTTER * 2 <= param3 && param1.textHeight + PIXEL_GUTTER * 2 <= param4 && param1.numLines == 1)
            {
               return true;
            }
            if(!TryReduceFontSize(param1,param7))
            {
               return false;
            }
            _loc10_++;
         }
         return false;
      }
      
      public static function ShrinkTextToFitNLines(param1:TextField, param2:String, param3:int, param4:Number = 0, param5:Number = 0, param6:int = 10, param7:Number = 0, param8:Number = 10) : Boolean
      {
         var _loc9_:TextFormat = param1.getTextFormat();
         var _loc10_:Number = Number(_loc9_.size);
         if(param7 != 0 && _loc10_ != param7)
         {
            _loc10_ = param7;
            _loc9_.size = _loc10_;
         }
         param1.htmlText = param2;
         if(_loc9_)
         {
            DisableExtraBoldFromBoldFont(_loc9_);
            param1.setTextFormat(_loc9_);
         }
         if(param2 == "")
         {
            return true;
         }
         param4 = param4 == 0 ? param1.width : param4;
         param5 = param5 == 0 ? param1.height : param5;
         var _loc11_:int = 0;
         while(_loc11_ < param6)
         {
            if(param1.textWidth + PIXEL_GUTTER * 2 <= param4 && param1.textHeight + PIXEL_GUTTER * 2 <= param5 && param1.numLines <= param3)
            {
               return true;
            }
            if(!TryReduceFontSize(param1,param8))
            {
               return false;
            }
            _loc11_++;
         }
         return false;
      }
      
      public static function ShrinkTextToFitNLinesOrEllipsize(param1:TextField, param2:String, param3:int, param4:Number, param5:Number, param6:String, param7:String) : Boolean
      {
         var _loc8_:Boolean = false;
         var _loc9_:TextFormat = param1.getTextFormat();
         if(_loc9_.size != param4 || _loc9_.align != param6)
         {
            _loc9_.align = param6;
            _loc9_.size = param4;
            param1.setTextFormat(_loc9_);
         }
         param1.wordWrap = true;
         param1.multiline = true;
         if(!TextUtils.ShrinkTextToFitNLines(param1,param2,param3,0,0,10,param4,param5))
         {
            if(param3 == 1)
            {
               param1.wordWrap = false;
            }
            _loc9_ = param1.getTextFormat();
            TextUtils.SetAndEllipsizeText(param1,param2,param5,_loc9_);
            _loc8_ = true;
         }
         if(param7)
         {
            TextFieldEx.setVerticalAlign(param1,param7);
         }
         return _loc8_;
      }
      
      public static function ShrinkMultilineTextFieldToNLinesOrEllipsize(param1:TextField, param2:String, param3:int, param4:Number, param5:Number, param6:String) : Boolean
      {
         var _loc7_:Boolean = false;
         var _loc8_:TextFormat = param1.getTextFormat();
         if(_loc8_.size != param4 || _loc8_.align != param6)
         {
            _loc8_.align = param6;
            _loc8_.size = param4;
            param1.setTextFormat(_loc8_);
         }
         param1.wordWrap = true;
         param1.multiline = true;
         var _loc9_:Number = (param4 + _loc8_.leading) * param3 + TextUtils.PIXEL_GUTTER * 2;
         param1.height = _loc9_;
         if(!TextUtils.ShrinkTextToFitNLines(param1,param2,param3,0,_loc9_,10,param4,param5))
         {
            if(param3 == 1)
            {
               param1.wordWrap = false;
            }
            _loc8_ = param1.getTextFormat();
            _loc9_ = (_loc8_.size + _loc8_.leading) * param3 + TextUtils.PIXEL_GUTTER * 2;
            param1.height = _loc9_;
            TextUtils.SetAndEllipsizeText(param1,param2,param5,_loc8_);
            _loc7_ = true;
         }
         param1.height = TextUtils.GetLastCharHeight(param1) + TextUtils.PIXEL_GUTTER * 2;
         return _loc7_;
      }
      
      public static function EvenOutMultilineTextField(param1:TextField, param2:int = 0, param3:Number = 0, param4:Number = 0.9) : *
      {
         if(!param1.multiline || param1.numLines <= 1)
         {
            return;
         }
         if(param4 >= 1)
         {
            return;
         }
         param2 = param2 == 0 ? param1.numLines : param2;
         param3 = param3 == 0 ? param1.width : param3;
         var _loc5_:Number = param3;
         while(param1.numLines <= param2)
         {
            _loc5_ = param1.width;
            param1.width *= param4;
         }
         param1.width = _loc5_;
      }
      
      public static function FormatDiscountedTextfieldWithStrikeThrough(param1:TextField, param2:String, param3:uint, param4:Sprite, param5:Function = null) : void
      {
         param1.text = param2;
         var _loc6_:int = param2.indexOf("\n");
         if(_loc6_ < 0)
         {
            return;
         }
         var _loc7_:TextFormat = param1.getTextFormat();
         _loc7_.align = TextFormatAlign.CENTER;
         _loc7_.color = param3;
         param1.setTextFormat(_loc7_,_loc6_ + 1);
         TextUtils.FitStrikeThroughLineToText(param1,param4,0,_loc6_ - 1,param5);
      }
      
      public static function GenericFormatDiscountedTextfieldWithStrikeThrough(param1:TextField, param2:String, param3:uint, param4:Sprite, param5:String = "\n", param6:Function = null) : void
      {
         param1.text = param2;
         var _loc7_:int = param2.indexOf(param5);
         if(_loc7_ < 0)
         {
            return;
         }
         var _loc8_:TextFormat = param1.getTextFormat();
         _loc8_.align = TextFormatAlign.CENTER;
         _loc8_.color = param3;
         param1.setTextFormat(_loc8_,_loc7_ + 1);
         TextUtils.FitStrikeThroughLineToText(param1,param4,0,_loc7_ - 1,param6);
      }
      
      public static function FitStrikeThroughLineToText(param1:TextField, param2:Sprite, param3:int = -1, param4:int = -1, param5:Function = null) : void
      {
         var _loc9_:Number = NaN;
         if(param3 == -1)
         {
            param3 = 0;
         }
         if(param4 == -1)
         {
            param4 = param1.text.length - 1;
         }
         var _loc6_:* = new Point();
         if(param5 != null)
         {
            _loc6_ = param5(param1);
         }
         var _loc7_:Rectangle = param1.getCharBoundaries(param3);
         var _loc8_:Rectangle = param1.getCharBoundaries(param4);
         if(!_loc7_ || !_loc8_)
         {
            return;
         }
         _loc9_ = _loc8_.right - _loc7_.left;
         var _loc10_:Number = _loc9_ * TEXT_STRIKE_THROUGH_WIDTH_OVERFLOW_PERCENT;
         var _loc11_:Graphics = param2.graphics;
         _loc11_.clear();
         _loc11_.beginFill(param1.textColor);
         _loc11_.drawRect(_loc6_.x,_loc6_.y,_loc9_ + 2 * _loc10_,Number(param1.getTextFormat().size) * TEXT_STRIKE_THROUGH_HEIGHT_PERCENT);
         _loc11_.endFill();
         var _loc12_:int = param1.getLineIndexOfChar(param3);
         var _loc13_:TextLineMetrics = param1.getLineMetrics(_loc12_);
         param2.x = param1.x + _loc13_.x + _loc7_.x - _loc10_;
         param2.y = param1.y + _loc7_.y + 0.5 * (_loc8_.bottom - _loc7_.top) + param2.height;
      }
      
      public static function AutosizeTextFieldToFitWidestWord(param1:TextField, param2:String, param3:String, param4:Number = 0) : void
      {
         var _loc5_:RegExp = /(\s)/gi;
         var _loc6_:Array = param2.split(_loc5_);
         var _loc7_:String = _loc6_.join("\n");
         param1.htmlText = "";
         param1.wordWrap = false;
         param1.multiline = false;
         param1.autoSize = TextFieldAutoSize.LEFT;
         param1.htmlText = _loc7_;
         var _loc8_:Number = param1.width;
         param1.wordWrap = true;
         param1.multiline = true;
         param1.autoSize = param3;
         param1.width = Math.max(_loc8_,param4);
         param1.htmlText = param2;
      }
      
      public static function ShrinkTextToFitWidestWord(param1:TextField, param2:String, param3:String, param4:Number = 0, param5:Number = 10) : void
      {
         var _loc10_:TextFormat = null;
         var _loc6_:RegExp = /(\s)/gi;
         var _loc7_:Array = param2.split(_loc6_);
         var _loc8_:String = _loc7_.join("\n");
         var _loc9_:Number = param1.width;
         var _loc11_:Number = Number(param1.getTextFormat().size);
         if(_loc11_ == 0)
         {
            _loc11_ = Number(param1.defaultTextFormat.size);
         }
         if(param4 != 0 && _loc11_ != param4)
         {
            _loc11_ = param4;
            _loc10_ = param1.getTextFormat();
            _loc10_.size = _loc11_;
            param1.setTextFormat(_loc10_);
         }
         param1.htmlText = "";
         param1.wordWrap = false;
         param1.multiline = false;
         param1.autoSize = TextFieldAutoSize.LEFT;
         param1.htmlText = _loc8_;
         var _loc12_:Number = param1.width;
         while(_loc12_ > _loc9_)
         {
            if(!TryReduceFontSize(param1,param5))
            {
               break;
            }
         }
         _loc11_ = Number(param1.getTextFormat().size);
         param1.wordWrap = true;
         param1.multiline = true;
         param1.autoSize = param3;
         param1.width = _loc9_;
         param1.htmlText = param2;
         _loc10_ = param1.getTextFormat();
         _loc10_.size = _loc11_;
         param1.setTextFormat(_loc10_);
      }
      
      public static function GetLastCharHeight(param1:TextField) : Number
      {
         if(param1.numLines == 0)
         {
            return 0;
         }
         var _loc2_:Number = param1.textHeight;
         var _loc3_:int = param1.getLineOffset(param1.numLines - 1);
         var _loc4_:Rectangle = param1.getCharBoundaries(_loc3_);
         if(_loc4_)
         {
            _loc2_ = Math.min(_loc2_,_loc4_.bottom);
         }
         return _loc2_;
      }
      
      public static function AutosizeMultilineTextField(param1:TextField, param2:String) : void
      {
         var _loc3_:Number = param1.width;
         param1.multiline = true;
         param1.wordWrap = true;
         param1.autoSize = TextFieldAutoSize.LEFT;
         param1.htmlText = param2;
         param1.width = _loc3_;
      }
      
      public static function SetTextFieldAsMultiLineCentered(param1:TextField) : void
      {
         param1.multiline = true;
         param1.wordWrap = true;
         param1.autoSize = TextFieldAutoSize.NONE;
         var _loc2_:TextFormat = param1.getTextFormat();
         _loc2_.align = TextFieldAutoSize.CENTER;
         param1.setTextFormat(_loc2_);
      }
      
      public static function WrapTextInHtmlSpan(param1:String, param2:String) : String
      {
         return "<span class=\"" + param2 + "\">" + param1 + "</span>";
      }
      
      public static function StyleSheetFromObject(param1:Object) : StyleSheet
      {
         var _loc3_:String = null;
         var _loc2_:StyleSheet = new StyleSheet();
         for(_loc3_ in param1)
         {
            _loc2_.setStyle(_loc3_,param1[_loc3_]);
         }
         return _loc2_;
      }
      
      public static function GetSubtextRect(param1:TextField, param2:String) : Rectangle
      {
         var _loc3_:int = param1.text.indexOf(param2);
         if(_loc3_ < 0)
         {
            return null;
         }
         var _loc4_:Rectangle = param1.getCharBoundaries(_loc3_);
         var _loc5_:int = param1.getLineIndexOfChar(_loc3_);
         var _loc6_:int = _loc3_ + param2.length - 1;
         var _loc7_:Rectangle = param1.getCharBoundaries(_loc6_);
         var _loc8_:int = param1.getLineIndexOfChar(_loc6_);
         _loc4_.x += param1.getLineMetrics(_loc5_).x;
         _loc7_.x += param1.getLineMetrics(_loc8_).x;
         _loc4_.offset(PIXEL_GUTTER,PIXEL_GUTTER);
         _loc7_.offset(PIXEL_GUTTER,PIXEL_GUTTER);
         return _loc4_.union(_loc7_);
      }
      
      public static function SetCurrentBudgetText(param1:int, param2:int, param3:String, param4:String, param5:TextField, param6:TextField) : void
      {
         var _loc7_:Boolean = param2 > param1;
         var _loc8_:String = _loc7_ ? TextUtils.WrapTextInHtmlSpan(Keys.GENERIC_MONEY.toString(param2),"negative") : Keys.GENERIC_MONEY.toString(param2);
         var _loc9_:String = Keys.GENERIC_STRING_SLASH_STRING.toString(_loc8_,Keys.GENERIC_MONEY.toString(param1));
         TextUtils.ResizeTextToFit(param5,_loc9_);
         TextUtils.ResizeTextToFit(param6,_loc7_ ? param4 : param3);
         if(!_loc7_)
         {
            param6.setTextFormat(param6.defaultTextFormat);
         }
      }
      
      public static function GenerateLinkInputProxies(param1:TextField, param2:Function = null) : Vector.<DisplayObject>
      {
         var links:XMLList = null;
         var linkElement:XML = null;
         var linkRect:Rectangle = null;
         var textField:TextField = param1;
         var createProxy:Function = param2;
         var elements:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         if(!createProxy)
         {
            createProxy = LinkInputProxy.Create;
         }
         try
         {
            links = XMLList(textField.htmlText).descendants("A");
            for each(linkElement in links)
            {
               linkRect = GetSubtextRect(textField,linkElement.text().toString());
               elements.push(createProxy(textField,linkRect));
            }
         }
         catch(error:Error)
         {
         }
         return elements;
      }
      
      public static function ResizeHeightOfTextFieldAndClipToFitText(param1:TextField, param2:DisplayObject) : void
      {
         var _loc3_:Number = NaN;
         if(param1.textHeight + PIXEL_GUTTER * 2 > param1.height)
         {
            _loc3_ = param2.height - param1.height;
            param1.height = GetLastCharHeight(param1) + PIXEL_GUTTER * 2;
            param2.height = param1.height + _loc3_;
         }
      }
      
      public static function AllCharactersEqualTo(param1:String, param2:uint) : Boolean
      {
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1.charCodeAt(_loc4_) != param2)
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      public static function EstimateNumberOfLines(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = param1.length;
         if(param1.length == 0)
         {
            return 0;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1.charAt(_loc4_) == "\n")
            {
               _loc2_++;
            }
            _loc4_++;
         }
         return _loc2_ + 1;
      }
      
      public static function RoundToEven(param1:Number) : Number
      {
         var _loc2_:Number = Math.floor(param1);
         var _loc3_:Number = param1 - _loc2_;
         var _loc4_:Number = 0.0001;
         if(Math.abs(_loc3_ - 0.5) < _loc4_ || Math.abs(_loc3_ + 0.5) < _loc4_)
         {
            return _loc2_ % 2 == 0 ? _loc2_ : _loc2_ + (param1 > 0 ? 1 : -1);
         }
         return Math.round(param1);
      }
      
      public static function DisableExtraBoldFromBoldFont(param1:TextFormat) : void
      {
         if(Boolean(param1.font) && param1.font.indexOf("Bold") != -1)
         {
            param1.bold = false;
         }
      }
      
      public static function GetFileSizeText(param1:Number, param2:Boolean = true) : String
      {
         var _loc3_:int = FILE_SIZE_TIER_KEYS.length - 1;
         var _loc4_:int = 0;
         while(param1 >= 1000 && _loc4_ < _loc3_)
         {
            param1 *= 0.001;
            _loc4_++;
            if(param2 && Math.round(param1) > param1)
            {
               param1++;
            }
         }
         return (FILE_SIZE_TIER_KEYS[_loc4_] as LocKey).toString(param2 ? int(param1) : param1);
      }
   }
}

