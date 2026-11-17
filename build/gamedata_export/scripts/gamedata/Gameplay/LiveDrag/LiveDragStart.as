package gamedata.Gameplay.LiveDrag
{
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public class LiveDragStart extends OlympusObject
   {
      
      public var live_drag_object_id:String;
      
      public var drag_start_system:uint;
      
      public var drop_object_ids:Array = [String];
      
      public var stack_id:String;
      
      public var sell_value:int;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public function LiveDragStart(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.drop_object_ids);
         if(!("icon_info" in param1) || !param1.icon_info)
         {
            this.icon_info = null;
         }
      }
   }
}

