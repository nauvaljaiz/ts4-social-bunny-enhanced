package gamedata.GameTray
{
   import olympus.core.OlympusObject;
   
   public class SetMoney extends OlympusObject
   {
      
      public static const REASON_UNDEFINED:int = 0;
      
      public static const REASON_INTERACTION_COST:int = 1;
      
      public static const REASON_INTERACTION_REWARD:int = 2;
      
      public static const REASON_EVENT_COST:int = 3;
      
      public static const REASON_EVENET_REWARD:int = 4;
      
      public static const REASON_OBJECT_BUY:int = 5;
      
      public static const REASON_OBJECT_SELL:int = 6;
      
      public static const REASON_STRUCTURE_BUY:int = 7;
      
      public static const REASON_STRUCTURE_SELL:int = 8;
      
      public static const REASON_CAS_BUY:int = 9;
      
      public static const REASON_BLUEPRINT_CONSTRUCTED:int = 10;
      
      public static const REASON_LOT_BUY:int = 11;
      
      public static const REASON_LOT_SELL:int = 12;
      
      public static const REASON_HOUSEHOLD_TRANSFER_GAIN:int = 13;
      
      public static const REASON_HOUSEHOLD_TRANSFER_LOSS:int = 14;
      
      public static const REASON_SIM_POINTS_EXCHANGED:int = 15;
      
      public static const REASON_SIM_WALLET_FUNDED:int = 16;
      
      public static const REASON_SIM_WALLET_EMPTIED:int = 17;
      
      public static const REASON_CRAFTING_COST:int = 18;
      
      public static const REASON_MONEY_CHEAT:int = 19;
      
      public static const REASON_MONEY_CAREER:int = 20;
      
      public static const REASON_MONEY_ASPIRATION_REWARD:int = 21;
      
      public static const REASON_SMALL_BUSINESS_EMPLOYEE:* = 41;
      
      public static const REASON_SMALLBUSINESS_OPEN_FREE_DAY:int = 100;
      
      public static const MULTI_FLYAWAY_REASONS:Array = [REASON_SMALL_BUSINESS_EMPLOYEE];
      
      public var currentSimoleons:uint;
      
      public var reason:int;
      
      public var multiFlyway:Boolean;
      
      public var vfx_amount:int;
      
      public function SetMoney(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.currentSimoleons = param1.currentSimoleons;
         this.reason = param1.reason;
         this.vfx_amount = param1["vfx_amount"];
         this.multiFlyway = MULTI_FLYAWAY_REASONS.indexOf(this.reason) >= 0;
      }
   }
}

