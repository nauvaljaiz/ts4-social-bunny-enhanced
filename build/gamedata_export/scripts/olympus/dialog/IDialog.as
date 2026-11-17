package olympus.dialog
{
   import flash.events.IEventDispatcher;
   
   public interface IDialog extends IEventDispatcher
   {
      
      function set data(param1:IDialogData) : void;
      
      function NotifyModal() : void;
      
      function Resize(param1:Number, param2:Number) : void;
   }
}

