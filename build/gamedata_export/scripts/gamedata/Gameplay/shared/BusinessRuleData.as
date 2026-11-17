package gamedata.Gameplay.shared
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BusinessRuleData extends OlympusObject
   {
      
      public static const BUSINESS_RULE_STATE_DISABLED:int = 0;
      
      public static const BUSINESS_RULE_STATE_ENABLED:int = 1;
      
      public static const BUSINESS_RULE_STATE_BROKEN:int = 2;
      
      public var id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var fine:int;
      
      public var state:int;
      
      public function BusinessRuleData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
         this.description = FixupLocKey(this.description);
      }
   }
}

