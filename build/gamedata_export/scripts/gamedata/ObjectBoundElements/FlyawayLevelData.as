package gamedata.ObjectBoundElements
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class FlyawayLevelData extends OlympusObject
   {
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var minimum_value:Number;
      
      public var maximum_value:Number;
      
      public var fx:int;
      
      public var color:uint;
      
      public function FlyawayLevelData(param1:Object = null)
      {
         super(param1);
      }
   }
}

