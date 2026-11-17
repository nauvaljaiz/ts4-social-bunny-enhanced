package gamedata.Gameplay.Business
{
   import olympus.core.OlympusObject;
   
   public class RestaurantBusinessData extends OlympusObject
   {
      
      public var net_profit:int;
      
      public var ingredient_chosen:uint;
      
      public var is_ingredient_unlocked:Boolean;
      
      public var advertising_chosen:uint;
      
      public function RestaurantBusinessData(param1:Object = null)
      {
         super(param1);
      }
   }
}

