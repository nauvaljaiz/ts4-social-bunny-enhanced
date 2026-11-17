package gamedata.Gameplay.shared
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class EcoFootprintStateInfo extends OlympusObject
   {
      
      public var HUDTooltipDescriptionText:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var nameText:LocKey = new LocKey();
      
      public var streetDescriptorTuning:EcoFootprintStreetDescriptorInfo = new EcoFootprintStreetDescriptorInfo();
      
      public var streetHighlightColor:uint;
      
      public var ecoFootprintState:uint;
      
      public function EcoFootprintStateInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.HUDTooltipDescriptionText = FixupLocKey(this.HUDTooltipDescriptionText);
         this.nameText = FixupLocKey(this.nameText);
      }
   }
}

