package gamedata.CAS.ContextMenu
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CASContextMenuItem extends OlympusObject
   {
      
      public var context:int = 0;
      
      public var icon:String;
      
      public var icon_selected:String;
      
      public var icon_gold:String;
      
      public var icon_male:String;
      
      public var icon_female:String;
      
      public var icon_selected_male:String;
      
      public var icon_selected_female:String;
      
      public var icon_gold_male:String;
      
      public var icon_gold_female:String;
      
      public var title:LocKey = new LocKey();
      
      public var tag:int;
      
      public var tag_exclude:int;
      
      public var component_name:String = "";
      
      public var action:Object;
      
      public var action_display_ui_widget:String;
      
      public var sub_items:Array = [CASContextMenuItem];
      
      public var enabled:Boolean = true;
      
      public var disable_reason:LocKey = new LocKey();
      
      public var disallow_remove:Boolean;
      
      public var remove_paint_layer:Boolean;
      
      public var remove_part_and_paint_layer:Boolean;
      
      public var hack_use_gender_as_pet_species:Boolean = false;
      
      public var bSiblingSelected:Boolean = false;
      
      public var bodyType:int;
      
      public var selected:Boolean;
      
      public var is_item_of_interest:Boolean;
      
      public var seen_item_of_interest:Boolean;
      
      public var bSubContextMenu:Boolean;
      
      public function CASContextMenuItem(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:CASContextMenuItem = null;
         super.ParseObject(param1);
         OlympusObject.FixupArray(this.sub_items);
         for each(_loc2_ in this.sub_items)
         {
            _loc2_.bSubContextMenu = true;
         }
         if(this.disable_reason.IsValid())
         {
            this.enabled = false;
            this.title = this.disable_reason;
         }
      }
      
      public function SetIcon(param1:Boolean) : void
      {
         this.icon = (param1 ? this.icon_female : this.icon_male) || this.icon;
         this.icon_selected = (param1 ? this.icon_selected_female : this.icon_selected_male) || this.icon_selected || this.icon;
         this.icon_gold = (param1 ? this.icon_gold_female : this.icon_gold_male) || this.icon_gold || this.icon;
      }
   }
}

