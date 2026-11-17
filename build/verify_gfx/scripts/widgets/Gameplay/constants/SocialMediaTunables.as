package widgets.Gameplay.constants
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import gamedata.Gameplay.SocialMedia.SocialMediaFeedItem;
   import olympus.constants.Alignment;
   import olympus.core.tooltip.Tooltip;
   import olympus.core.tooltip.TooltipObject;
   import olympus.core.widget.Margin;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import widgets.Gameplay.SocialMedia.IconResource22x22;
   
   public final class SocialMediaTunables
   {
      
      public static const FEED_LIST_CELL_PADDING:Margin = Margin.TopRightBottomLeft(2,0,0,2);
      
      public static const FEED_SCROLLBAR_PADDING:Margin = Margin.TopRightBottomLeft(0,27,5,1);
      
      public static const FEED_TAB_PANEL_HEIGHT:int = 360;
      
      public static const FEED_TAB_PANEL_MARGINS:Margin = Margin.TopRightBottomLeft(1,3,15,5);
      
      public static const FRIENDS_LIST_CELL_PADDING:Margin = Margin.TopRightBottomLeft(2,0,0,2);
      
      public static const FRIENDS_SCROLLBAR_PADDING:Margin = Margin.TopRightBottomLeft(0,27,5,1);
      
      public static const FRIENDS_TAB_PANEL_HEIGHT:int = 360;
      
      public static const FRIENDS_TAB_PANEL_MARGINS:Margin = Margin.TopRightBottomLeft(1,3,15,5);
      
      public static const FRIENDS_TAB_PANEL_PADDING:int = 20;
      
      public static const DM_LIST_CELL_PADDING:Margin = Margin.TopRightBottomLeft(2,0,0,2);
      
      public static const DM_SCROLLBAR_PADDING:Margin = Margin.TopRightBottomLeft(0,27,5,1);
      
      public static const DM_TAB_PANEL_HEIGHT:int = 360;
      
      public static const DM_TAB_PANEL_MARGINS:Margin = Margin.TopRightBottomLeft(1,3,15,5);
      
      public static const DM_TAB_PANEL_PADDING:int = 20;
      
      public static const REACTION_GRID_COLUMNS:int = 6;
      
      public static var REACTION_CELL_MARGIN:Margin = new Margin(0,0,1,0);
      
      public static var REACTIONS_POPUP_ANIMATION_DELAY:Number = 250;
      
      public static var REACTIONS_POPUP_ARROW_HEIGHT:Number = 13;
      
      public static var REACTION_POPUP_ALIGNMENT:Number = 0.75;
      
      public static const PACKET_TYPE_CORE_STATE:int = 100;
      
      public static const DDS_VERIFIED:String = "img://0x7A4E910000000001";
      
      public static const DDS_OFFICIAL:String = "img://0x7A4E910000000002";
      
      public static const DDS_CREATOR:String = "img://0x7A4E910000000003";
      
      public static const DDS_LEGACY:String = "img://0x7A4E910000000004";
      
      public static const COL_BG_CANVAS:uint = 16054009;
      
      public static const COL_SURFACE:uint = 16777215;
      
      public static const COL_SURFACE_ALT:uint = 15659767;
      
      public static const COL_BORDER:uint = 14476268;
      
      public static const COL_TEXT_PRIMARY:uint = 988970;
      
      public static const COL_TEXT_SECONDARY:uint = 4674921;
      
      public static const COL_TEXT_MUTED:uint = 6583435;
      
      public static const COL_BRAND_BLUE:uint = 1940464;
      
      public static const COL_BRAND_DARK:uint = 608683;
      
      public static const COL_OFFICIAL_GOLD:uint = 15443996;
      
      public static const COL_CREATOR_PURPLE:uint = 9133302;
      
      public static const COL_LIKE_RED:uint = 14753096;
      
      public static const COL_GREEN:uint = 1096065;
      
      public static const COL_WARN:uint = 14251782;
      
      public static const COL_DANGER:uint = 14427686;
      
      public static var sLastSBVState:Object = null;
      
      public static var sBadgesMap:Object = new Object();
      
      private static var sJsonStr:String = "";
      
      private static var sJsonPos:int = 0;
      
      public function SocialMediaTunables()
      {
         super();
      }
      
      public static function ParseJSON(src:String) : *
      {
         if(!src || src == "")
         {
            return null;
         }
         sJsonStr = src;
         sJsonPos = 0;
         return ReadJsonValue();
      }
      
      private static function SkipWs() : void
      {
         var len:int = sJsonStr.length;
         while(sJsonPos < len)
         {
            var ch:String = sJsonStr.charAt(sJsonPos);
            if(!(ch == " " || ch == "\t" || ch == "\n" || ch == "\r"))
            {
               break;
            }
            ++sJsonPos;
         }
      }
      
      private static function ReadJsonValue() : *
      {
         SkipWs();
         if(sJsonPos >= sJsonStr.length)
         {
            return null;
         }
         var ch:String = sJsonStr.charAt(sJsonPos);
         if(ch == "{")
         {
            return ReadJsonObject();
         }
         if(ch == "[")
         {
            return ReadJsonArray();
         }
         if(ch == "\"")
         {
            return ReadJsonString();
         }
         if(ch == "t")
         {
            sJsonPos += 4;
            return true;
         }
         if(ch == "f")
         {
            sJsonPos += 5;
            return false;
         }
         if(ch == "n")
         {
            sJsonPos += 4;
            return null;
         }
         return ReadJsonNumber();
      }
      
      private static function ReadJsonObject() : Object
      {
         var obj:Object = new Object();
         ++sJsonPos;
         SkipWs();
         if(sJsonPos < sJsonStr.length && sJsonStr.charAt(sJsonPos) == "}")
         {
            ++sJsonPos;
            return obj;
         }
         var len:int = sJsonStr.length;
         while(sJsonPos < len)
         {
            SkipWs();
            if(sJsonStr.charAt(sJsonPos) != "\"")
            {
               break;
            }
            var key:String = ReadJsonString();
            SkipWs();
            if(sJsonPos < len && sJsonStr.charAt(sJsonPos) == ":")
            {
               ++sJsonPos;
            }
            obj[key] = ReadJsonValue();
            SkipWs();
            var sep:String = sJsonPos < len ? sJsonStr.charAt(sJsonPos) : "}";
            if(sep != ",")
            {
               if(sep == "}")
               {
                  ++sJsonPos;
               }
               break;
            }
            ++sJsonPos;
         }
         return obj;
      }
      
      private static function ReadJsonArray() : Array
      {
         var arr:Array = new Array();
         ++sJsonPos;
         SkipWs();
         if(sJsonPos < sJsonStr.length && sJsonStr.charAt(sJsonPos) == "]")
         {
            ++sJsonPos;
            return arr;
         }
         var len:int = sJsonStr.length;
         while(sJsonPos < len)
         {
            arr.push(ReadJsonValue());
            SkipWs();
            var sep:String = sJsonPos < len ? sJsonStr.charAt(sJsonPos) : "]";
            if(sep != ",")
            {
               if(sep == "]")
               {
                  ++sJsonPos;
               }
               break;
            }
            ++sJsonPos;
         }
         return arr;
      }
      
      private static function ReadJsonString() : String
      {
         ++sJsonPos;
         var out:String = "";
         var len:int = sJsonStr.length;
         while(sJsonPos < len)
         {
            var ch:String = sJsonStr.charAt(sJsonPos++);
            if(ch == "\"")
            {
               break;
            }
            if(ch == "\\")
            {
               if(sJsonPos >= len)
               {
                  break;
               }
               var esc:String = sJsonStr.charAt(sJsonPos++);
               if(esc == "\"" || esc == "\\" || esc == "/")
               {
                  out += esc;
               }
               else if(esc == "n")
               {
                  out += "\n";
               }
               else if(esc == "r")
               {
                  out += "\r";
               }
               else if(esc == "t")
               {
                  out += "\t";
               }
               else if(esc == "u" && sJsonPos + 4 <= len)
               {
                  var hex:String = sJsonStr.substr(sJsonPos,4);
                  sJsonPos += 4;
                  out += String.fromCharCode(parseInt(hex,16));
               }
               else
               {
                  out += esc;
               }
            }
            else
            {
               out += ch;
            }
         }
         return out;
      }
      
      private static function ReadJsonNumber() : Number
      {
         var start:int = sJsonPos;
         var len:int = sJsonStr.length;
         while(sJsonPos < len)
         {
            var ch:String = sJsonStr.charAt(sJsonPos);
            if(!(ch >= "0" && ch <= "9" || ch == "-" || ch == "+" || ch == "." || ch == "e" || ch == "E"))
            {
               break;
            }
            ++sJsonPos;
         }
         var numStr:String = sJsonStr.substring(start,sJsonPos);
         return Number(numStr);
      }
      
      public static function ExtractSBVState(rawItems:Array) : Object
      {
         var i:int;
         var item:SocialMediaFeedItem;
         var idx:int;
         var parsed:Object;
         var joined:String;
         var c:int;
         var nativeList:Array = new Array();
         var chunks:Array = new Array();
         if(rawItems != null)
         {
            i = 0;
            while(i < rawItems.length)
            {
               item = rawItems[i] as SocialMediaFeedItem;
               if(item != null && item.post_type >= PACKET_TYPE_CORE_STATE)
               {
                  idx = int(Number(item.post_id)) - 9000000;
                  if(idx < 0 || idx > 64)
                  {
                     idx = chunks.length;
                  }
                  chunks[idx] = item.post_text ? item.post_text.toString() : "";
               }
               else if(item != null)
               {
                  nativeList.push(item);
               }
               i++;
            }
         }
         parsed = null;
         if(chunks.length > 0)
         {
            joined = "";
            c = 0;
            while(c < chunks.length)
            {
               if(chunks[c] != null)
               {
                  joined += String(chunks[c]);
               }
               c++;
            }
            if(joined.length > 0)
            {
               try
               {
                  parsed = ParseJSON(joined) as Object;
               }
               catch(err:Error)
               {
                  parsed = null;
               }
            }
         }
         if(parsed != null)
         {
            sLastSBVState = parsed;
            if(parsed.badges_map != null)
            {
               sBadgesMap = parsed.badges_map;
            }
         }
         return {
            "nativeItems":nativeList,
            "sbvState":(parsed != null ? parsed : sLastSBVState)
         };
      }
      
      public static function SendAction(simId:String, action:String, arg1:String = "", arg2:String = "", arg3:String = "") : void
      {
         CommunicationManager.PostServerCommand("sbv.action",simId,action,encodeURIComponent(arg1 != null ? arg1 : ""),encodeURIComponent(arg2 != null ? arg2 : ""),encodeURIComponent(arg3 != null ? arg3 : ""));
      }
      
      public static function FormatAge(minutes:int) : String
      {
         if(minutes < 1)
         {
            return "Just now";
         }
         if(minutes < 60)
         {
            return minutes + "m";
         }
         var hrs:int = int(minutes / 60);
         if(hrs < 24)
         {
            return hrs + "h";
         }
         var days:int = int(hrs / 24);
         return days + "d";
      }
      
      public static function GetBadgeForSim(simId:String) : String
      {
         if(sBadgesMap != null && simId != null && sBadgesMap[simId] != null)
         {
            return String(sBadgesMap[simId].badge || "none");
         }
         return "none";
      }
      
      public static function CreateBadgeSprite(size:Number = 16, withTooltip:Boolean = false) : Sprite
      {
         var container:Sprite = new Sprite();
         container.mouseChildren = false;
         if(withTooltip)
         {
            container.buttonMode = true;
            container.useHandCursor = false;
            var icon:IconResource22x22 = new IconResource22x22();
            icon.name = "mcBadgeIcon";
            icon.width = size;
            icon.height = size;
            container.addChild(icon);
            var tip:TooltipObject = new TooltipObject(container,Tooltip);
            tip.VerticalAlignment = Alignment.TOP;
            tip.HorizontalAlignment = Alignment.CENTER;
            tip.FallbackDirection = Alignment.BOTTOM;
            tip.Initialize(new Object());
            container["mTooltipObj"] = tip;
         }
         else
         {
            container.mouseEnabled = false;
         }
         container["mSize"] = size;
         return container;
      }
      
      public static function UpdateBadgeSprite(badge:Sprite, kind:String, tipText:String = "") : void
      {
         if(!badge)
         {
            return;
         }
         var size:Number = Number(badge["mSize"]);
         if(!size || isNaN(size))
         {
            size = 16;
         }
         var tip:TooltipObject = badge["mTooltipObj"] as TooltipObject;
         var icon:IconResource22x22 = badge.getChildByName("mcBadgeIcon") as IconResource22x22;
         badge.graphics.clear();
         if(!kind || kind == "none" || kind == "")
         {
            badge.visible = false;
            if(tip)
            {
               tip.SetText(null);
            }
            return;
         }
         badge.visible = true;
         var color:uint = COL_BRAND_BLUE;
         var defaultTip:String = "Verified Account";
         var url:String = DDS_VERIFIED;
         if(kind == "official")
         {
            color = COL_OFFICIAL_GOLD;
            defaultTip = "Official Account";
            url = DDS_OFFICIAL;
         }
         else if(kind == "creator")
         {
            color = COL_CREATOR_PURPLE;
            defaultTip = "Professional Creator";
            url = DDS_CREATOR;
         }
         else if(kind == "legacy")
         {
            color = COL_TEXT_MUTED;
            defaultTip = "Legacy Verified";
            url = DDS_LEGACY;
         }
         var r:Number = size * 0.5;
         badge.graphics.beginFill(color,1);
         badge.graphics.drawCircle(r,r,r - 1);
         badge.graphics.endFill();
         badge.graphics.lineStyle(Math.max(1.5,size * 0.13),16777215,1);
         if(kind == "creator")
         {
            badge.graphics.moveTo(r,r * 0.45);
            badge.graphics.lineTo(r,r * 1.55);
            badge.graphics.moveTo(r * 0.45,r);
            badge.graphics.lineTo(r * 1.55,r);
         }
         else
         {
            badge.graphics.moveTo(size * 0.28,size * 0.52);
            badge.graphics.lineTo(size * 0.44,size * 0.68);
            badge.graphics.lineTo(size * 0.74,size * 0.34);
         }
         if(icon)
         {
            icon.LoadImage(url);
         }
         if(tip)
         {
            tip.SetText(LocKey.UntranslatedString(tipText != "" ? tipText : defaultTip));
         }
      }
      
      public static function CreateLabel(txt:String, size:int = 12, color:uint = 988970, bold:Boolean = false, w:Number = 200, h:Number = 20, multiline:Boolean = false, align:String = "left") : TextField
      {
         var tf:TextField = new TextField();
         tf.width = w;
         tf.height = h;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.multiline = multiline;
         tf.wordWrap = multiline;
         var fmt:TextFormat = new TextFormat(bold ? "$HeadlineFont" : "$TextFont",size,color,bold);
         fmt.align = align;
         tf.defaultTextFormat = fmt;
         tf.text = txt != null ? txt : "";
         tf.setTextFormat(fmt);
         return tf;
      }
      
      public static function CreateInputBox(initialText:String, w:Number, h:Number, multiline:Boolean = false, maxChars:int = 220) : Sprite
      {
         var box:Sprite = new Sprite();
         box.graphics.lineStyle(1,COL_BORDER,1);
         box.graphics.beginFill(COL_SURFACE,1);
         box.graphics.drawRoundRect(0,0,w,h,8,8);
         box.graphics.endFill();
         var tf:TextField = new TextField();
         tf.name = "inputField";
         tf.type = TextFieldType.INPUT;
         tf.selectable = true;
         tf.mouseEnabled = true;
         tf.multiline = multiline;
         tf.wordWrap = multiline;
         tf.maxChars = maxChars;
         tf.x = 8;
         tf.y = 4;
         tf.width = w - 16;
         tf.height = h - 8;
         var fmt:TextFormat = new TextFormat("$TextFont",12,COL_TEXT_PRIMARY,false);
         tf.defaultTextFormat = fmt;
         tf.text = initialText != null ? initialText : "";
         tf.setTextFormat(fmt);
         box.addChild(tf);
         box["tf"] = tf;
         return box;
      }
      
      public static function CreateCard(w:Number, h:Number, fill:uint = 16777215, border:uint = 14476268, radius:Number = 10) : Sprite
      {
         var s:Sprite = new Sprite();
         if(border != 0)
         {
            s.graphics.lineStyle(1,border,1);
         }
         s.graphics.beginFill(fill,1);
         s.graphics.drawRoundRect(0,0,w,h,radius,radius);
         s.graphics.endFill();
         return s;
      }
      
      public static function CreateButton(label:String, w:Number, h:Number, bgColor:uint, textColor:uint, onClick:Function, fontSize:int = 11, borderColor:uint = 0) : Sprite
      {
         var lbl:TextField;
         var btn:Sprite = new Sprite();
         btn.buttonMode = true;
         btn.useHandCursor = true;
         btn.mouseChildren = false;
         btn["bgColor"] = bgColor;
         btn["borderColor"] = borderColor;
         btn["btnW"] = w;
         btn["btnH"] = h;
         DrawButtonFace(btn,bgColor,borderColor,w,h,1);
         lbl = CreateLabel(label,fontSize,textColor,true,w - 8,h - 2,false,TextFormatAlign.CENTER);
         lbl.name = "lbl";
         lbl.x = 4;
         lbl.y = Math.max(1,(h - (fontSize + 7)) * 0.5);
         btn.addChild(lbl);
         btn.addEventListener(MouseEvent.ROLL_OVER,function(e:MouseEvent):void
         {
            DrawButtonFace(btn,bgColor,borderColor,w,h,0.85);
         },false,0,true);
         btn.addEventListener(MouseEvent.ROLL_OUT,function(e:MouseEvent):void
         {
            DrawButtonFace(btn,bgColor,borderColor,w,h,1);
         },false,0,true);
         btn.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void
         {
            DrawButtonFace(btn,bgColor,borderColor,w,h,0.7);
         },false,0,true);
         btn.addEventListener(MouseEvent.MOUSE_UP,function(e:MouseEvent):void
         {
            DrawButtonFace(btn,bgColor,borderColor,w,h,0.9);
         },false,0,true);
         if(onClick != null)
         {
            btn.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         }
         return btn;
      }
      
      private static function DrawButtonFace(btn:Sprite, bg:uint, border:uint, w:Number, h:Number, alphaVal:Number) : void
      {
         var g:Graphics = btn.graphics;
         g.clear();
         if(border != 0)
         {
            g.lineStyle(1,border,1);
         }
         g.beginFill(bg,alphaVal);
         g.drawRoundRect(0,0,w,h,8,8);
         g.endFill();
      }
      
      public static function DrawBarChart(container:Sprite, title:String, labels:Array, values:Array, w:Number, h:Number, barColor:uint) : void
      {
         var card:Sprite = CreateCard(w,h,COL_SURFACE,COL_BORDER,10);
         container.addChild(card);
         var titleTf:TextField = CreateLabel(title,12,COL_TEXT_PRIMARY,true,w - 20,20);
         titleTf.x = 10;
         titleTf.y = 8;
         card.addChild(titleTf);
         var plotX:Number = 14;
         var plotY:Number = 32;
         var plotW:Number = w - 28;
         var plotH:Number = h - 56;
         if(values == null || values.length == 0)
         {
            var emptyTf:TextField = CreateLabel("No data recorded yet",11,COL_TEXT_MUTED,false,plotW,20,false,TextFormatAlign.CENTER);
            emptyTf.x = plotX;
            emptyTf.y = plotY + plotH * 0.4;
            card.addChild(emptyTf);
            return;
         }
         var maxVal:Number = 1;
         var i:int = 0;
         while(i < values.length)
         {
            if(Number(values[i]) > maxVal)
            {
               maxVal = Number(values[i]);
            }
            i++;
         }
         card.graphics.lineStyle(1,COL_BORDER,1);
         card.graphics.moveTo(plotX,plotY + plotH);
         card.graphics.lineTo(plotX + plotW,plotY + plotH);
         var count:int = int(values.length);
         var step:Number = plotW / count;
         var barW:Number = Math.max(8,Math.min(26,step * 0.58));
         i = 0;
         while(i < count)
         {
            var val:Number = Number(values[i]);
            var barH:Number = Math.max(3,val / maxVal * (plotH - 12));
            var bx:Number = plotX + i * step + (step - barW) * 0.5;
            var by:Number = plotY + plotH - barH;
            card.graphics.lineStyle(0,0,0);
            card.graphics.beginFill(barColor,0.9);
            card.graphics.drawRoundRect(bx,by,barW,barH,4,4);
            card.graphics.endFill();
            var valTf:TextField = CreateLabel(String(int(val)),9,COL_TEXT_SECONDARY,false,step,14,false,TextFormatAlign.CENTER);
            valTf.x = plotX + i * step;
            valTf.y = Math.max(plotY - 4,by - 14);
            card.addChild(valTf);
            if(labels != null && i < labels.length)
            {
               var labTf:TextField = CreateLabel(String(labels[i]),9,COL_TEXT_MUTED,false,step,14,false,TextFormatAlign.CENTER);
               labTf.x = plotX + i * step;
               labTf.y = plotY + plotH + 3;
               card.addChild(labTf);
            }
            i++;
         }
      }
   }
}

