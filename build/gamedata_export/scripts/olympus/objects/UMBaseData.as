package olympus.objects
{
   import olympus.browser.constants.SpotlightPlacementTunables;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class UMBaseData extends OlympusObject
   {
      
      public static const DATA_SOURCE_UM:int = 0;
      
      public static const DATA_SOURCE_AMP:int = 1;
      
      public static var IS_INVISIBLE_TRUE:String = "true";
      
      public static var IS_INVISIBLE_FALSE:String = "false";
      
      public var type:String;
      
      public var source:int = 0;
      
      public var objectId:String;
      
      public var variantId:String;
      
      public var destinationId:String;
      
      public var messageId:String;
      
      public var trackingTag:String;
      
      public var invisible:String;
      
      public function UMBaseData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function TranslateObjectKeyFieldToStringField(param1:Object, param2:String) : void
      {
         var _loc4_:LocKey = null;
         var _loc3_:String = param2 + "Key";
         if(param1[_loc3_])
         {
            _loc4_ = new LocKey({"hash":param1[_loc3_]});
            if((Boolean(_loc4_)) && _loc4_.IsValid())
            {
               param1[param2] = _loc4_.toString();
            }
         }
      }
      
      public function get IsInvisible() : Boolean
      {
         return this.invisible != null && this.invisible == IS_INVISIBLE_TRUE;
      }
      
      public function SendUMEvent(param1:int) : void
      {
         if(this.source == DATA_SOURCE_UM)
         {
            CommunicationManager.CallGameService("ReplyUnifiedMessageEvent",{
               "destination":this.destinationId,
               "messageId":this.messageId,
               "event":param1
            });
         }
      }
      
      public function SendUMViewEvent() : void
      {
         this.SendUMEvent(SpotlightPlacementTunables.SPOTLIGHT_REPORT_TYPE_VIEW);
      }
      
      public function SendUMClickEvent() : void
      {
         this.SendUMEvent(SpotlightPlacementTunables.SPOTLIGHT_REPORT_TYPE_CLICK);
      }
      
      public function SendUMConversionEvent() : void
      {
         this.SendUMEvent(SpotlightPlacementTunables.SPOTLIGHT_REPORT_TYPE_CONVERSION);
      }
      
      public function TranslateKeyFieldToStringField(param1:String) : void
      {
         TranslateObjectKeyFieldToStringField(this,param1);
      }
   }
}

