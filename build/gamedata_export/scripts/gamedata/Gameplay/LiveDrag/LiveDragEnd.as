package gamedata.Gameplay.LiveDrag
{
   import olympus.core.OlympusObject;
   
   public class LiveDragEnd extends OlympusObject
   {
      
      public var live_drag_object_id:String;
      
      public var drag_start_system:uint;
      
      public var drag_end_system:uint;
      
      public var next_drag_object_id:String;
      
      public function LiveDragEnd(param1:Object = null)
      {
         super(param1);
      }
   }
}

