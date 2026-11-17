package gamedata.Gameplay.shared
{
   import gamedata.shared.GameClockTime;
   import olympus.core.OlympusObject;
   
   public class RetailData extends OlympusObject
   {
      
      public var retailFunds:int;
      
      public var itemsSold:uint;
      
      public var outgoingCosts:uint;
      
      public var netProfit:int;
      
      public var isOpen:Boolean;
      
      public var timeOpened:GameClockTime = new GameClockTime();
      
      public var currentGameTime:GameClockTime = new GameClockTime();
      
      public function RetailData(param1:Object = null)
      {
         super(param1);
         if(!param1 || !("timeOpened" in param1))
         {
            this.timeOpened = null;
         }
         if(!param1 || !("currentGameTime" in param1))
         {
            this.currentGameTime = null;
         }
      }
   }
}

