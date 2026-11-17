package gamedata.Gameplay.Business
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class BuyBusinessDropdownData extends OlympusObject
   {
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var text:LocKey = new LocKey();
      
      public function BuyBusinessDropdownData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.text = FixupLocKey(this.text);
      }
   }
}

