package gamedata.Gameplay.SituationCreation
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SituationStyleData extends OlympusObject
   {
      
      public var guest_attire_colors:Array = [Object];
      
      public var guest_attire_styles:Array = [Object];
      
      public var guest_attire_visible_on_role_page:Boolean = false;
      
      public var special_object_help_tooltip:LocKey = new LocKey();
      
      public var no_special_object_icon:ResourceKey;
      
      public var no_special_object_label:LocKey = new LocKey();
      
      public var cas_edit_job_id:String;
      
      public var cas_edit_outfit_category:int;
      
      public var cas_edit_no_sim_icon:ResourceKey;
      
      public var outfit_selector_visible_on_role_page:Boolean = false;
      
      public var appearance_modifier_text:LocKey = new LocKey();
      
      public function SituationStyleData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.guest_attire_colors);
         FixupArray(this.guest_attire_styles);
         this.special_object_help_tooltip = FixupLocKey(this.special_object_help_tooltip);
         this.no_special_object_label = FixupLocKey(this.no_special_object_label);
         this.appearance_modifier_text = FixupLocKey(this.appearance_modifier_text);
         if("no_special_object_icon" in param1)
         {
            this.no_special_object_icon = new ResourceKey(param1.no_special_object_icon);
         }
         if("cas_edit_no_sim_icon" in param1)
         {
            this.cas_edit_no_sim_icon = new ResourceKey(param1.cas_edit_no_sim_icon);
         }
      }
      
      public function HasGuestAttireData() : Boolean
      {
         return this.guest_attire_colors.length > 0 || this.guest_attire_styles.length > 0;
      }
      
      public function HasAppearanceModifier() : Boolean
      {
         return this.appearance_modifier_text != null;
      }
   }
}

