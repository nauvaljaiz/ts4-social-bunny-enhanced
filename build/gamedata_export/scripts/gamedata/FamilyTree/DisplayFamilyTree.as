package gamedata.FamilyTree
{
   import olympus.core.OlympusObject;
   
   public class DisplayFamilyTree extends OlympusObject
   {
      
      public var root_id:String;
      
      public var family_nodes:Array = [FamilyTreeServiceNode];
      
      public function DisplayFamilyTree(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1["root_id"])
         {
            this.root_id = null;
         }
         FixupArray(this.family_nodes);
      }
   }
}

