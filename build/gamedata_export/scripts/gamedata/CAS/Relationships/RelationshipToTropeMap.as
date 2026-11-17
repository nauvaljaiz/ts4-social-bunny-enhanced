package gamedata.CAS.Relationships
{
   import olympus.core.OlympusObject;
   
   public class RelationshipToTropeMap extends OlympusObject
   {
      
      public var key:uint;
      
      public var available_tropes:Array = [String];
      
      public function RelationshipToTropeMap(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.available_tropes);
      }
   }
}

