package widgets.Gameplay.SocialMedia
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import gamedata.Gameplay.SocialMedia.SocialMediaFeedItem;
   import olympus.io.CommunicationManager;

   /**
    * Small, self-contained helpers for the additive Verified tab.
    *
    * This class deliberately does not replace SocialMediaTunables or any native
    * Social Bunny component. It only provides JSON parsing for the verified
    * state packet, native-font labels, and a vector Meta-style badge.
    */
   public final class SocialMediaVerifiedUI
   {
      public static const PACKET_TYPE_VERIFIED_STATE:int = 100;
      public static const STATE_PACKET_ID_BASE:int = 9000000;

      public static const COL_HERO:uint = 0x5A2B6B;
      public static const COL_HERO_DARK:uint = 0x3D1B4D;
      public static const COL_ACCENT:uint = 0x1D9BF0;
      public static const COL_ACCENT_DARK:uint = 0x0B6FB8;
      public static const COL_CARD:uint = 0xFFFFFF;
      public static const COL_TEXT:uint = 0x241A2B;
      public static const COL_MUTED:uint = 0x6F5B79;
      public static const COL_BORDER:uint = 0xDCCFE3;
      public static const COL_SUCCESS:uint = 0x2E7D32;
      public static const COL_WARN:uint = 0xB26A00;
      public static const COL_DANGER:uint = 0xB3261E;
      public static const COL_PINK:uint = 0xF6DCE8;
      public static const COL_PINK_DARK:uint = 0xE9BFD2;

      private static var sJsonStr:String = "";
      private static var sJsonPos:int = 0;

      public function SocialMediaVerifiedUI()
      {
         super();
      }

      /**
       * Split the native feed from the verified state packet(s) and parse the
       * state JSON. Native feed items are returned untouched.
       */
      public static function ExtractState(rawItems:Array) : Object
      {
         var nativeList:Array = new Array();
         var chunks:Array = new Array();
         if(rawItems != null)
         {
            var i:int = 0;
            while(i < rawItems.length)
            {
               var item:SocialMediaFeedItem = rawItems[i] as SocialMediaFeedItem;
               if(item != null && item.post_type >= PACKET_TYPE_VERIFIED_STATE)
               {
                  var idx:int = int(Number(item.post_id)) - STATE_PACKET_ID_BASE;
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
               try
               {
                  parsed = ParseJSON(joined) as Object;
               }
               catch(e:Error)
               {
                  parsed = null;
               }
            }
         }

         return {
            "nativeItems":nativeList,
            "state":parsed
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

      /**
       * The only verified-tab inbound command. Uses the native EA
       * CommunicationManager.PostServerCommand channel.
       */
      public static function SendAction(simId:String, action:String, arg1:String = "", arg2:String = "") : void
      {
         CommunicationManager.PostServerCommand(
            "sbv.verified",
            simId,
            action,
            EncodeArg(arg1 != null ? arg1 : ""),
            EncodeArg(arg2 != null ? arg2 : "")
         );
      }

      public static function CreateLabel(
         txt:String,
         size:int,
         color:uint,
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

      public static function CreateBadge(size:Number) : Sprite
      {
         var badge:Sprite = new Sprite();
         badge.mouseEnabled = false;
         badge.mouseChildren = false;
         DrawBadge(badge,size);
         return badge;
      }

      /**
       * Draws the blue verified starburst + white check without relying on
       * any external texture atlas or DDS override.
       */
      public static function DrawBadge(badge:Sprite, size:Number) : void
      {
         if(badge == null)
         {
            return;
         }
         var g:Graphics = badge.graphics;
         g.clear();
         if(size <= 0)
         {
            return;
         }
         var cx:Number = size * 0.5;
         var cy:Number = size * 0.5;
         var outer:Number = size * 0.48;
         var inner:Number = size * 0.39;
         var points:int = 12;
         g.lineStyle(0,0,0);
         g.beginFill(COL_ACCENT,1.0);
         var i:int = 0;
         while(i < points * 2)
         {
            var angle:Number = (Math.PI * 2 * i) / (points * 2) - Math.PI * 0.5;
            var radius:Number = (i % 2 == 0) ? outer : inner;
            var px:Number = cx + Math.cos(angle) * radius;
            var py:Number = cy + Math.sin(angle) * radius;
            if(i == 0)
            {
               g.moveTo(px,py);
            }
            else
            {
               g.lineTo(px,py);
            }
            i++;
         }
         g.lineTo(cx,cy - outer);
         g.endFill();

         g.lineStyle(Math.max(1.5,size * 0.13),0xFFFFFF,1.0);
         g.moveTo(size * 0.26,size * 0.52);
         g.lineTo(size * 0.43,size * 0.68);
         g.lineTo(size * 0.75,size * 0.34);
      }

      public static function CreateCard(
         w:Number,
         h:Number,
         fill:uint = COL_CARD,
         border:uint = COL_BORDER,
         radius:Number = 10
      ) : Sprite
      {
         var card:Sprite = new Sprite();
         card.graphics.clear();
         if(border != 0)
         {
            card.graphics.lineStyle(1,border,1.0);
         }
         card.graphics.beginFill(fill,1.0);
         card.graphics.drawRoundRect(0,0,w,h,radius,radius);
         card.graphics.endFill();
         return card;
      }

      public static function FormatMoney(amount:Number) : String
      {
         return "\u00A7" + String(int(Math.round(amount)));
      }

      public static function StatusColor(status:String) : uint
      {
         if(status == "active" || status == "eligible")
         {
            return COL_SUCCESS;
         }
         if(status == "payment_failed" || status == "suspended")
         {
            return COL_DANGER;
         }
         if(status == "payment_pending" || status == "grace_period" || status == "cancelled")
         {
            return COL_WARN;
         }
         return COL_MUTED;
      }

      public static function Shorten(src:String, maxChars:int) : String
      {
         if(src == null)
         {
            return "";
         }
         if(src.length <= maxChars)
         {
            return src;
         }
         return src.substr(0,Math.max(0,maxChars - 1)) + "\u2026";
      }

      // ---------------------------------------------------------------
      // Minimal JSON parser for Scaleform GFx 4.x (no native JSON API).
      // ---------------------------------------------------------------
      private static function ParseJSON(src:String) : *
      {
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
         sJsonPos++;
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
         sJsonPos++;
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
         sJsonPos++;
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
   }
}
