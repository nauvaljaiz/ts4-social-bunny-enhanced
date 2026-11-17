package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ZoneModifier extends OlympusObject
   {
      
      public static const MODIFIER_TYPE_TRAIT:int = 0;
      
      public static const MODIFIER_TYPE_CHALLENGE:int = 1;
      
      public var id:String;
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var name:LocKey = new LocKey();
      
      public var bLocked:Boolean;
      
      public var conflictingTraits:Array = [LocKey];
      
      public var conflictingChallenges:Array = [LocKey];
      
      public var modifierType:int;
      
      public var prohibitedVenues:Array = [String];
      
      public var allowedVenues:Array = [String];
      
      public function ZoneModifier(param1:Object = null)
      {
         super(param1);
      }
      
      public static function SortingFunction(param1:ZoneModifier, param2:ZoneModifier) : int
      {
         return param1.name.toString().localeCompare(param2.name.toString());
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.prohibitedVenues);
         FixupArray(this.allowedVenues);
         FixupArray(this.conflictingTraits);
         FixupArray(this.conflictingChallenges);
      }
      
      public function HasDisplayInfo() : Boolean
      {
         return this.id != "0";
      }
   }
}

