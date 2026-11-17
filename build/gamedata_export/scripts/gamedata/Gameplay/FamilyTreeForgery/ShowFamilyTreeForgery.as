package gamedata.Gameplay.FamilyTreeForgery
{
   import olympus.core.OlympusObject;
   
   public class ShowFamilyTreeForgery extends OlympusObject
   {
      
      public var origin_sim_id:String;
      
      public var target_sim_id:String;
      
      public var all_possible_relations:Array = [FamilyTreeForgeryRelationOptions];
      
      public var path_sim_from_picker:String;
      
      public var forger_sim_id:String;
      
      public function ShowFamilyTreeForgery(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.all_possible_relations);
      }
   }
}

