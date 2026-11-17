package gamedata.CAS.Genetics
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class GeneticSpeciesOption extends OlympusObject
   {
      
      public var species:int;
      
      public var icon:String;
      
      public var tooltip:LocKey = new LocKey();
      
      public var require_pack:int;
      
      public var enable_breed_selector:Boolean;
      
      public var require_household_sources_reason:LocKey = new LocKey();
      
      public var allow_children_with_unknown_source:Boolean;
      
      public var allow_parent_with_unknown_source:Boolean;
      
      public var allow_sibling_with_unknown_source:Boolean;
      
      public var mDisableReason:LocKey;
      
      public function GeneticSpeciesOption(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
      
      public function Clone() : GeneticSpeciesOption
      {
         var _loc1_:GeneticSpeciesOption = new GeneticSpeciesOption();
         _loc1_.species = this.species;
         _loc1_.icon = this.icon;
         _loc1_.tooltip = this.tooltip;
         _loc1_.require_pack = this.require_pack;
         _loc1_.enable_breed_selector = this.enable_breed_selector;
         _loc1_.require_household_sources_reason = this.require_household_sources_reason;
         _loc1_.allow_children_with_unknown_source = this.allow_children_with_unknown_source;
         _loc1_.allow_parent_with_unknown_source = this.allow_parent_with_unknown_source;
         _loc1_.allow_sibling_with_unknown_source = this.allow_sibling_with_unknown_source;
         return _loc1_;
      }
   }
}

