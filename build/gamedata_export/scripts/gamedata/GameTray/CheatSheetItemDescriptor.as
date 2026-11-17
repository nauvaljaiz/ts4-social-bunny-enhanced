package gamedata.GameTray
{
   public class CheatSheetItemDescriptor
   {
      
      public static var CHEAT_SHEET_MODE_IN_LIVE_MODE:int = 0;
      
      public static var CHEAT_SHEET_MODE_IN_BB_MODE:int = 1;
      
      public static var CHEAT_SHEET_MODE_TS3_CAMERA_ACTIVE:int = 2;
      
      public static var CHEAT_SHEET_MODE_TS4_CAMERA_ACTIVE:int = 3;
      
      public var elementList:Vector.<CheatSheetElementDescriptor>;
      
      public var description:String;
      
      public var activeModesSet:Vector.<int>;
      
      public function CheatSheetItemDescriptor()
      {
         super();
         this.elementList = new Vector.<CheatSheetElementDescriptor>(0);
         this.activeModesSet = new Vector.<int>(0);
      }
   }
}

