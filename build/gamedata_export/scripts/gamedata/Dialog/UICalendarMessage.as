package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class UICalendarMessage extends OlympusObject
   {
      
      public var event_type:uint;
      
      public var calendar_icon:IconInfo = new IconInfo();
      
      public var start_time:String;
      
      public var zone_id:String;
      
      public var description:LocKey = new LocKey();
      
      public var sim_ids:Array = [String];
      
      public var tradition_ids:Array = [String];
      
      public var show_go_to_button:Boolean;
      
      public var drama_node_guid:String;
      
      public var minutes_until_event:int;
      
      public var first_time:Boolean = true;
      
      public function UICalendarMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.sim_ids);
         FixupArray(this.tradition_ids);
      }
   }
}

