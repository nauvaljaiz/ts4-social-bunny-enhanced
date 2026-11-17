package olympus.input
{
   import olympus.gamepad.EnterParams;
   
   public interface IInputFocusable
   {
      
      function Enter(param1:EnterParams = null) : IInputFocusable;
      
      function Exit() : void;
   }
}

