package olympus.core.bind3d.io
{
   import olympus.core.data.Multimap;
   
   public class ElementMessageAccumulator implements IElementCommunication
   {
      
      protected var mElementName:String;
      
      protected var mHandlerMap:Multimap;
      
      public function ElementMessageAccumulator(param1:String, param2:Multimap)
      {
         super();
         this.mElementName = param1;
         this.mHandlerMap = param2;
      }
      
      public function AddMessageListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.mHandlerMap.Insert(param1,new MessageHandlerInfo(this.mElementName,param3));
      }
   }
}

