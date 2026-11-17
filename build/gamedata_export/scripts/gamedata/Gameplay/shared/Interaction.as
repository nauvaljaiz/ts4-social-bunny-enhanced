package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public final class Interaction extends OlympusObject
   {
      
      public static const VISUAL_TYPE_SIMPLE:int = 0;
      
      public static const VISUAL_TYPE_PARENT:int = 1;
      
      public static const VISUAL_TYPE_MIXER:int = 2;
      
      public static const VISUAL_TYPE_POSTURE:int = 3;
      
      public static const IQ_UI_STATE_QUEUED:int = 0;
      
      public static const IQ_UI_STATE_TRANSITIONING:int = 1;
      
      public static const IQ_UI_STATE_RUNNING:int = 2;
      
      public static const POLARITY_NEUTRAL:int = 0;
      
      public static const POLARITY_NEGATIVE:int = 1;
      
      public static const POLARITY_POSTIIVE:int = 2;
      
      public var sim_id:String;
      
      public var interaction_id:String;
      
      public var insert_after_id:String;
      
      public var super_id:String;
      
      public var canceled:Boolean;
      
      public var cancelable:Boolean;
      
      public var visual_type:int;
      
      public var queue_ui_state:int;
      
      public var icon_info:IconInfo;
      
      public var interactions_to_be_canceled:Array;
      
      public var mood_list:Array;
      
      public var super_icon_info:IconInfo;
      
      public var context_handle:uint;
      
      public var replace_id:String;
      
      public function Interaction(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.sim_id = param1.sim_id;
         this.interaction_id = param1.interaction_id;
         this.insert_after_id = param1.insert_after_id;
         this.super_id = param1.super_id;
         this.canceled = param1.canceled;
         this.cancelable = param1.cancelable;
         this.visual_type = param1.visual_type;
         this.queue_ui_state = param1.queue_ui_state;
         this.context_handle = param1.context_handle;
         this.replace_id = param1.replace_id;
         if("icon_info" in param1)
         {
            this.icon_info = new IconInfo(param1.icon_info);
         }
         this.interactions_to_be_canceled = new Array();
         if("interactions_to_be_canceled" in param1)
         {
            ConstructArrayFromArray(this.interactions_to_be_canceled,param1.interactions_to_be_canceled,String);
         }
         this.mood_list = new Array();
         if("mood_list" in param1)
         {
            ConstructArrayFromArray(this.mood_list,param1.mood_list,String);
         }
         if("super_icon_info" in param1)
         {
            this.super_icon_info = new IconInfo(param1.super_icon_info);
         }
      }
   }
}

