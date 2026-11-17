package gamedata.Gameplay.SimInfoHUD
{
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CommodityState extends OlympusObject
   {
      
      public static const FAILURE:String = "failure";
      
      public static const DISTRESS:String = "distress";
      
      public static const FINE:String = "fine";
      
      public static var ENUM_TO_LABEL:Array = [null,FAILURE,DISTRESS,FINE];
      
      public static const FILL_LEVEL_NO_FILL:int = 0;
      
      public static const FILL_LEVEL_FAILURE:int = 1;
      
      public static const FILL_LEVEL_DISTRESS:int = 2;
      
      public static const FILL_LEVEL_FINE:int = 3;
      
      public var desc:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var value:int;
      
      public var fill_level:int;
      
      public var background_color:uint;
      
      public var fill_color:uint;
      
      public var tooltip_icons:Array = [ResourceKey];
      
      public var ui_container_animation_decreasing:String;
      
      public var ui_container_animation_increasing:String;
      
      public var trait_based_ui_overrides:Array = [TraitBasedUIOverrideMapping];
      
      public function CommodityState(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.tooltip_icons);
         FixupArray(this.trait_based_ui_overrides);
         if(this.trait_based_ui_overrides)
         {
            TraitBasedUIOverrideMapping.GroupOverridesByDescendingPriority(this.trait_based_ui_overrides);
         }
      }
      
      public function get FillLabel() : String
      {
         return ENUM_TO_LABEL[this.fill_level];
      }
      
      public function GetDescription(param1:Array) : LocKey
      {
         var _loc2_:TraitBasedUIOverrideMapping = null;
         if(this.trait_based_ui_overrides != null)
         {
            for each(_loc2_ in this.trait_based_ui_overrides)
            {
               if(_loc2_.data_description != null && param1.indexOf(_loc2_.trait_id) >= 0)
               {
                  return _loc2_.data_description;
               }
            }
         }
         return this.desc;
      }
      
      public function GetFillColor() : Number
      {
         var _loc2_:TraitBasedUIOverrideMapping = null;
         var _loc3_:Array = null;
         var _loc1_:Boolean = false;
         if(this.trait_based_ui_overrides != null)
         {
            for each(_loc2_ in this.trait_based_ui_overrides)
            {
               if(!isNaN(_loc2_.fill_color))
               {
                  _loc1_ = true;
               }
            }
         }
         if(_loc1_)
         {
            _loc3_ = GameplayStateData.AllTraitIds;
            for each(_loc2_ in this.trait_based_ui_overrides)
            {
               if(!isNaN(_loc2_.fill_color) && _loc3_.indexOf(_loc2_.trait_id) >= 0)
               {
                  return _loc2_.fill_color;
               }
            }
         }
         return this.fill_color;
      }
      
      public function GetIcon(param1:Array) : ResourceKey
      {
         var _loc2_:TraitBasedUIOverrideMapping = null;
         if(this.trait_based_ui_overrides != null)
         {
            for each(_loc2_ in this.trait_based_ui_overrides)
            {
               if(_loc2_.icon != null && _loc2_.icon.instance != "0" && _loc2_.icon.type != 0 && param1.indexOf(_loc2_.trait_id) >= 0)
               {
                  return _loc2_.icon;
               }
            }
         }
         return this.icon;
      }
      
      public function GetTooltipIcons(param1:Array) : Array
      {
         var _loc2_:TraitBasedUIOverrideMapping = null;
         if(this.trait_based_ui_overrides != null)
         {
            for each(_loc2_ in this.trait_based_ui_overrides)
            {
               if(_loc2_.tooltip_icon_list != null && param1.indexOf(_loc2_.trait_id) >= 0)
               {
                  return _loc2_.tooltip_icon_list;
               }
            }
         }
         return this.tooltip_icons;
      }
   }
}

