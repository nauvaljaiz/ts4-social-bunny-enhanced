package gamedata.CAS.Relationships
{
   import olympus.core.OlympusObject;
   
   public class CASSimTropesStaticDataBase extends OlympusObject
   {
      
      public var sim_trope_items_container:Array = [SimTropeItem];
      
      public var relationship_type_to_tropes_container:Array = [RelationshipToTropeMap];
      
      public var relationship_type_to_bit_container:Array = [RelationshipToBitMap];
      
      protected var mTropeIdToTropeItemMap:Object = null;
      
      protected var mDropdownOptions:Array;
      
      public function CASSimTropesStaticDataBase(param1:Object = null)
      {
         super(param1);
      }
      
      public function get DropdownOptions() : Array
      {
         return this.mDropdownOptions;
      }
      
      public function get TropeIdToTropeItemMap() : Object
      {
         return this.mTropeIdToTropeItemMap;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_trope_items_container);
         FixupArray(this.relationship_type_to_tropes_container);
         FixupArray(this.relationship_type_to_bit_container);
      }
      
      public function SetupRelationshipTypeToTropesMap() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SimTropeItem = null;
         var _loc3_:String = null;
         if(!this.mTropeIdToTropeItemMap)
         {
            this.mTropeIdToTropeItemMap = new Object();
            _loc1_ = 0;
            while(_loc1_ < this.sim_trope_items_container.length)
            {
               _loc2_ = this.sim_trope_items_container[_loc1_];
               _loc3_ = _loc2_.trope_id;
               this.mTropeIdToTropeItemMap[_loc3_] = _loc2_;
               _loc1_++;
            }
         }
      }
      
      public function GetTropesFromRelationshipType(param1:uint) : Array
      {
         var _loc3_:RelationshipToTropeMap = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.relationship_type_to_tropes_container.length)
         {
            _loc3_ = this.relationship_type_to_tropes_container[_loc2_];
            if(_loc3_.key == param1)
            {
               return _loc3_.available_tropes;
            }
            _loc2_++;
         }
         return new Array();
      }
   }
}

