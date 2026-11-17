package olympus.io.interfaces
{
   public interface ICommunicationMapping
   {
      
      function AddMapping(param1:String, param2:Class) : Boolean;
      
      function RemoveMapping(param1:String) : Boolean;
   }
}

