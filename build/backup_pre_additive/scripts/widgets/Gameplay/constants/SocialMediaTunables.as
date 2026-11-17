package widgets.Gameplay.constants
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import gamedata.Gameplay.SocialMedia.SocialMediaFeedItem;
   import olympus.core.widget.Margin;
   import olympus.io.CommunicationManager;
   
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

      // Modern Instagram-inspired + Sims 4 neutral palette
      public static const COL_BG_CANVAS:uint = 0xF4F6F9;
      public static const COL_SURFACE:uint = 0xFFFFFF;
      public static const COL_SURFACE_ALT:uint = 0xEEF2F7;
      public static const COL_BORDER:uint = 0xDCE3EC;
      public static const COL_TEXT_PRIMARY:uint = 0x0F172A;
      public static const COL_TEXT_SECONDARY:uint = 0x475569;
      public static const COL_TEXT_MUTED:uint = 0x64748B;
      public static const COL_BRAND_BLUE:uint = 0x1D9BF0;
      public static const COL_BRAND_DARK:uint = 0x0949AB;
      public static const COL_OFFICIAL_GOLD:uint = 0xEBA81C;
      public static const COL_CREATOR_PURPLE:uint = 0x8B5CF6;
      public static const COL_LIKE_RED:uint = 0xE11D48;
      public static const COL_GREEN:uint = 0x10B981;
      public static const COL_WARN:uint = 0xD97706;
      public static const COL_DANGER:uint = 0xDC2626;

      public static var sLastSBVState:Object = null;
      public static var sBadgesMap:Object = new Object();

      private static var sJsonStr:String = "";
      private static var sJsonPos:int = 0;
      
      public function SocialMediaTunables()
      {
         super();
      }

      // === Pure AS3 JSON Parser (Scaleform GFx 4.x has no native JSON class) ===
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
            if(ch == " " || ch == "\t" || ch == "\n" || ch == "\r")
            {
               sJsonPos++;
            }
            else
            {
               break;
            }
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
         sJsonPos++; // skip '{'
         SkipWs();
         if(sJsonPos < sJsonStr.length && sJsonStr.charAt(sJsonPos) == "}")
         {
            sJsonPos++;
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
               sJsonPos++;
            }
            obj[key] = ReadJsonValue();
            SkipWs();
            var sep:String = sJsonPos < len ? sJsonStr.charAt(sJsonPos) : "}";
            if(sep == ",")
            {
               sJsonPos++;
            }
            else
            {
               if(sep == "}")
               {
                  sJsonPos++;
               }
               break;
            }
         }
         return obj;
      }

      private static function ReadJsonArray() : Array
      {
         var arr:Array = new Array();
         sJsonPos++; // skip '['
         SkipWs();
         if(sJsonPos < sJsonStr.length && sJsonStr.charAt(sJsonPos) == "]")
         {
            sJsonPos++;
            return arr;
         }
         var len:int = sJsonStr.length;
         while(sJsonPos < len)
         {
            arr.push(ReadJsonValue());
            SkipWs();
            var sep:String = sJsonPos < len ? sJsonStr.charAt(sJsonPos) : "]";
            if(sep == ",")
            {
               sJsonPos++;
            }
            else
            {
               if(sep == "]")
               {
                  sJsonPos++;
               }
               break;
            }
         }
         return arr;
      }

      private static function ReadJsonString() : String
      {
         sJsonPos++; // skip opening '"'
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
            if((ch >= "0" && ch <= "9") || ch == "-" || ch == "+" || ch == "." || ch == "e" || ch == "E")
            {
               sJsonPos++;
            }
            else
            {
               break;
            }
         }
         var numStr:String = sJsonStr.substring(start,sJsonPos);
         return Number(numStr);
      }

      public static function ExtractSBVState(rawItems:Array) : Object
      {
         var nativeList:Array = new Array();
         var chunks:Array = new Array();
         if(rawItems != null)
         {
            var i:int = 0;
            while(i < rawItems.length)
            {
               var item:SocialMediaFeedItem = rawItems[i] as SocialMediaFeedItem;
               if(item != null && item.post_type >= PACKET_TYPE_CORE_STATE)
               {
                  var idx:int = int(Number(item.post_id)) - 9000000;
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
         var parsed:Object = null;
         if(chunks.length > 0)
         {
            var joined:String = "";
            var c:int = 0;
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
               parsed = ParseJSON(joined) as Object;
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
            "sbvState":parsed != null ? parsed : sLastSBVState
         };
      }

      public static function EncodeArg(src:String) : String
      {
         if(src == null || src.length == 0)
         {
            return "%.";
         }
         var hex:String = "0123456789ABCDEF";
         var safe:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~";
         var out:String = "";
         var i:int = 0;
         var len:int = src.length;
         while(i < len)
         {
            var c:int = int(src.charCodeAt(i));
            var ch:String = src.charAt(i);
            if(c < 128 && safe.indexOf(ch) >= 0)
            {
               out += ch;
            }
            else if(c < 128)
            {
               out += "%" + hex.charAt((c >> 4) & 15) + hex.charAt(c & 15);
            }
            else if(c < 2048)
            {
               var b1:int = 192 | (c >> 6);
               var b2:int = 128 | (c & 63);
               out += "%" + hex.charAt((b1 >> 4) & 15) + hex.charAt(b1 & 15) + "%" + hex.charAt((b2 >> 4) & 15) + hex.charAt(b2 & 15);
            }
            else
            {
               var e1:int = 224 | (c >> 12);
               var e2:int = 128 | ((c >> 6) & 63);
               var e3:int = 128 | (c & 63);
               out += "%" + hex.charAt((e1 >> 4) & 15) + hex.charAt(e1 & 15) + "%" + hex.charAt((e2 >> 4) & 15) + hex.charAt(e2 & 15) + "%" + hex.charAt((e3 >> 4) & 15) + hex.charAt(e3 & 15);
            }
            i++;
         }
         return out;
      }

      public static function SendAction(simId:String, action:String, arg1:String = "", arg2:String = "", arg3:String = "") : void
      {
         CommunicationManager.PostServerCommand(
            "sbv.action",
            simId,
            action,
            EncodeArg(arg1 != null ? arg1 : ""),
            EncodeArg(arg2 != null ? arg2 : ""),
            EncodeArg(arg3 != null ? arg3 : "")
         );
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
         var container:MovieClip = new MovieClip();
         container.mouseChildren = false;
         container.mouseEnabled = false;
         container.name = "sbv_badge_" + String(int(size));
         container["mSize"] = size;
         container["mHasTip"] = withTooltip;
         return container;
      }

      public static function UpdateBadgeSprite(badge:Sprite, kind:String, tipText:String = "") : void
      {
         if(!badge)
         {
            return;
         }
         var size:Number = 16;
         if(badge.name && badge.name.indexOf("sbv_badge_") == 0)
         {
            size = Number(badge.name.substr(10));
         }
         else if(badge.hasOwnProperty("mSize"))
         {
            size = Number(badge["mSize"]);
         }
         if(!size || isNaN(size))
         {
            size = 16;
         }
         badge.graphics.clear();
         if(!kind || kind == "none" || kind == "")
         {
            badge.visible = false;
            return;
         }
         badge.visible = true;
         var color:uint = COL_BRAND_BLUE;
         if(kind == "official")
         {
            color = COL_OFFICIAL_GOLD;
         }
         else if(kind == "creator")
         {
            color = COL_CREATOR_PURPLE;
         }
         else if(kind == "legacy")
         {
            color = COL_TEXT_MUTED;
         }
         var r:Number = size * 0.5;
         badge.graphics.beginFill(color,1.0);
         badge.graphics.drawCircle(r,r,r - 1);
         badge.graphics.endFill();
         badge.graphics.lineStyle(Math.max(1.5,size * 0.13),0xFFFFFF,1.0);
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
      }

      public static function CreateLabel(
         txt:String,
         size:int = 12,
         color:uint = 0x0F172A,
         bold:Boolean = false,
         w:Number = 200,
         h:Number = 20,
         multiline:Boolean = false,
         align:String = "left"
      ) : TextField
      {
         var tf:TextField = new TextField();
         tf.width = w;
         tf.height = h;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.multiline = multiline;
         tf.wordWrap = multiline;
         tf.embedFonts = true;
         var fmt:TextFormat = new TextFormat(bold ? "$HeadlineFont" : "$TextFont",size,color,bold);
         fmt.align = align;
         tf.defaultTextFormat = fmt;
         tf.text = txt != null ? txt : "";
         tf.setTextFormat(fmt);
         return tf;
      }

      public static function CreateInputBox(
         initialText:String,
         w:Number,
         h:Number,
         multiline:Boolean = false,
         maxChars:int = 220
      ) : Sprite
      {
         var box:MovieClip = new MovieClip();
         box.mouseEnabled = true;
         box.graphics.lineStyle(1,COL_BORDER,1.0);
         box.graphics.beginFill(COL_SURFACE,1.0);
         box.graphics.drawRoundRect(0,0,w,h,8,8);
         box.graphics.endFill();

         var tf:TextField = new TextField();
         tf.name = "inputField";
         tf.type = TextFieldType.INPUT;
         tf.selectable = true;
         tf.mouseEnabled = true;
         tf.multiline = multiline;
         tf.wordWrap = multiline;
         tf.embedFonts = true;
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
         box.addEventListener(MouseEvent.CLICK,HandleInputBoxClick,false,0,true);
         return box;
      }

      private static function HandleInputBoxClick(e:MouseEvent) : void
      {
         var box:DisplayObjectContainer = e.currentTarget as DisplayObjectContainer;
         if(box && box.stage)
         {
            var tf:TextField = box.getChildByName("inputField") as TextField;
            if(!tf && box.hasOwnProperty("tf"))
            {
               tf = box["tf"] as TextField;
            }
            if(tf)
            {
               box.stage.focus = tf;
            }
         }
      }

      public static function CreateCard(w:Number, h:Number, fill:uint = 0xFFFFFF, border:uint = 0xDCE3EC, radius:Number = 10) : Sprite
      {
         var s:Sprite = new Sprite();
         if(border != 0)
         {
            s.graphics.lineStyle(1,border,1.0);
         }
         s.graphics.beginFill(fill,1.0);
         s.graphics.drawRoundRect(0,0,w,h,radius,radius);
         s.graphics.endFill();
         return s;
      }

      public static function CreateButton(
         label:String,
         w:Number,
         h:Number,
         bgColor:uint,
         textColor:uint,
         onClick:Function,
         fontSize:int = 11,
         borderColor:uint = 0,
         cmdData:Object = null
      ) : Sprite
      {
         var btn:MovieClip = new MovieClip();
         btn.buttonMode = true;
         btn.useHandCursor = true;
         btn.mouseChildren = false;
         btn["bgColor"] = bgColor;
         btn["borderColor"] = borderColor;
         btn["btnW"] = w;
         btn["btnH"] = h;
         if(cmdData != null)
         {
            btn["sbv"] = cmdData;
         }

         DrawButtonFace(btn,bgColor,borderColor,w,h,1.0);
         var lbl:TextField = CreateLabel(label,fontSize,textColor,true,w - 8,h - 2,false,TextFormatAlign.CENTER);
         lbl.name = "lbl";
         lbl.x = 4;
         lbl.y = Math.max(1,(h - (fontSize + 7)) * 0.5);
         btn.addChild(lbl);

         btn.addEventListener(MouseEvent.ROLL_OVER,HandleBtnRollOver,false,0,true);
         btn.addEventListener(MouseEvent.ROLL_OUT,HandleBtnRollOut,false,0,true);
         btn.addEventListener(MouseEvent.MOUSE_DOWN,HandleBtnMouseDown,false,0,true);
         btn.addEventListener(MouseEvent.MOUSE_UP,HandleBtnMouseUp,false,0,true);
         if(onClick != null)
         {
            btn.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         }
         return btn;
      }

      private static function HandleBtnRollOver(e:MouseEvent) : void
      {
         var btn:Sprite = e.currentTarget as Sprite;
         if(btn)
         {
            DrawButtonFace(btn,uint(btn["bgColor"]),uint(btn["borderColor"]),Number(btn["btnW"]),Number(btn["btnH"]),0.85);
         }
      }

      private static function HandleBtnRollOut(e:MouseEvent) : void
      {
         var btn:Sprite = e.currentTarget as Sprite;
         if(btn)
         {
            DrawButtonFace(btn,uint(btn["bgColor"]),uint(btn["borderColor"]),Number(btn["btnW"]),Number(btn["btnH"]),1.0);
         }
      }

      private static function HandleBtnMouseDown(e:MouseEvent) : void
      {
         var btn:Sprite = e.currentTarget as Sprite;
         if(btn)
         {
            DrawButtonFace(btn,uint(btn["bgColor"]),uint(btn["borderColor"]),Number(btn["btnW"]),Number(btn["btnH"]),0.7);
         }
      }

      private static function HandleBtnMouseUp(e:MouseEvent) : void
      {
         var btn:Sprite = e.currentTarget as Sprite;
         if(btn)
         {
            DrawButtonFace(btn,uint(btn["bgColor"]),uint(btn["borderColor"]),Number(btn["btnW"]),Number(btn["btnH"]),0.9);
         }
      }

      private static function DrawButtonFace(btn:Sprite, bg:uint, border:uint, w:Number, h:Number, alphaVal:Number) : void
      {
         var g:Graphics = btn.graphics;
         g.clear();
         if(border != 0)
         {
            g.lineStyle(1,border,1.0);
         }
         g.beginFill(bg,alphaVal);
         g.drawRoundRect(0,0,w,h,8,8);
         g.endFill();
      }

      public static function DrawBarChart(
         container:Sprite,
         title:String,
         labels:Array,
         values:Array,
         w:Number,
         h:Number,
         barColor:uint
      ) : void
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

         card.graphics.lineStyle(1,COL_BORDER,1.0);
         card.graphics.moveTo(plotX,plotY + plotH);
         card.graphics.lineTo(plotX + plotW,plotY + plotH);

         var count:int = values.length;
         var step:Number = plotW / count;
         var barW:Number = Math.max(8,Math.min(26,step * 0.58));

         i = 0;
         while(i < count)
         {
            var val:Number = Number(values[i]);
            var barH:Number = Math.max(3,(val / maxVal) * (plotH - 12));
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
