package gamedata.GameEntry.Neighborhood
{
   import olympus.core.OlympusObject;
   
   public class StreetInfoData extends OlympusObject
   {
      
      public var worldId:String;
      
      public var worldDescriptionId:String;
      
      public var mapOverlays:Array = [uint];
      
      public var ecoFootprintState:uint;
      
      public var normalizedEcoFootprintStateProgress:Number;
      
      public var ecoFootprintDelta:Number;
      
      public function StreetInfoData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.mapOverlays);
      }
   }
}

