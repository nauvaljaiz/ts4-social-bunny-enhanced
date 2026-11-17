package gamedata.Gameplay.Buffs.definitions
{
   import olympus.core.OlympusObject;
   
   public class BuffMotiveOverlay extends OlympusObject
   {
      
      public static const BUFF_MOTIVE_OVERLAY_INVALID:int = 0;
      
      public static const BUFF_MOTIVE_OVERLAY_POWER_WARNING:int = 1;
      
      public static const BUFF_MOTIVE_OVERLAY_IMPACTING_MOTIVE:int = 2;
      
      public var overlay_type:int;
      
      public var commodity_guid:String;
      
      public function BuffMotiveOverlay(param1:Object = null)
      {
         super(param1);
      }
   }
}

