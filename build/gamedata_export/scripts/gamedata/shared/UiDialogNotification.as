package gamedata.shared
{
   import gamedata.Dialog.UiDialogChoiceMessage;
   import gamedata.Dialog.UiDialogMessage;
   import gamedata.Gameplay.shared.CareerInfo;
   
   public class UiDialogNotification extends UiDialogMessage
   {
      
      public static const EXPAND_BEHAVIOR_USER:int = 0;
      
      public static const EXPAND_BEHAVIOR_FORCE:int = 1;
      
      public static const CRITICALITY_DEFAULT:int = 0;
      
      public static const CRITICALITY_URGENT:int = 1;
      
      public static const LEVEL_PLAYER:int = 0;
      
      public static const LEVEL_SIM:int = 1;
      
      public static const LEVEL_GALLERY:int = 2;
      
      public static const VISUAL_TYPE_INFORMATION:int = 0;
      
      public static const VISUAL_TYPE_SPEECH:int = 1;
      
      public static const VISUAL_TYPE_SPECIAL_MOMENT:int = 2;
      
      public static const AUTO_DELETE_REASON_NO_REASON:* = 0;
      
      public static const AUTO_DELETE_REASON_LEAVE_LIVE_MODE:* = 1;
      
      public var expand_behavior:int;
      
      public var criticality:int;
      
      public var information_level:int;
      
      public var visual_type:int;
      
      public var primary_icon_reference:UiDialogChoiceMessage;
      
      public var secondary_icon_response:UiDialogChoiceMessage;
      
      public var save_uid:String;
      
      public var does_persist:Boolean;
      
      public var career_args:CareerInfo;
      
      public var auto_delete_reason:int;
      
      public var disable_prompt_buttons_during_save_lock:Boolean;
      
      public function UiDialogNotification(param1:Object = null)
      {
         super(param1);
         dialog_type = UiDialogMessage.TYPE_NOTIFICATION;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.expand_behavior = "expand_behavior" in param1 ? int(param1.expand_behavior) : EXPAND_BEHAVIOR_USER;
         this.criticality = "criticality" in param1 ? int(param1.criticality) : CRITICALITY_DEFAULT;
         this.information_level = "information_level" in param1 ? int(param1.information_level) : LEVEL_SIM;
         this.visual_type = "visual_type" in param1 ? int(param1.visual_type) : VISUAL_TYPE_INFORMATION;
         if("primary_icon_response" in param1)
         {
            this.primary_icon_reference = new UiDialogChoiceMessage(param1.primary_icon_response);
         }
         if("secondary_icon_response" in param1)
         {
            this.secondary_icon_response = new UiDialogChoiceMessage(param1.secondary_icon_response);
         }
         this.save_uid = param1["save_uid"] || "0";
         this.does_persist = "does_persist" in param1 ? Boolean(param1.does_persist) : true;
         if("career_args" in param1 && Boolean(param1.career_args))
         {
            this.career_args = new CareerInfo(param1.career_args);
         }
         this.auto_delete_reason = "auto_delete_reason" in param1 ? int(param1.auto_delete_reason) : int(AUTO_DELETE_REASON_NO_REASON);
         this.disable_prompt_buttons_during_save_lock = "disable_prompt_buttons_during_save_lock" in param1 ? Boolean(param1.disable_prompt_buttons_during_save_lock) : false;
      }
   }
}

