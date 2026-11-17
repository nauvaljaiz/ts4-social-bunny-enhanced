package gamedata.Gameplay.Business
{
   import gamedata.restaurant.CareerOutfit;
   import olympus.core.OlympusObject;
   
   public class VenueOutfitsGeneric extends OlympusObject
   {
      
      public var outfits:Array = [CareerOutfit];
      
      public function VenueOutfitsGeneric(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.outfits);
      }
   }
}

