package olympus.io
{
   import olympus.audio.Audio;
   import olympus.constants.GameStates;
   
   public class EventManager
   {
      
      public static var mEventStrings:Array = new Array();
      
      protected static var mCurrentGameState:uint = GameStates.UNKNOWN;
      
      protected static var mbAllowAudioEvents:Boolean = true;
      
      public function EventManager()
      {
         super();
      }
      
      public static function DispatchInteractionEvent(param1:String, param2:String, param3:String, param4:String, param5:String = null) : void
      {
         var _loc6_:Array = [param1,"Interactions",param4,param3,param2];
         if(param5)
         {
            _loc6_.push(param5);
         }
         mEventStrings.push(_loc6_.join("."));
      }
      
      public static function DispatchGameStateEvent(param1:String, param2:String, param3:String = null) : void
      {
         var _loc4_:Array = [param1,"GameStateMachine",param2];
         if(param3)
         {
            _loc4_.push(param3);
         }
         CheckForSpecialEvents(param1,param2,param3);
         mEventStrings.push(_loc4_.join("."));
      }
      
      public static function DispatchAnimationEvent(param1:String, param2:String, param3:String) : void
      {
         mEventStrings.push([param1,"Animation",param2,param3].join("."));
      }
      
      public static function AddRawEvent(... rest) : void
      {
         mEventStrings.push(rest.join("."));
      }
      
      public static function SwitchToGameState(param1:uint) : void
      {
         if(mCurrentGameState == param1)
         {
            return;
         }
         if(mbAllowAudioEvents)
         {
            if(mCurrentGameState != GameStates.UNKNOWN && !(mCurrentGameState == GameStates.TRAVEL && param1 == GameStates.LEAVEPLAYAREA))
            {
               DispatchGameStateEvent(Audio.GAMESTATE_LEAVE,GameStates.ConvertStateIdToName(mCurrentGameState));
            }
            if(param1 != GameStates.PLAY && param1 != GameStates.TRAVEL && param1 != GameStates.LOT_SELECT)
            {
               DispatchGameStateEvent(Audio.GAMESTATE_ENTER,GameStates.ConvertStateIdToName(param1));
            }
         }
         mCurrentGameState = param1;
      }
      
      protected static function CheckForSpecialEvents(param1:String, param2:String, param3:String) : void
      {
         if(param2 == "LoadingScreen")
         {
            if(param3 == Audio.GAMESTATE_SUBSTATE_CONSTRUCTION || param3 == Audio.GAMESTATE_SUBSTATE_BUILD_TO_NHD)
            {
               if(param1 == Audio.GAMESTATE_LEAVE)
               {
                  DispatchGameStateEvent(Audio.GAMESTATE_ENTER,GameStates.ConvertStateIdToName(mCurrentGameState));
                  mbAllowAudioEvents = true;
               }
               else
               {
                  mbAllowAudioEvents = false;
               }
            }
            if(mCurrentGameState == GameStates.TRAVEL && param3 == Audio.GAMESTATE_SUBSTATE_PLAYBATUU && param1 == Audio.GAMESTATE_ENTER)
            {
               DispatchGameStateEvent(Audio.GAMESTATE_LEAVE,GameStates.ConvertStateIdToName(GameStates.TRAVEL));
            }
         }
      }
   }
}

