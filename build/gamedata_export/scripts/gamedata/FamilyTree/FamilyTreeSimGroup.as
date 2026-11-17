package gamedata.FamilyTree
{
   import widgets.shared.controls.FamilyTree.FamilyTreeSimContainer;
   
   public class FamilyTreeSimGroup
   {
      
      public static const RIGHT_SPOUSE_FLAG:int = 1;
      
      public static const LEFT_SPOUSE_FLAG:int = 2;
      
      public static const STEP_SIBLINGS:int = 3;
      
      public static const STEP_CHILDREN:int = 4;
      
      public var mSims:Array;
      
      public var mFlag:int;
      
      public var mContainer:FamilyTreeSimContainer;
      
      public function FamilyTreeSimGroup()
      {
         super();
      }
   }
}

