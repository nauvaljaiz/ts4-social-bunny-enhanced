package gamedata.CAS.GenderOptions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public final class GenderOptionValueData extends OlympusObject
   {
      
      public var traitIdList:Array = [String];
      
      public var unselectedTraitIdList:Array = [String];
      
      public var name:LocKey = new LocKey();
      
      public var isMaleDefault:Boolean;
      
      public var isFemaleDefault:Boolean;
      
      public var isUnselectedMaleDefault:Boolean;
      
      public var isUnselectedFemaleDefault:Boolean;
      
      public function GenderOptionValueData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.traitIdList);
         FixupArray(this.unselectedTraitIdList);
      }
   }
}

