package olympus.tests
{
   import olympus.constants.GameStates;
   import olympus.core.Ticker;
   import olympus.core.UIManager;
   import olympus.events.TickerEvent;
   import olympus.io.CommunicationManager;
   import olympus.io.DebugCommands;
   import olympus.utils.DebugUtils;
   
   public class TestsManager
   {
      
      protected static var instance:TestsManager;
      
      protected static const MINIMUM_TEST_LENGTH:int = 10000;
      
      protected static const DEFAULT_TEST_LENGTH:int = 30000;
      
      protected var mCommunicationMgr:CommunicationManager;
      
      protected var mUIMgr:UIManager;
      
      protected var mBeforeTestGameState:uint = 0;
      
      protected var mTestGameState:uint = 0;
      
      protected var mTestLength:uint;
      
      protected var mbTestRunning:Boolean = false;
      
      public function TestsManager(param1:UIManager, param2:CommunicationManager)
      {
         super();
         instance = this;
         this.mCommunicationMgr = param2;
         this.mUIMgr = param1;
         DebugCommands.Register("ui.tests.run_game_state",this.DebugCommandTestGameState,"[gameState] [testLength]","Starts the local tests for a given game state.");
         DebugCommands.Register("ui.tests.stop",this.DebugCommandStopTests,"","Stops the current running ui test.");
         this.mCommunicationMgr.AddMessageListener("GameStateChanged",this.HandleGameStateChanged,"TestsManager");
      }
      
      protected function HandleGameStateChanged(param1:uint) : void
      {
         if(!this.mbTestRunning)
         {
            this.mBeforeTestGameState = param1;
         }
      }
      
      protected function DebugCommandStopTests(param1:Array, param2:Object, param3:String) : void
      {
         if(this.mbTestRunning)
         {
            Ticker.Remove(this);
            this.SwitchBackToOldGameState(new TickerEvent(TickerEvent.TICK,0));
         }
      }
      
      protected function DebugCommandTestGameState(param1:Array, param2:Object, param3:String) : void
      {
         var _loc5_:uint = 0;
         if(param1.length == 0)
         {
            DebugCommands.Output(param3,"You must input a game state to test.");
            return;
         }
         var _loc4_:uint = GameStates.ConvertStateNameToId(param1[0]);
         if(_loc4_ == GameStates.UNKNOWN)
         {
            DebugCommands.Output(param3,"Invalid game state.");
            return;
         }
         if(param1.length > 1)
         {
            _loc5_ = param1[1] * 1000;
            if(_loc5_ < MINIMUM_TEST_LENGTH)
            {
               DebugCommands.Output(param3,"Test length must be greater than " + MINIMUM_TEST_LENGTH / 1000 + " seconds.");
               return;
            }
            this.mTestLength = _loc5_;
         }
         else
         {
            this.mTestLength = DEFAULT_TEST_LENGTH;
         }
         this.mCommunicationMgr.ExternalCallbacks = false;
         this.mbTestRunning = true;
         this.mCommunicationMgr.CallUIService("UnloadAllWidgets",null);
         this.mUIMgr.mGameState = GameStates.UNKNOWN;
         this.mTestGameState = _loc4_;
         DebugUtils.SetGameClientDriven(false);
         Ticker.Add(this,1000,this.SetTestGameState);
      }
      
      protected function SetTestGameState(param1:TickerEvent) : void
      {
         this.mCommunicationMgr.CallUIService("SetGameState",this.mTestGameState);
         Ticker.Add(this,this.mTestLength,this.SwitchBackToOldGameState);
      }
      
      protected function SwitchBackToOldGameState(param1:TickerEvent) : void
      {
         this.mCommunicationMgr.ExternalCallbacks = true;
         this.mCommunicationMgr.CallUIService("UnloadAllWidgets",null);
         this.mUIMgr.mGameState = GameStates.UNKNOWN;
         DebugUtils.SetGameClientDriven(true);
         Ticker.Add(this,1000,this.SetBackToOriginalGameState);
      }
      
      protected function SetBackToOriginalGameState(param1:TickerEvent) : void
      {
         this.mbTestRunning = false;
         this.mCommunicationMgr.CallUIService("SetGameState",this.mBeforeTestGameState);
      }
   }
}

