package olympus.dialog
{
   import flash.display.DisplayObjectContainer;
   import olympus.constants.DialogModality;
   import olympus.motion.TweenParams;
   
   public class DialogRequest
   {
      
      public var dialog:IDialog;
      
      public var data:IDialogData;
      
      public var modality:int = DialogModality.SYSTEM;
      
      public var localContainer:DisplayObjectContainer;
      
      public var tweenInParams:TweenParams;
      
      public var bAnimateOut:Boolean = false;
      
      public function DialogRequest(param1:IDialog, param2:IDialogData)
      {
         super();
         this.dialog = param1;
         this.data = param2;
      }
   }
}

