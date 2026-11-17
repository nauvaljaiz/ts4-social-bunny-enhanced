package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class TraitAppearanceOverrideData extends OlympusObject
   {
      
      public var match_all:Array = [TraitApperanceOverrideCriterionData];
      
      public var title:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var trait_origin_description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      protected var mbHasAgeCriteria:Boolean = false;
      
      protected var mbHasOccultTypeCriteria:Boolean = false;
      
      protected var mbHasTraitsCriteria:Boolean = false;
      
      public function TraitAppearanceOverrideData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:TraitApperanceOverrideCriterionData = null;
         super.ParseObject(param1);
         FixupArray(this.match_all);
         this.title = FixupLocKey(this.title);
         this.description = FixupLocKey(this.description);
         this.trait_origin_description = FixupLocKey(this.trait_origin_description);
         if(Boolean(this.icon) && this.icon.instance == "0")
         {
            this.icon = null;
         }
         for each(_loc2_ in this.match_all)
         {
            if(_loc2_.age.length > 0)
            {
               this.mbHasAgeCriteria = true;
            }
            if(_loc2_.occult_type.length > 0)
            {
               this.mbHasOccultTypeCriteria = true;
            }
            if(_loc2_.traits.length > 0)
            {
               this.mbHasTraitsCriteria = true;
            }
         }
      }
      
      public function get HasAgeCriteria() : Boolean
      {
         return this.mbHasAgeCriteria;
      }
      
      public function get HasOccultTypeCriteria() : Boolean
      {
         return this.mbHasOccultTypeCriteria;
      }
      
      public function get HasTraitsCriteria() : Boolean
      {
         return this.mbHasTraitsCriteria;
      }
   }
}

