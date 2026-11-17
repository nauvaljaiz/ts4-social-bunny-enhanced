package gamedata.Dialog
{
   import gamedata.shared.UiDialogNotification;
   import olympus.core.OlympusObject;
   
   public class UiPhoneRingMessage extends OlympusObject
   {
      
      public static const TYPE_NONE:int = 0;
      
      public static const TYPE_BUZZ:int = 1;
      
      public static const TYPE_RING:int = 2;
      
      public static const TYPE_ALARM:int = 3;
      
      public static const TYPE_PIVOTAL_MOMENT:int = 4;
      
      public var phone_ring_type:int;
      
      public var dialog:UiDialogMessage = new UiDialogNotification();
      
      public var caller_id:String;
      
      public function UiPhoneRingMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if("phone_ring_type" in param1)
         {
            this.phone_ring_type = param1.phone_ring_type;
         }
         if("dialog" in param1)
         {
            this.dialog.ParseObject(param1.dialog);
         }
         if("caller_id" in param1)
         {
            this.caller_id = param1.caller_id;
         }
      }
      
      public function get IsAlarmType() : Boolean
      {
         return this.phone_ring_type == TYPE_ALARM || this.phone_ring_type == TYPE_PIVOTAL_MOMENT;
      }
      
      public function GetLabelForRingType() : String
      {
         switch(this.phone_ring_type)
         {
            case TYPE_BUZZ:
               return "text";
            case TYPE_RING:
               return "ring";
            case TYPE_ALARM:
               return "alarm";
            case TYPE_PIVOTAL_MOMENT:
               return "alarm";
            default:
               return "none";
         }
      }
   }
}

