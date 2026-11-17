package olympus.objects
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class RelationshipLabelData extends OlympusObject
   {
      
      public var label:String;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public function RelationshipLabelData(param1:Object = null)
      {
         super(param1);
      }
   }
}

