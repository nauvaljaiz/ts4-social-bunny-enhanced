package gamedata.Gameplay.Business
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class RentalUnitRegionData extends OlympusObject
   {
      
      public var id:String;
      
      public var name:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var lots:Array = [RentalUnitLotData];
      
      public function RentalUnitRegionData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.lots);
         this.name = FixupLocKey(this.name);
      }
   }
}

