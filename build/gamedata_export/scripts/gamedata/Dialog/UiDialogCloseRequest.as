package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   
   public class UiDialogCloseRequest extends OlympusObject
   {
      
      public var dialog_id:String;
      
      public function UiDialogCloseRequest(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.dialog_id = param1.dialog_id;
      }
   }
}

