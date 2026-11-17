package gamedata.Gameplay.InteractionMenu
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class InteractionMenuItem extends OlympusObject
   {
      
      public var id:uint;
      
      public var loc_string:LocKey = new LocKey();
      
      public var related_skills:Array = [String];
      
      public var target_ids:Array = [String];
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var disabled_text:LocKey = new LocKey();
      
      public var score_icon:ResourceKey = new ResourceKey();
      
      public var category_key:String;
      
      public var is_primary_si:Boolean;
      
      public var score:Number = 0;
      
      public var icons:Array = [ResourceKey];
      
      public var icon_infos:Array = [IconInfo];
      
      public var mood:String;
      
      public var mood_intensity:int;
      
      public var pie_menu_priority:uint;
      
      public var success_tooltip:LocKey = new LocKey();
      
      public var bDisabled:Boolean = false;
      
      public var mNormalizedScore:Number = 0;
      
      public var display_notification:Boolean = false;
      
      public var affordance_id:String;
      
      public var phone_notification_control_override:Boolean = false;
      
      public function InteractionMenuItem(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.icons);
         FixupArray(this.icon_infos);
         if(!("icon" in param1))
         {
            this.icon = null;
         }
         if(this.icons.length == 0 && Boolean(this.icon))
         {
            this.icons.push(this.icon);
         }
         if(this.disabled_text.toString() != "")
         {
            this.bDisabled = true;
         }
         if(!this.success_tooltip.IsValid())
         {
            this.success_tooltip = null;
         }
         this.score = Math.max(this.score,0);
      }
   }
}

