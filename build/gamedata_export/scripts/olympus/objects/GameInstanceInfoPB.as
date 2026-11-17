package olympus.objects
{
   import olympus.core.OlympusObject;
   
   public class GameInstanceInfoPB extends OlympusObject
   {
      
      public var zone_id:String;
      
      public var world_id:uint;
      
      public var neighborhood_name:String;
      
      public var zone_name:String;
      
      public var zone_session_id:String;
      
      public function GameInstanceInfoPB(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.zone_id = param1.zone_id;
         this.world_id = param1.world_id;
         this.neighborhood_name = param1.neighborhood_name;
         this.zone_name = param1.zone_name;
         this.zone_session_id = param1.zone_session_id;
      }
   }
}

