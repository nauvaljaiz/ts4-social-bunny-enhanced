package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class WorldPickResult extends OlympusObject
   {
      
      public var viewPortX:int;
      
      public var viewPortY:int;
      
      public var pickType:int;
      
      public var worldPosX:Number = 0;
      
      public var worldPosY:Number = 0;
      
      public var worldPosZ:Number = 0;
      
      public var lotId:uint;
      
      public var level:int;
      
      public var objectId:String;
      
      public var sceneObjectIndex:uint;
      
      public var pickDirX:Number = 0;
      
      public var pickDirY:Number = 0;
      
      public var pickDirZ:Number = 0;
      
      public var bHasGoHere:Boolean;
      
      public var simFirstName:String;
      
      public var zoneId:String;
      
      public var plexId:uint;
      
      public var mObjectInventoryId:String;
      
      public function WorldPickResult(param1:Object = null)
      {
         super(param1);
      }
   }
}

