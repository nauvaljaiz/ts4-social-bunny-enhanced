package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   
   public class UiDialogCommandArg extends OlympusObject
   {
      
      public var arg_bool:Boolean;
      
      public var arg_str:String;
      
      public var arg_float:Number = 0;
      
      public var arg_int:int;
      
      public function UiDialogCommandArg(param1:Object = null)
      {
         super(param1);
      }
   }
}

