package olympus.objects
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ObjectMetadata extends OlympusObject
   {
      
      public static const QUALITY_PLANT_WILD:uint = 0;
      
      public static const PLANT_EVOLUTION_DEATH:uint = 1;
      
      public static const HOVER_TIP_DISABLED:int = 0;
      
      public static const HOVER_TIP_DEFAULT:int = 1;
      
      public static const HOVER_TIP_CONSUMABLE:int = 2;
      
      public static const HOVER_TIP_GARDENING:int = 3;
      
      public static const HOVER_TIP_COLLECTION:int = 4;
      
      public static const HOVER_TIP_CUSTOM_OBJECT:int = 5;
      
      public static const HOVER_TIP_ICON_TITLE_DESCRIPTION:int = 6;
      
      public static const HOVER_TIP_OBJECT_RELATIONSHIP:int = 7;
      
      public static const HOVER_TIP_HEIRLOOM_OBJECT:int = 8;
      
      public var hover_tip:int;
      
      public var debug_hover_tip:int;
      
      public var custom_name:String;
      
      public var recipe_name:LocKey = new LocKey();
      
      public var custom_description:String;
      
      public var recipe_description:LocKey = new LocKey();
      
      public var crafter_sim_id:String;
      
      public var quality:int;
      
      public var servings:int;
      
      public var buff_effects:Array = [LocKey];
      
      public var spoiled_time:String;
      
      public var creature_type:int;
      
      public var spoiled_time_text:LocKey = new LocKey();
      
      public var percentage_left:LocKey = new LocKey();
      
      public var style_name:LocKey = new LocKey();
      
      public var simoleon_value:int;
      
      public var main_icon:ResourceKey = new ResourceKey();
      
      public var sub_icons:Array = [ResourceKey];
      
      public var quality_description:LocKey = new LocKey();
      
      public var inscription:String;
      
      public var header:LocKey = new LocKey();
      
      public var header_subtext:LocKey = new LocKey();
      
      public var header_status:LocKey = new LocKey();
      
      public var subtext:LocKey = new LocKey();
      
      public var crafted_by_text:LocKey = new LocKey();
      
      public var stolen_from_text:LocKey = new LocKey();
      
      public var footer_text:LocKey = new LocKey();
      
      public var heirloom_sim_id:String;
      
      public var heirloom_title:LocKey = new LocKey();
      
      public var heirloom_owner:LocKey = new LocKey();
      
      public var engraved_message:LocKey = new LocKey();
      
      public var controllerHints:String;
      
      public var rarity_text:LocKey = new LocKey();
      
      public var simoleon_text:LocKey = new LocKey();
      
      public var relic_description:LocKey = new LocKey();
      
      public var evolution_progress:Number;
      
      public var season_text:LocKey = new LocKey();
      
      public var active_seasons_text:LocKey = new LocKey();
      
      public var rel_override_id:String;
      
      public var icon_infos:Array = [IconInfo];
      
      public var simoleon_custom_text:LocKey = new LocKey();
      
      public var object_timers:Array = [ObjectTimer];
      
      public var mark_up_value_tooltip:int;
      
      public var enchantment_time:String;
      
      public function ObjectMetadata(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.buff_effects);
         FixupArray(this.sub_icons);
         FixupArray(this.icon_infos);
         FixupArray(this.object_timers);
         if(!param1 || !("main_icon" in param1))
         {
            this.main_icon = null;
         }
         if(!this.percentage_left.IsValid())
         {
            this.percentage_left = null;
         }
         if(!this.recipe_description.IsValid())
         {
            this.recipe_description = null;
         }
         if(!this.recipe_name.IsValid())
         {
            this.recipe_name = null;
         }
         if(!this.style_name.IsValid())
         {
            this.style_name = null;
         }
         if(!this.quality_description.IsValid())
         {
            this.quality_description = null;
         }
         if(!this.header.IsValid())
         {
            this.header = null;
         }
         if(!this.subtext.IsValid())
         {
            this.subtext = null;
         }
         if(!this.crafted_by_text.IsValid())
         {
            this.crafted_by_text = null;
         }
         if(!this.rarity_text.IsValid())
         {
            this.rarity_text = null;
         }
         if(!this.simoleon_text.IsValid())
         {
            this.simoleon_text = null;
         }
         if(!this.relic_description.IsValid())
         {
            this.relic_description = null;
         }
         if(!this.season_text.IsValid())
         {
            this.season_text = null;
         }
         if(!this.active_seasons_text.IsValid())
         {
            this.active_seasons_text = null;
         }
         if(!this.spoiled_time_text.IsValid())
         {
            this.spoiled_time_text = null;
         }
         var _loc2_:int = int(this.sub_icons.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((this.sub_icons[_loc3_] as ResourceKey).instance == "0")
            {
               this.sub_icons[_loc3_] = null;
            }
            _loc3_++;
         }
         if(!this.simoleon_custom_text.IsValid())
         {
            this.simoleon_custom_text = null;
         }
         if(!this.header_subtext.IsValid())
         {
            this.header_subtext = null;
         }
         if(!this.header_status.IsValid())
         {
            this.header_status = null;
         }
         this.heirloom_title = FixupLocKey(this.heirloom_title);
         this.heirloom_owner = FixupLocKey(this.heirloom_owner);
         this.engraved_message = FixupLocKey(this.engraved_message);
      }
      
      public function IsValidForHoverTip() : Boolean
      {
         return Boolean(this.custom_name || this.recipe_name);
      }
      
      public function toString() : String
      {
         return "hover_tip:" + this.hover_tip + " debug_hover_tip:" + this.debug_hover_tip + " custom_name:" + this.custom_name + " recipe_name:" + this.recipe_name + " crafter_sim_id:" + this.crafter_sim_id + " quality:" + this.quality + " servings:" + this.servings + " buff_effects:" + this.buff_effects + " spoiled_time:" + this.spoiled_time + " percentage_left:" + this.percentage_left + " style_name:" + this.style_name + " simoleon_value:" + this.simoleon_value + " simoleon_text:" + this.simoleon_text + " simoleon_custom_text:" + this.simoleon_custom_text + " main_icon:" + this.main_icon + " sub_icons:" + this.sub_icons + " custom_description:" + this.custom_description + " recipe_description:" + this.recipe_description + " rarity_text:" + this.rarity_text + " quality_description:" + this.quality_description + " header_subtext:" + this.header_subtext + " header_status:" + this.header_status + " mark_up_value_tooltip:" + this.mark_up_value_tooltip + " enchantment_time:" + this.enchantment_time + " active_seasons_text:" + this
         .active_seasons_text;
      }
   }
}

