package gamedata.Gameplay.Rewards
{
   import gamedata.Gameplay.shared.IItemData;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class GameplayPerk extends OlympusObject implements IReward, IItemData
   {
      
      public static const PERK_TYPE_DEFAULT:int = 0;
      
      public static const PERK_TYPE_OBJECT:int = 1;
      
      public static const PERK_TYPE_CASPART:int = 2;
      
      public static const DISPLAY_FLAG_LINK_TOP:uint = 1 << 0;
      
      public static const DISPLAY_FLAG_ALIGN_LEFT:uint = 1 << 1;
      
      public static const DISPLAY_FLAG_STEM_LEFT:uint = 1 << 2;
      
      public static const DISPLAY_FLAG_STEM_RIGHT:uint = 1 << 3;
      
      public var id:String;
      
      public var type:int = 0;
      
      public var display_name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var disabled_tooltip:LocKey = new LocKey();
      
      public var icon:IconInfo = new IconInfo();
      
      public var cost:uint;
      
      public var affordable:Boolean;
      
      public var purchased:Boolean;
      
      public var locked:Boolean;
      
      public var lock_on_purchase:Array = [String];
      
      public var conflicting_perks:Array = [String];
      
      public var next_perk_id:String;
      
      public var required_perks:Array = [String];
      
      public var recently_locked:Boolean;
      
      public var locked_from_tests:Boolean;
      
      public var ui_display_flags:uint = 0;
      
      protected var mDeactivated:uint = 0;
      
      public function GameplayPerk(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.lock_on_purchase);
         FixupArray(this.conflicting_perks);
         FixupArray(this.required_perks);
         if(!this.display_name.IsValid())
         {
            this.display_name = null;
         }
         if(!this.description.IsValid())
         {
            this.description = null;
         }
         if(!this.disabled_tooltip.IsValid())
         {
            this.disabled_tooltip = null;
         }
      }
      
      public function get IsFound() : Boolean
      {
         return this.purchased;
      }
      
      public function get Id() : String
      {
         return this.id;
      }
      
      public function get Name() : String
      {
         return this.display_name ? this.display_name.toString() : "";
      }
      
      public function get Description() : String
      {
         return this.description ? this.description.toString() : "";
      }
      
      public function get Icon() : String
      {
         return this.icon.icon.instance;
      }
      
      public function get Cost() : uint
      {
         return this.cost;
      }
      
      public function get Affordable() : Boolean
      {
         return this.affordable;
      }
      
      public function set Affordable(param1:Boolean) : void
      {
         this.affordable = param1;
      }
      
      public function get Available() : Boolean
      {
         return !this.purchased;
      }
      
      public function get Locked() : Boolean
      {
         return this.locked;
      }
      
      public function get DisabledTooltip() : LocKey
      {
         if(this.disabled_tooltip)
         {
            return this.disabled_tooltip;
         }
         if(this.locked)
         {
            return KeysGP.REWARDS_PICKER_LOCKED_TOOLTIP;
         }
         if(this.purchased)
         {
            return KeysGP.REWARDS_PICKER_UNAVAILABLE_TOOLTIP;
         }
         if(!this.affordable)
         {
            return KeysGP.REWARDS_PICKER_INSUFFICIENT_POINTS_TOOLTIP;
         }
         return null;
      }
      
      public function get LinkLabel() : String
      {
         if(this.ui_display_flags & DISPLAY_FLAG_LINK_TOP)
         {
            return "link_top";
         }
         return null;
      }
      
      public function get GetLeftShiftLabel() : String
      {
         if(this.ui_display_flags & DISPLAY_FLAG_ALIGN_LEFT)
         {
            return "left";
         }
         return null;
      }
      
      public function get GetStemLeftLabel() : String
      {
         if(this.ui_display_flags & DISPLAY_FLAG_STEM_LEFT)
         {
            return "stem_left";
         }
         return null;
      }
      
      public function get GetStemRightLabel() : String
      {
         if(this.ui_display_flags & DISPLAY_FLAG_STEM_RIGHT)
         {
            return "stem_right";
         }
         return null;
      }
      
      public function get Deactivated() : uint
      {
         return this.mDeactivated;
      }
      
      public function set Deactivated(param1:uint) : void
      {
         this.mDeactivated = param1;
      }
   }
}

