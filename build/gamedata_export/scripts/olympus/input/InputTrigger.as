package olympus.input
{
   import flash.events.KeyboardEvent;
   
   public class InputTrigger
   {
      
      public static const TYPE_KEYCODE:uint = 0;
      
      public static const TYPE_ACTIONCODE:uint = 1;
      
      public static const MODIFIER_SHIFT:uint = 1 << 0;
      
      public static const MODIFIER_CTRL:uint = 1 << 1;
      
      public static const MODIFIER_ALT:uint = 1 << 2;
      
      public static const MODIFIER_MASK:uint = MODIFIER_SHIFT | MODIFIER_CTRL | MODIFIER_ALT;
      
      protected var mInputTriggerType:uint;
      
      protected var mCode:uint;
      
      protected var mModifiers:uint;
      
      protected var mActionCodeIsOnDown:Boolean;
      
      public function InputTrigger()
      {
         super();
      }
      
      public static function FromKeyBinding(param1:uint, param2:uint = 0) : InputTrigger
      {
         var _loc3_:InputTrigger = new InputTrigger();
         _loc3_.mInputTriggerType = TYPE_KEYCODE;
         _loc3_.mCode = param1;
         _loc3_.mModifiers = param2 & MODIFIER_MASK;
         return _loc3_;
      }
      
      public static function FromKeyboardEvent(param1:KeyboardEvent) : InputTrigger
      {
         var _loc2_:InputTrigger = new InputTrigger();
         _loc2_.mInputTriggerType = TYPE_KEYCODE;
         _loc2_.mCode = param1.keyCode;
         _loc2_.mModifiers = 0;
         if(param1.shiftKey)
         {
            _loc2_.mModifiers |= MODIFIER_SHIFT;
         }
         if(param1.ctrlKey)
         {
            _loc2_.mModifiers |= MODIFIER_CTRL;
         }
         if(param1.altKey)
         {
            _loc2_.mModifiers |= MODIFIER_ALT;
         }
         return _loc2_;
      }
      
      public static function FromActionCode(param1:uint, param2:Boolean = true) : InputTrigger
      {
         var _loc3_:InputTrigger = new InputTrigger();
         _loc3_.mInputTriggerType = TYPE_ACTIONCODE;
         _loc3_.mCode = param1;
         _loc3_.mActionCodeIsOnDown = param2;
         return _loc3_;
      }
      
      public function toString() : String
      {
         if(this.mInputTriggerType == TYPE_KEYCODE)
         {
            return ["[InputTrigger key=",this.mCode,", modifiers=",this.mModifiers,"]"].join("");
         }
         return ["[InputTrigger action=",this.mCode,", ondown=",this.mActionCodeIsOnDown,"]"].join("");
      }
      
      public function get InputTriggerType() : uint
      {
         return this.mInputTriggerType;
      }
      
      public function get Code() : uint
      {
         return this.mCode;
      }
   }
}

