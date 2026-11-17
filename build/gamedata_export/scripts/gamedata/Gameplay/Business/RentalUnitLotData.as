package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class RentalUnitLotData extends OlympusObject
   {
      
      public var id:String;
      
      public var lotName:String;
      
      public var name:LocKey = new LocKey();
      
      public var units:Array = [RentalUnitData];
      
      public function RentalUnitLotData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.units);
         this.name = FixupLocKey(this.name);
      }
   }
}

