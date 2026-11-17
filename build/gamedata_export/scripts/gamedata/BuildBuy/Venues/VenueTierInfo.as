package gamedata.BuildBuy.Venues
{
   import gamedata.shared.ResourceKey;
   import gamedata.shared.ZoneModifier;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class VenueTierInfo extends OlympusObject
   {
      
      public var nameKey:LocKey;
      
      public var nameTwoLinesKey:LocKey;
      
      public var icon:ResourceKey;
      
      public var venueObject:VenueObjectInfo;
      
      public var bannerKey:LocKey;
      
      public var bannerAppearanceState:int;
      
      public var zoneModifiers:Array;
      
      public function VenueTierInfo(param1:Object)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.nameKey = new LocKey(param1.nameKey);
         this.nameTwoLinesKey = new LocKey(param1.nameTwoLinesKey);
         this.icon = new ResourceKey(param1.icon);
         if("venueObject" in param1)
         {
            this.venueObject = new VenueObjectInfo(param1.venueObject);
         }
         if("bannerKey" in param1)
         {
            this.bannerKey = new LocKey(param1.bannerKey);
         }
         if("bannerAppearanceState" in param1)
         {
            this.bannerAppearanceState = param1.bannerAppearanceState;
         }
         if("zoneModifiers" in param1)
         {
            this.zoneModifiers = new Array();
            ConstructArrayFromArray(this.zoneModifiers,param1.zoneModifiers,ZoneModifier);
         }
      }
   }
}

