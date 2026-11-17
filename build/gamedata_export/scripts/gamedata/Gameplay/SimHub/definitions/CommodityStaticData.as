package gamedata.Gameplay.SimHub.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.Gameplay.SimInfoHUD.CommodityState;
   import gamedata.Gameplay.SimInfoHUD.TraitBasedUIOverrideMapping;
   import gamedata.shared.OlympusPoint;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import olympus.math.PiecewiseLinearCurve;
   
   public class CommodityStaticData extends OlympusObject
   {
      
      protected static var sCommodityList:Vector.<CommodityStaticData>;
      
      public static var MOTIVE_UI_STYLE_DEFAULT:int = 0;
      
      public static var MOTIVE_UI_STYLE_LONG:int = 1;
      
      public static var MOTIVE_UI_STYLE_ORB:int = 2;
      
      public static var OPERATOR_GREATER:int = 1;
      
      public static var OPERATOR_GREATER_OR_EQUAL:int = 2;
      
      public static var OPERATOR_EQUAL:int = 3;
      
      public static var OPERATOR_NOTEQUAL:int = 4;
      
      public static var OPERATOR_LESS_OR_EQUAL:int = 5;
      
      public static var OPERATOR_LESS:int = 6;
      
      public var commodity_id:String;
      
      public var commodity_name:LocKey = new LocKey();
      
      public var commodity_states:Array = [CommodityState];
      
      public var commodity_trait_based_ui_overrides:Array = [TraitBasedUIOverrideMapping];
      
      public var threshold_index:uint;
      
      public var ad_data:Array = [OlympusPoint];
      
      public var max_value_tuning:Number = 0;
      
      public var min_value_tuning:Number = 0;
      
      public var ui_render_style:int;
      
      public var ui_sort_order:int;
      
      public var ui_distress_threshold_value:Number = 0;
      
      public var ui_distress_threshold_operator:int = OPERATOR_LESS;
      
      public var negative_single_arrow_threshold:Number = 0;
      
      public var negative_double_arrow_threshold:Number = 0;
      
      public var negative_triple_arrow_threshold:Number = 0;
      
      public var positive_single_arrow_threshold:Number = 0;
      
      public var positive_double_arrow_threshold:Number = 0;
      
      public var positive_triple_arrow_threshold:Number = 0;
      
      protected var mCurve:PiecewiseLinearCurve;
      
      public function CommodityStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get COMMODITY_LIST() : Vector.<CommodityStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<CommodityStaticData> = null;
         var _loc4_:int = 0;
         if(!sCommodityList)
         {
            _loc1_ = CommunicationManager.CallGameService("GetCommodityList",null,true) as Array;
            _loc2_ = _loc1_ ? int(_loc1_.length) : 0;
            if(_loc2_ > 0)
            {
               _loc3_ = new Vector.<CommodityStaticData>(_loc2_,true);
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc3_[_loc4_] = new CommodityStaticData(_loc1_[_loc4_]);
                  _loc4_++;
               }
               _loc3_.sort(SortCommodityStaticData);
               sCommodityList = _loc3_;
            }
         }
         return sCommodityList;
      }
      
      public static function GetCommodityById(param1:String) : CommodityStaticData
      {
         var _loc3_:CommodityStaticData = null;
         var _loc2_:Vector.<CommodityStaticData> = COMMODITY_LIST;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.commodity_id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function SortCommodityStaticData(param1:CommodityStaticData, param2:CommodityStaticData) : Number
      {
         if(param1.ui_sort_order == param2.ui_sort_order)
         {
            return 0;
         }
         return param1.ui_sort_order < param2.ui_sort_order ? -1 : 1;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.commodity_states);
         FixupArray(this.commodity_trait_based_ui_overrides);
         FixupArray(this.ad_data);
         if(this.commodity_trait_based_ui_overrides)
         {
            TraitBasedUIOverrideMapping.GroupOverridesByDescendingPriority(this.commodity_trait_based_ui_overrides);
         }
         this.mCurve = new PiecewiseLinearCurve(this.ad_data);
      }
      
      public function get Curve() : PiecewiseLinearCurve
      {
         return this.mCurve;
      }
      
      public function GetCommodityName(param1:Array) : LocKey
      {
         var _loc2_:TraitBasedUIOverrideMapping = null;
         if(this.commodity_trait_based_ui_overrides != null)
         {
            for each(_loc2_ in this.commodity_trait_based_ui_overrides)
            {
               if(_loc2_.stat_name != null && param1.indexOf(_loc2_.trait_id) >= 0)
               {
                  return _loc2_.stat_name;
               }
            }
         }
         return this.commodity_name;
      }
   }
}

