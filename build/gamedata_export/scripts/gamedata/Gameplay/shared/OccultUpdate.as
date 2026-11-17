package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class OccultUpdate extends OlympusObject
   {
      
      public var simId:String;
      
      public var occult_type:uint;
      
      public function OccultUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      public function get Type() : uint
      {
         return this.occult_type;
      }
   }
}

