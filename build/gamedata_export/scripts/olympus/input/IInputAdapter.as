package olympus.input
{
   public interface IInputAdapter extends IInputFocusable
   {
      
      function OnInputEventCall(param1:String, param2:Function) : IInputAdapter;
   }
}

