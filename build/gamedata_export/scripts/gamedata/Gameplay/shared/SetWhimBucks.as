package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class SetWhimBucks extends OlympusObject
   {
      
      public static const LOAD:int = 0;
      
      public static const ASPIRATION:int = 1;
      
      public static const WHIM:int = 2;
      
      public static const COMMAND:int = 3;
      
      public static const PURCHASED_REWARD:int = 4;
      
      public var whim_bucks:String;
      
      public var reason:int;
      
      public var change:int;
      
      public function SetWhimBucks(param1:Object = null)
      {
         super(param1);
      }
   }
}

