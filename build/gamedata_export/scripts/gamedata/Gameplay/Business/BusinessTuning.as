package gamedata.Gameplay.Business
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class BusinessTuning extends OlympusObject
   {
      
      protected static var sBusinessesTuningMap:Object;
      
      protected static var sBusinessesTuningList:Array;
      
      public var advertising_name_map:Array = [AdvertisingTuning];
      
      public var advertising_type_sort_order:Array = [int];
      
      public var alert_enabled:Boolean;
      
      public var associated_guidance:int = -1;
      
      public var buck_type:int;
      
      public var business_summary_tooltip:LocKey = new LocKey();
      
      public var buy_business_dropdown_data:BuyBusinessDropdownData = new BuyBusinessDropdownData();
      
      public var tab_button_icon_key:ResourceKey = new ResourceKey();
      
      public var markup_multiplier_data:Array = [MarkupMultiplierTuning];
      
      public var opening_fee:int = 0;
      
      public var quality_settings:Array = [SupplyQualityTuning];
      
      public var registration_fee:int = 0;
      
      public var settings_tooltip:LocKey = new LocKey();
      
      public var show_employee_button:Boolean;
      
      public var show_sell_button:Boolean;
      
      public var no_business_text:LocKey = new LocKey();
      
      public var purchase_business_button_text:LocKey = new LocKey();
      
      public var filter_button_tooltip:LocKey = new LocKey();
      
      public var tutorial_button_element:String;
      
      public var tutorial_panel_element:String;
      
      public var business_type:int;
      
      public function BusinessTuning(param1:Object = null)
      {
         super(param1);
         FixupArray(this.advertising_name_map);
         FixupArray(this.advertising_type_sort_order);
         FixupArray(this.markup_multiplier_data);
         FixupArray(this.quality_settings);
         this.business_summary_tooltip = FixupLocKey(this.business_summary_tooltip);
         this.settings_tooltip = FixupLocKey(this.settings_tooltip);
         this.no_business_text = FixupLocKey(this.no_business_text);
         this.purchase_business_button_text = FixupLocKey(this.purchase_business_button_text);
         this.filter_button_tooltip = FixupLocKey(this.filter_button_tooltip);
      }
      
      public static function get BusinessesTuningList() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         if(!sBusinessesTuningList)
         {
            sBusinessesTuningList = new Array();
            _loc1_ = CommunicationManager.CallGameService("GetBusinessesTuningData") as Array;
            for each(_loc2_ in _loc1_)
            {
               sBusinessesTuningList.push(new BusinessTuning(_loc2_));
            }
            sBusinessesTuningList.sortOn("business_type",Array.NUMERIC | Array.DESCENDING);
         }
         return sBusinessesTuningList;
      }
      
      public static function GetTuning(param1:int) : BusinessTuning
      {
         var _loc2_:BusinessTuning = null;
         if(!sBusinessesTuningMap)
         {
            sBusinessesTuningMap = new Object();
            for each(_loc2_ in BusinessesTuningList)
            {
               sBusinessesTuningMap[_loc2_.business_type] = _loc2_;
            }
         }
         if(param1 in sBusinessesTuningMap)
         {
            return sBusinessesTuningMap[param1];
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("buy_business_dropdown_data" in param1))
         {
            this.buy_business_dropdown_data = null;
         }
      }
      
      public function CanRegisterDuringSituation() : Boolean
      {
         switch(this.business_type)
         {
            case BusinessData.SMALL_BUSINESS_TYPE:
               return true;
            default:
               return false;
         }
      }
      
      public function GetSortedAdvertisingMap() : Array
      {
         var _loc1_:Array = this.advertising_name_map;
         return _loc1_.sort(this.SortAdvertisingData);
      }
      
      protected function SortAdvertisingData(param1:AdvertisingTuning, param2:AdvertisingTuning) : Number
      {
         var _loc5_:int = 0;
         if(!this.advertising_type_sort_order)
         {
            return param1.advertising_enum - param2.advertising_enum;
         }
         var _loc3_:int = -1;
         var _loc4_:int = -1;
         for each(_loc5_ in this.advertising_type_sort_order)
         {
            if(_loc5_ == param1.advertising_enum)
            {
               _loc3_ = _loc5_;
            }
            else if(_loc5_ == param2.advertising_enum)
            {
               _loc4_ = _loc5_;
            }
         }
         if(_loc3_ < 0 || _loc4_ < 0)
         {
            return param1.advertising_enum - param2.advertising_enum;
         }
         return _loc3_ - _loc4_;
      }
   }
}

