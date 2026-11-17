package widgets.shared.data.Engagements
{
   import olympus.core.OlympusObject;
   import olympus.core.widget.Margin;
   
   public class EngagementContentConfigData extends OlympusObject
   {
      
      public static const CONFIG_ID_INVALID:int = -1;
      
      public var configId:int = -1;
      
      public var showAffordanceTag:Boolean = false;
      
      public var showAffordanceBadge:Boolean = false;
      
      public var showBundleTags:Boolean = false;
      
      public var showBundleTypeTag:Boolean = false;
      
      public var showPackTypeText:Boolean = false;
      
      public var messagePaneType:String;
      
      public var messagePaneOrientation:String;
      
      public var messagePaneSize:String;
      
      public var messagePaneLayout:String;
      
      public var messagePanePadding:Number;
      
      public var layoutInnerMargin:Margin;
      
      public var layoutGridMaxColumns:int = 1;
      
      public var layoutGridAlignment:String = "center";
      
      public var bUsesMessagePanes:Boolean = false;
      
      public function EngagementContentConfigData(param1:Object = null)
      {
         super(param1);
      }
   }
}

