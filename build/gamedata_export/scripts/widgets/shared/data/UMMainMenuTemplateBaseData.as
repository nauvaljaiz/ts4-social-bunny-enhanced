package widgets.shared.data
{
   import olympus.objects.UMBaseData;
   import widgets.shared.data.Engagements.EngagementContentConfigData;
   import widgets.shared.data.Engagements.EngagementContentConfigs;
   
   public class UMMainMenuTemplateBaseData extends UMBaseData
   {
      
      public var layout:String;
      
      public var layout_size:String;
      
      public var layout_orientation:String;
      
      public var theme:String;
      
      public var contentConfigId:int = -1;
      
      public var layout_position:String;
      
      protected var mContentConfig:EngagementContentConfigData = null;
      
      public function UMMainMenuTemplateBaseData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("layout_size" in param1) || !param1["layout_size"])
         {
            this.layout_size = "L";
         }
         if(!("layout" in param1) || !param1["layout"])
         {
            this.layout = "1";
         }
         if(!("layout_orientation" in param1) || !param1["layout_orientation"])
         {
            this.layout_orientation = "H";
         }
         if(!("layout_position" in param1) || !param1["layout_position"])
         {
            this.layout_position = "1";
         }
         if(this.contentConfigId != EngagementContentConfigData.CONFIG_ID_INVALID)
         {
            this.mContentConfig = EngagementContentConfigs.GetEngagementContentConfigDataById(this.contentConfigId);
         }
      }
      
      public function get ContentConfig() : EngagementContentConfigData
      {
         return this.mContentConfig;
      }
   }
}

