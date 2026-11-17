package gamedata.FamilyTree
{
   public class FamilyTreeRootNode extends FamilyTreeNode
   {
      
      public var full_siblings:Array = [FamilyTreeNode];
      
      public var half_siblings_from_parent_0:Array = [FamilyTreeNode];
      
      public var half_siblings_from_parent_1:Array = [FamilyTreeNode];
      
      public var shared_children_from_spouse:Array = [FamilyTreeNode];
      
      public var step_parent_0:FamilyTreeNode = null;
      
      public var step_parent_1:FamilyTreeNode = null;
      
      public var half_siblings_from_step_parent_0:Array = [FamilyTreeNode];
      
      public var half_siblings_from_step_parent_1:Array = [FamilyTreeNode];
      
      public var step_siblings_0:Array = [FamilyTreeNode];
      
      public var step_siblings_1:Array = [FamilyTreeNode];
      
      public var step_children:Array = [FamilyTreeNode];
      
      public function FamilyTreeRootNode(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.full_siblings);
         FixupArray(this.half_siblings_from_parent_0);
         FixupArray(this.half_siblings_from_parent_1);
         FixupArray(this.shared_children_from_spouse);
         if(param1["step_parent_0"])
         {
            this.step_parent_0 = new FamilyTreeNode(param1.step_parent_0);
         }
         if(param1["step_parent_1"])
         {
            this.step_parent_1 = new FamilyTreeNode(param1.step_parent_1);
         }
         FixupArray(this.half_siblings_from_step_parent_0);
         FixupArray(this.half_siblings_from_step_parent_1);
         FixupArray(this.step_siblings_0);
         FixupArray(this.step_siblings_1);
         FixupArray(this.step_children);
      }
   }
}

