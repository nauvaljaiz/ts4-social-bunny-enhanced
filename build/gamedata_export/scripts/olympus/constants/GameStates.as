package olympus.constants
{
   public class GameStates
   {
      
      public static const UNKNOWN:uint = 0;
      
      public static const GAMEBOOTUP:uint = 2609681344;
      
      public static const PLAY:uint = 270579719;
      
      public static const CAS:uint = 983016380;
      
      public static const LIVEEDIT:uint = 4261769099;
      
      public static const BUILD:uint = 2919482169;
      
      public static const TRAVEL:uint = 238138433;
      
      public static const ENTER_LOT_SELECT:uint = 3894771298;
      
      public static const LOT_SELECT:uint = 3640749201;
      
      public static const MAIN_MENU:uint = 1273744144;
      
      public static const LEAVEPLAYAREA:uint = 500463879;
      
      public static const STARTUP:uint = 2530218128;
      
      public static const ENTER_MAIN_MENU:uint = 3712041429;
      
      public static const PHOTOGRAPHY:uint = 2145370932;
      
      public static const FIRST_LAUNCH:uint = 3337942812;
      
      public static const LEGAL_AGREEMENTS:uint = 716022987;
      
      public static const stateNames:Array = ["unknown","play","cas","liveedit","build","travel","lotselect","mainmenu","leaveplayarea","startup","entermainmenu","photography","firstlaunch","legalagreements","enterlotselect"];
      
      public static const stateIds:Array = [UNKNOWN,PLAY,CAS,LIVEEDIT,BUILD,TRAVEL,LOT_SELECT,MAIN_MENU,LEAVEPLAYAREA,STARTUP,ENTER_MAIN_MENU,PHOTOGRAPHY,FIRST_LAUNCH,LEGAL_AGREEMENTS,ENTER_LOT_SELECT];
      
      public function GameStates()
      {
         super();
      }
      
      public static function ConvertStateNameToId(param1:String) : uint
      {
         var _loc2_:int = stateNames.indexOf(param1);
         if(_loc2_ != -1)
         {
            return stateIds[_loc2_];
         }
         return GameStates.UNKNOWN;
      }
      
      public static function ConvertStateIdToName(param1:uint) : String
      {
         var _loc2_:int = stateIds.indexOf(param1);
         if(_loc2_ != -1)
         {
            return stateNames[_loc2_];
         }
         return "";
      }
      
      public static function ConvertGameToUIState(param1:uint) : uint
      {
         switch(param1)
         {
            case GameStates.PLAY:
            case GameStates.CAS:
            case GameStates.LIVEEDIT:
            case GameStates.BUILD:
            case GameStates.TRAVEL:
            case GameStates.LOT_SELECT:
            case GameStates.MAIN_MENU:
            case GameStates.LEAVEPLAYAREA:
            case GameStates.STARTUP:
            case GameStates.ENTER_MAIN_MENU:
            case GameStates.PHOTOGRAPHY:
            case GameStates.FIRST_LAUNCH:
            case GameStates.LEGAL_AGREEMENTS:
            case GameStates.ENTER_LOT_SELECT:
               return param1;
            default:
               return GameStates.UNKNOWN;
         }
      }
   }
}

