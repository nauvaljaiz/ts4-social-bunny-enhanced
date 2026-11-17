package gamedata.FamilyTree
{
   import gamedata.Gameplay.shared.CareerInfo;
   import olympus.core.OlympusObject;
   
   public class FamilyTreeNode extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var spouse:FamilyTreeNode = null;
      
      public var parents:Array = [FamilyTreeNode];
      
      public var children:Array = [FamilyTreeNode];
      
      public var death_trait_id:String;
      
      public var career:CareerInfo = new CareerInfo();
      
      public function FamilyTreeNode(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(param1["spouse"])
         {
            this.spouse = new FamilyTreeNode(param1.spouse);
         }
         FixupArray(this.parents);
         FixupArray(this.children);
         if(!("career" in param1) || !param1.career)
         {
            this.career = null;
         }
      }
      
      public function toString() : String
      {
         return this.sim_id;
      }
   }
}

