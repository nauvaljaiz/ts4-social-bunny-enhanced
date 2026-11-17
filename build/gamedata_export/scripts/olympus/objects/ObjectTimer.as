package olympus.objects
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ObjectTimer extends OlympusObject
   {
      
      public var time:Number;
      
      public var text:LocKey = new LocKey();
      
      public var object_name:LocKey = new LocKey();
      
      public var finished_text:LocKey = new LocKey();
      
      public var must_update_timer:Boolean = true;
      
      public var last_updated_time:Number;
      
      public var timer_header:LocKey = null;
      
      public var remaining_time:* = 0;
      
      public function ObjectTimer(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         this.last_updated_time = param1.last_updated_time;
         this.time = param1.time;
         this.text = new LocKey(param1.text);
         this.object_name = "object_name" in param1 ? new LocKey(param1.object_name) : null;
         this.finished_text = new LocKey(param1.finished_text);
         this.must_update_timer = param1.must_update_timer;
         if(param1.timer_header != null)
         {
            this.timer_header = new LocKey(param1.timer_header);
         }
      }
   }
}

