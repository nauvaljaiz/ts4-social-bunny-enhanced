package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class SetBuckFunds extends OlympusObject
   {
      
      public static const BUCK_TYPE_NONE:uint = 0;
      
      public static const BUCK_TYPE_RETAIL_BUCKS:uint = 12289;
      
      public static const BUCK_TYPE_CLUB_BUCKS:uint = 64;
      
      public static const BUCK_TYPE_RESTAURANT_BUCKS:uint = 65;
      
      public static const BUCK_TYPE_VAMPIRE_POWER_BUCKS:uint = 40961;
      
      public static const BUCK_TYPE_VAMPIRE_WEAKNESS_BUCKS:uint = 40962;
      
      public static const BUCK_TYPE_VET_BUCKS:uint = 57345;
      
      public static const BUCK_TYPE_FAME_PERK_BUCKS:uint = 61441;
      
      public static const BUCK_TYPE_FAME_QUIRK_BUCKS:uint = 61442;
      
      public static const BUCK_TYPE_WITCH_PERK_BUCKS:uint = 49153;
      
      public static const BUCK_TYPE_RECYCLE_BITS_BUCKS:uint = 67585;
      
      public static const BUCK_TYPE_RECYCLE_PIECES_BUCKS:uint = 67586;
      
      public static const BUCK_TYPE_GALACTIC_CREDITS_BUCKS:uint = 51201;
      
      public static const BUCK_TYPE_INFLUENCE_BUCKS:uint = 67587;
      
      public static const BUCK_TYPE_GHOST_POWERS_BUCKS:uint = 124929;
      
      public static const BUCK_TYPE_SMALL_BUSINESS_BUCKS:uint = 126977;
      
      public static const BUCK_TYPE_NOBILITY_BUCKS:uint = 294914;
      
      public static const BUCK_TYPE_DYNASTY_BUCKS:uint = 294913;
      
      public static const BUCK_TYPE_BUSINESS_BUCKS:uint = 1;
      
      public var bucks_type:uint;
      
      public var available_funds:uint;
      
      public var change:int;
      
      public var club_id:String;
      
      public var sim_id:String;
      
      public function SetBuckFunds(param1:Object = null)
      {
         super(param1);
      }
      
      public static function IsBusinessBuckType(param1:uint) : Boolean
      {
         switch(param1)
         {
            case BUCK_TYPE_RETAIL_BUCKS:
            case BUCK_TYPE_VET_BUCKS:
            case BUCK_TYPE_RESTAURANT_BUCKS:
               return true;
            default:
               return false;
         }
      }
      
      public static function RemapBuckType(param1:uint) : uint
      {
         switch(param1)
         {
            case BUCK_TYPE_RETAIL_BUCKS:
            case BUCK_TYPE_VET_BUCKS:
            case BUCK_TYPE_RESTAURANT_BUCKS:
               return BUCK_TYPE_BUSINESS_BUCKS;
            default:
               return param1;
         }
      }
   }
}

