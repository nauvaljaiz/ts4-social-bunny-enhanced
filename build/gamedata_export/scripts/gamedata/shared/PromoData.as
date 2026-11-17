package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class PromoData extends OlympusObject
   {
      
      public var title:LocKey = new LocKey();
      
      public var text:LocKey = new LocKey();
      
      public var legalText:LocKey = new LocKey();
      
      public var image:ResourceKey = new ResourceKey();
      
      public function PromoData(param1:Object = null)
      {
         super(param1);
      }
   }
}

