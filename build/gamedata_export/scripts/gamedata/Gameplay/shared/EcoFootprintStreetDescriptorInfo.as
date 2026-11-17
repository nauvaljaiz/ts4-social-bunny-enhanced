package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class EcoFootprintStreetDescriptorInfo extends OlympusObject
   {
      
      public var backgroundColor:uint;
      
      public var descriptionText:LocKey = new LocKey();
      
      public var descriptionTextColor:uint;
      
      public var nameTextColor:uint;
      
      public function EcoFootprintStreetDescriptorInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.descriptionText = FixupLocKey(this.descriptionText);
      }
   }
}

