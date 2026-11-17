package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class RankedStatisticDisplayInfo extends OlympusObject
   {
      
      protected static var sRankedStatDisplayInfoStaticData:Object = new Object();
      
      public var id:String;
      
      public var title:LocKey = new LocKey();
      
      public var subtitle:LocKey = new LocKey();
      
      public var disabled_confirm_tooltip:LocKey = new LocKey();
      
      public var revert_tooltip:LocKey = new LocKey();
      
      public var bucks_perk_info:Array = [RankedStatisticBucksPerkInfo];
      
      public var sim_info_panel_icons:RankedStatisticPanelIconData = new RankedStatisticPanelIconData();
      
      public var sim_info_panel_icons_negative:RankedStatisticPanelIconData = new RankedStatisticPanelIconData();
      
      public function RankedStatisticDisplayInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : RankedStatisticDisplayInfo
      {
         var _loc2_:Object = null;
         if(!sRankedStatDisplayInfoStaticData[param1])
         {
            _loc2_ = CommunicationManager.CallGameService("GetRankedStatisticDisplayInfoData",param1,true);
            if(_loc2_ == null)
            {
               return null;
            }
            sRankedStatDisplayInfoStaticData[param1] = new RankedStatisticDisplayInfo(_loc2_);
         }
         return sRankedStatDisplayInfoStaticData[param1];
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.title.IsValid())
         {
            this.title = null;
         }
         if(!this.subtitle.IsValid())
         {
            this.subtitle = null;
         }
         if(!this.disabled_confirm_tooltip.IsValid())
         {
            this.disabled_confirm_tooltip = null;
         }
         if(!this.revert_tooltip.IsValid())
         {
            this.revert_tooltip = null;
         }
         if(!param1.hasOwnProperty("sim_info_panel_icons"))
         {
            this.sim_info_panel_icons = null;
         }
         if(!param1.hasOwnProperty("sim_info_panel_icons_negative"))
         {
            this.sim_info_panel_icons_negative = null;
         }
         FixupArray(this.bucks_perk_info);
      }
      
      public function GetBucksPerkInfoByBucksType(param1:uint) : RankedStatisticBucksPerkInfo
      {
         var _loc2_:RankedStatisticBucksPerkInfo = null;
         for each(_loc2_ in this.bucks_perk_info)
         {
            if(_loc2_.type == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

