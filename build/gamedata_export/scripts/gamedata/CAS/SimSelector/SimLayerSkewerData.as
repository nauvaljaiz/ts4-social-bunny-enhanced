package gamedata.CAS.SimSelector
{
   import gamedata.shared.SimAgeTypes;
   import olympus.core.OlympusObject;
   
   public class SimLayerSkewerData extends OlympusObject
   {
      
      public var index:int;
      
      public var simId:String;
      
      public var firstName:String;
      
      public var lastName:String;
      
      public var breedName:String;
      
      public var age:int;
      
      public var speciesType:int;
      
      public var isNew:Boolean;
      
      public var hasBrokenRelationships:Boolean;
      
      public var relationshipId:int;
      
      public var tropeId:String;
      
      public var isPregnant:Boolean;
      
      public var occultType:int;
      
      public var allOccultTypes:int;
      
      public var occultLayer:int;
      
      public var isBaby:Boolean = true;
      
      public var alternativeTooltipText:String = "";
      
      public var enabled:Boolean;
      
      public var selected:Boolean;
      
      public var loadIcon:Boolean = true;
      
      public var add:Boolean;
      
      public var mbAllowInGenetics:Boolean;
      
      public function SimLayerSkewerData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.isBaby = SimAgeTypes.IsBaby(this.age);
         this.enabled = this.isBaby;
         this.add = false;
         this.mbAllowInGenetics = false;
      }
   }
}

