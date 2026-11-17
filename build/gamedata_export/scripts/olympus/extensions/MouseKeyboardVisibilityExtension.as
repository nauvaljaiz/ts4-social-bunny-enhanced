package olympus.extensions
{
   import olympus.interfaces.IExtendable;
   
   public class MouseKeyboardVisibilityExtension extends InputModeVisibilityExtension
   {
      
      public function MouseKeyboardVisibilityExtension()
      {
         super();
      }
      
      public static function Add(param1:IExtendable) : void
      {
         InputModeVisibilityExtension.ShowForMouseKeyboard(param1);
      }
      
      public static function SetVisible(param1:IExtendable, param2:Boolean) : void
      {
         if(!InputModeVisibilityExtension.Get(param1,false))
         {
            InputModeVisibilityExtension.ShowForMouseKeyboard(param1);
         }
         InputModeVisibilityExtension.SetVisible(param1,param2);
      }
   }
}

