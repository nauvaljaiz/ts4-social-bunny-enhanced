package gamedata.TutorialTip
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class TutorialTipStaticData extends OlympusObject
   {
      
      public static const DISPLAY_TYPE_STANDARD:String = "0";
      
      public static const DISPLAY_TYPE_GAME_MODE:String = "1";
      
      public static const DISPLAY_TYPE_INDICATOR_ARROW:String = "2";
      
      public static const DISPLAY_TYPE_INDICATOR_CIRCLE_OVER:String = "3";
      
      public var id:String;
      
      public var cancelable:Boolean;
      
      public var text:LocKey = new LocKey();
      
      public var action_text:LocKey = new LocKey();
      
      public var timeout:int;
      
      public var ui_element:String;
      
      public var timeout_satisfies:Boolean;
      
      public var is_modal:Boolean;
      
      public var title:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var pagination_label:LocKey = new LocKey();
      
      public var next_tip_label:LocKey = new LocKey();
      
      public var display_type_option:String = "0";
      
      public var has_gameplay_immediate_test:Boolean = false;
      
      public var has_gameplay_test:Boolean = false;
      
      public function TutorialTipStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.action_text.IsValid())
         {
            this.action_text = null;
         }
         if(!this.pagination_label.IsValid())
         {
            this.pagination_label = null;
         }
         if(!this.next_tip_label.IsValid())
         {
            this.next_tip_label = null;
         }
         if(!("icon" in param1) || this.icon.instance == "0")
         {
            this.icon = null;
         }
      }
   }
}

