package gamedata.FamilyTree
{
   import olympus.core.OlympusObject;
   
   public class ShowFamilyTree extends OlympusObject
   {
      
      public var root:FamilyTreeRootNode = new FamilyTreeRootNode();
      
      public function ShowFamilyTree(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1["root"])
         {
            this.root = null;
         }
      }
   }
}

