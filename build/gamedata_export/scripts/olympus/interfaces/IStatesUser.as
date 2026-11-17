package olympus.interfaces
{
   public interface IStatesUser
   {
      
      function SetState(param1:String) : void;
      
      function SetStatePrefix(param1:String) : void;
      
      function EnableStatePrefix(param1:String, param2:Boolean = true) : void;
      
      function DisableStatePrefix(param1:String, param2:Boolean = true) : void;
   }
}

