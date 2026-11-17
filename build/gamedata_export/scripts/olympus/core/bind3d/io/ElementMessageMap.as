package olympus.core.bind3d.io
{
   public dynamic class ElementMessageMap implements IElementCommunication
   {
      
      public function ElementMessageMap()
      {
         super();
      }
      
      public function AddMessageListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this[param1] = param2;
      }
   }
}

