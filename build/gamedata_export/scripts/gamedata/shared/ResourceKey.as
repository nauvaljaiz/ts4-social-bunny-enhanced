package gamedata.shared
{
   import olympus.core.OlympusObject;
   
   public class ResourceKey extends OlympusObject
   {
      
      public var instance:String = "0";
      
      public var type:uint;
      
      public var group:uint;
      
      public function ResourceKey(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(param1 is String)
         {
            this.instance = param1 as String;
         }
         else if(param1)
         {
            this.instance = param1["instance"];
            this.type = param1["type"];
            this.group = param1["group"];
         }
      }
      
      public function IsEqual(param1:Object) : Boolean
      {
         return this.instance == param1.instance && this.type == param1.type && this.group == param1.group;
      }
      
      public function ToObject() : Object
      {
         return {
            "instance":this.instance,
            "type":this.type,
            "group":this.group
         };
      }
   }
}

