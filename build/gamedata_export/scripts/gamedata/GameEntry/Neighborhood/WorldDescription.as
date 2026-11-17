package gamedata.GameEntry.Neighborhood
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class WorldDescription extends OlympusObject
   {
      
      public var id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var regionId:String;
      
      public var icon:String;
      
      public var iconSelected:String;
      
      public var ecoFootprintCompatible:Boolean;
      
      public var ecoFootprintOnlyStreetTag:Boolean;
      
      public function WorldDescription(param1:Object = null)
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

