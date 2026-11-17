package gamedata.CAS.shared
{
   import olympus.core.OlympusObject;
   
   public class CASPeltColorSwatch extends OlympusObject
   {
      
      public var dataID:String;
      
      public var color:uint;
      
      public var isModded:Boolean;
      
      public function CASPeltColorSwatch(param1:Object = null)
      {
         super(param1);
      }
      
      public function get SwatchColor() : uint
      {
         return uint(this.dataID);
      }
      
      public function get DisplayColor() : uint
      {
         return this.color;
      }
   }
}

