package olympus.core.bind3d.io
{
   public class MessageHandlerInfo
   {
      
      public var elementName:String;
      
      public var instantiatesElement:Boolean;
      
      public function MessageHandlerInfo(param1:String, param2:Boolean)
      {
         super();
         this.elementName = param1;
         this.instantiatesElement = param2;
      }
      
      public function toString() : String
      {
         return "[MessageHandlerInfo elementName=\'" + this.elementName + "\' instantiatesElement=" + this.instantiatesElement;
      }
   }
}

