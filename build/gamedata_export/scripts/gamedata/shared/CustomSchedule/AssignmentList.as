package gamedata.shared.CustomSchedule
{
   import olympus.core.OlympusObject;
   
   public class AssignmentList extends OlympusObject
   {
      
      public var assignments:Array = [AssignmentListData];
      
      public function AssignmentList(param1:Object = null)
      {
         super(param1);
         FixupArray(this.assignments);
      }
   }
}

