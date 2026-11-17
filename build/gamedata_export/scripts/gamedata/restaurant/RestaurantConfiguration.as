package gamedata.restaurant
{
   import gamedata.Gameplay.Business.VenueOutfitsGeneric;
   import olympus.core.OlympusObject;
   
   public class RestaurantConfiguration extends OlympusObject
   {
      
      public static const RESTAURANT_OUTFIT_MALE_CHEF:int = 0;
      
      public static const RESTAURANT_OUTFIT_FEMALE_CHEF:int = 1;
      
      public static const RESTAURANT_OUTFIT_MALE_WAITER:int = 2;
      
      public static const RESTAURANT_OUTFIT_FEMALE_WAITER:int = 3;
      
      public static const RESTAURANT_OUTFIT_MALE_HOST:int = 4;
      
      public static const RESTAURANT_OUTFIT_FEMALE_HOST:int = 5;
      
      public var attire_id:uint;
      
      public var preset_id:int;
      
      public var custom_menu:Menu = new Menu();
      
      public var venueOutfits:VenueOutfitsGeneric;
      
      public function RestaurantConfiguration(param1:Object = null)
      {
         super(param1);
         if(!param1)
         {
            this.venueOutfits = new VenueOutfitsGeneric();
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.venueOutfits = new VenueOutfitsGeneric();
         this.venueOutfits.ParseObject(param1);
      }
   }
}

