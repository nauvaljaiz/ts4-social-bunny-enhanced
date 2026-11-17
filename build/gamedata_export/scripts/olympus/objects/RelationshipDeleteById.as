package olympus.objects
{
   import olympus.core.OlympusObject;
   
   public class RelationshipDeleteById extends OlympusObject
   {
      
      public var actorId:String;
      
      public var targetId:String;
      
      public function RelationshipDeleteById(param1:Object = null)
      {
         super(param1);
      }
   }
}

