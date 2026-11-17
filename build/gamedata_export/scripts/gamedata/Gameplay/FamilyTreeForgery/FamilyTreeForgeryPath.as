package gamedata.Gameplay.FamilyTreeForgery
{
   import olympus.core.OlympusObject;
   
   public class FamilyTreeForgeryPath extends OlympusObject
   {
      
      public var sim_ids:Array = [String];
      
      public var forged_to_next_states:Array = [Boolean];
      
      public function FamilyTreeForgeryPath(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_ids);
      }
   }
}

