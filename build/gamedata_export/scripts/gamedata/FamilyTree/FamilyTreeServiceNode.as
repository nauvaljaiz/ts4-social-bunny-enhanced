package gamedata.FamilyTree
{
   import gamedata.Gameplay.shared.CareerInfo;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   import olympus.objects.RelationshipBitInfo;
   
   public class FamilyTreeServiceNode extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var spouse:String;
      
      public var fiance:String;
      
      public var parents:Array = [String];
      
      public var children:Array = [String];
      
      public var siblings:Array = [String];
      
      public var divorced_spouses:Array = [String];
      
      public var dead_spouses:Array = [String];
      
      public var sims_connected_by_forgery:Array = [String];
      
      public var first_name:String;
      
      public var last_name:String;
      
      public var localized_full_name:LocKey = new LocKey();
      
      public var thumbnail_override:ResourceKey = new ResourceKey();
      
      public var is_adopted:Boolean = false;
      
      public var is_forged:Boolean;
      
      public var known_secret_children:Array = [String];
      
      public var known_secret_parents:Array = [String];
      
      public var dead_kingdom_data:Object;
      
      public var bit:RelationshipBitInfo = new RelationshipBitInfo();
      
      public var death_trait_id:String;
      
      public var career:CareerInfo = new CareerInfo();
      
      public var latest_ex_spouse:String;
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var has_kingdom:Boolean = false;
      
      public var kingdom_level:uint;
      
      public var kingdom_title:String;
      
      public var kingdom_neighborhood_name:String;
      
      public var has_dynasty:Boolean = false;
      
      public var dynasty_icon:IconInfo;
      
      public var dynasty_icon_background:IconInfo;
      
      public var dynasty_name:String;
      
      public var dynasty_id:String;
      
      public var is_dynasty_heir:Boolean;
      
      public var is_dynasty_head:Boolean;
      
      public var is_dynasty_ally:Boolean;
      
      public var is_dynasty_rival:Boolean;
      
      public var is_dynasty_black_sheep:Boolean;
      
      public var spouse_node:FamilyTreeServiceNode;
      
      public function FamilyTreeServiceNode(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(this.spouse == "0")
         {
            this.spouse = null;
         }
         if(param1["localized_full_name"])
         {
            this.localized_full_name = LocKey.GetValidatedLocKey(param1.localized_full_name);
         }
         else
         {
            this.localized_full_name = KeysGP.RELATIONSHIP_PANEL_UNKNOWN_NAME;
         }
         FixupArray(this.parents);
         FixupArray(this.children);
         FixupArray(this.siblings);
         FixupArray(this.divorced_spouses);
         if(Boolean(this.divorced_spouses) && this.divorced_spouses.length > 0)
         {
            this.latest_ex_spouse = this.divorced_spouses[0] == "0" ? null : this.divorced_spouses[0];
         }
         FixupArray(this.dead_spouses);
         FixupArray(this.sims_connected_by_forgery);
         FixupArray(this.known_secret_children);
         FixupArray(this.known_secret_parents);
         if(!("career" in param1) || !param1.career)
         {
            this.career = null;
         }
         if(!("bit" in param1) || !param1.bit)
         {
            this.bit = null;
         }
         this.thumbnail_override = null;
         if("thumbnail_override" in param1)
         {
            this.thumbnail_override = new ResourceKey(param1.thumbnail_override);
         }
         if("dead_kingdom_data" in param1)
         {
            this.dead_kingdom_data = param1.dead_kingdom_data;
         }
      }
      
      public function toString() : String
      {
         return this.sim_id;
      }
      
      public function Clone() : FamilyTreeServiceNode
      {
         var _loc1_:FamilyTreeServiceNode = new FamilyTreeServiceNode();
         _loc1_.sim_id = this.sim_id;
         _loc1_.spouse = this.spouse;
         _loc1_.fiance = this.fiance;
         _loc1_.parents = this.parents;
         _loc1_.children = this.children;
         _loc1_.siblings = this.siblings;
         _loc1_.divorced_spouses = this.divorced_spouses;
         _loc1_.dead_spouses = this.dead_spouses;
         _loc1_.sims_connected_by_forgery = this.sims_connected_by_forgery;
         _loc1_.first_name = this.first_name;
         _loc1_.last_name = this.last_name;
         _loc1_.localized_full_name = this.localized_full_name;
         _loc1_.thumbnail_override = this.thumbnail_override;
         _loc1_.is_adopted = this.is_adopted;
         _loc1_.is_forged = this.is_forged;
         _loc1_.known_secret_children = this.known_secret_children;
         _loc1_.known_secret_parents = this.known_secret_parents;
         _loc1_.bit = this.bit;
         _loc1_.death_trait_id = this.death_trait_id;
         _loc1_.career = this.career;
         _loc1_.latest_ex_spouse = this.latest_ex_spouse;
         _loc1_.x = this.x;
         _loc1_.y = this.y;
         _loc1_.has_kingdom = this.has_kingdom;
         _loc1_.kingdom_level = this.kingdom_level;
         _loc1_.kingdom_title = this.kingdom_title;
         _loc1_.kingdom_neighborhood_name = this.kingdom_neighborhood_name;
         _loc1_.has_dynasty = this.has_dynasty;
         _loc1_.dynasty_icon = this.dynasty_icon;
         _loc1_.dynasty_icon_background = this.dynasty_icon_background;
         _loc1_.dynasty_name = this.dynasty_name;
         _loc1_.dynasty_id = this.dynasty_id;
         _loc1_.is_dynasty_heir = this.is_dynasty_heir;
         _loc1_.is_dynasty_head = this.is_dynasty_head;
         _loc1_.is_dynasty_ally = this.is_dynasty_ally;
         _loc1_.is_dynasty_rival = this.is_dynasty_rival;
         _loc1_.is_dynasty_black_sheep = this.is_dynasty_black_sheep;
         _loc1_.spouse_node = this.spouse_node;
         _loc1_.dead_kingdom_data = this.dead_kingdom_data;
         return _loc1_;
      }
   }
}

