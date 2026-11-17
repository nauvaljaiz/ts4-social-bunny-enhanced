package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SetAtWorkInfo extends OlympusObject
   {
      
      public static const WORKDAY_OVER:int = 0;
      
      public static const WORKDAY_AVAILABLE:int = 1;
      
      public static const WORKDAY_ATTENDING:int = 2;
      
      public static const WORKDAY_LATE:int = 3;
      
      public static const WORKDAY_TIME_OFF:int = 4;
      
      public static const WORKDAY_ASSIGNMENT:int = 5;
      
      public static const WORKDAY_ASSIGNMENT_LATE:int = 6;
      
      protected static const WORKSTATE_PRIORITY_LIST:Array = [WORKDAY_LATE,WORKDAY_ATTENDING,WORKDAY_AVAILABLE,WORKDAY_TIME_OFF,WORKDAY_OVER];
      
      public var sim_id:String;
      
      public var career_uid:String;
      
      public var attended_work:Boolean;
      
      public var left_work:Boolean;
      
      public var work_state:int;
      
      public var panel_string:LocKey = new LocKey();
      
      public var tooltip_string:LocKey = new LocKey();
      
      public var end_time_override:uint;
      
      public var enable_go_to_work:Boolean;
      
      public var enable_go_to_work_early:Boolean;
      
      public function SetAtWorkInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public static function HigherPriorityWorkState(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:int = WORKSTATE_PRIORITY_LIST.indexOf(param1);
         var _loc4_:int = WORKSTATE_PRIORITY_LIST.indexOf(param2);
         if(_loc4_ == -1)
         {
            return true;
         }
         if(_loc3_ == -1)
         {
            return false;
         }
         return _loc3_ < _loc4_;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.panel_string.IsValid())
         {
            this.panel_string = null;
         }
         if(!this.tooltip_string.IsValid())
         {
            this.tooltip_string = null;
         }
      }
   }
}

