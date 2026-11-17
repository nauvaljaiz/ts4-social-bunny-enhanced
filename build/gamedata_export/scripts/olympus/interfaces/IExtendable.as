package olympus.interfaces
{
   public interface IExtendable
   {
      
      function AddExtension(param1:Class) : IExtension;
      
      function GetExtension(param1:Class, param2:Boolean = true) : IExtension;
      
      function RemoveExtension(param1:Class) : Boolean;
   }
}

