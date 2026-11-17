package gamedata.BuildBuy.Venues
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class VenueFeatureInfo extends OlympusObject
   {
      
      public var nameKey:LocKey = new LocKey();
      
      public var descriptionKey:LocKey = new LocKey();
      
      public var iconKey:ResourceKey = new ResourceKey();
      
      public function VenueFeatureInfo(param1:Object)
      {
         super(param1);
      }
   }
}

