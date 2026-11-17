package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   
   public class UiCommandArgs extends OlympusObject
   {
      
      public var command_name:String;
      
      public var command_remote_args:Object;
      
      public function UiCommandArgs(param1:Object = null)
      {
         super(param1);
      }
   }
}

