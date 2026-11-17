package olympus.io
{
   import olympus.core.OlympusObject;
   import olympus.io.interfaces.ICommunicationMapping;
   
   public dynamic class CommunicationMapping implements ICommunicationMapping
   {
      
      public function CommunicationMapping()
      {
         super();
      }
      
      public function AddMapping(param1:String, param2:Class) : Boolean
      {
         if(this[param1])
         {
            if(this[param1] != param2)
            {
               return false;
            }
            return true;
         }
         var _loc3_:Object = new param2();
         if(!(_loc3_ is OlympusObject))
         {
            return false;
         }
         this[param1] = param2;
         return true;
      }
      
      public function RemoveMapping(param1:String) : Boolean
      {
         if(this[param1])
         {
            delete this[param1];
            return true;
         }
         return false;
      }
   }
}

