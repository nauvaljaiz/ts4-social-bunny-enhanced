package olympus.objects
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SimSecretInfo extends OlympusObject
   {
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var name:LocKey = new LocKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public var blackmailed:Boolean;
      
      public var unconfronted:Boolean;
      
      public function SimSecretInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
         this.tooltip = FixupLocKey(this.tooltip);
      }
   }
}

