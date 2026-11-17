package gamedata.CAS.Relationships
{
   public class CASSimTropesStaticData extends CASSimTropesStaticDataBase
   {
      
      public var sim_trope_items:Array = [SimTropeItem];
      
      public var relationship_type_to_tropes:Array = [RelationshipToTropeMap];
      
      public var relationship_type_to_bit:Array = [RelationshipToBitMap];
      
      public function CASSimTropesStaticData(param1:Object = null)
      {
         super(param1);
         sim_trope_items_container = this.sim_trope_items;
         relationship_type_to_tropes_container = this.relationship_type_to_tropes;
         relationship_type_to_bit_container = this.relationship_type_to_bit;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_trope_items);
         FixupArray(this.relationship_type_to_tropes);
         FixupArray(this.relationship_type_to_bit);
      }
   }
}

