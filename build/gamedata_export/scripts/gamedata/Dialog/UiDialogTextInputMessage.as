package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UiDialogTextInputMessage extends OlympusObject
   {
      
      public var text_input_name:String;
      
      public var default_text:LocKey = new LocKey();
      
      public var initial_value:LocKey = new LocKey();
      
      public var min_length:int;
      
      public var max_length:int;
      
      public var max_value:int;
      
      public var min_value:int;
      
      public var restricted_characters:LocKey = new LocKey();
      
      public var input_too_short_tooltip:LocKey = new LocKey();
      
      public var input_invalid_max_tooltip:LocKey = new LocKey();
      
      public var input_invalid_min_tooltip:LocKey = new LocKey();
      
      public var title:LocKey = new LocKey();
      
      public var has_max_value:Boolean;
      
      public var has_min_value:Boolean;
      
      public var check_profanity:Boolean;
      
      public var height:int;
      
      public function UiDialogTextInputMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("restricted_characters" in param1) || !param1.restricted_characters)
         {
            this.restricted_characters = null;
         }
         this.has_max_value = "max_value" in param1;
         this.has_min_value = "min_value" in param1;
      }
   }
}

