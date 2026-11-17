package gamedata.Gameplay.FamilyTreeForgery
{
   import olympus.core.OlympusObject;
   
   public class FamilyTreeForgeryRelationOptions extends OlympusObject
   {
      
      public var relbit_ids:Array = [String];
      
      public var possible_paths:Array = [FamilyTreeForgeryPath];
      
      public function FamilyTreeForgeryRelationOptions(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.possible_paths);
         FixupArray(this.relbit_ids);
      }
   }
}

