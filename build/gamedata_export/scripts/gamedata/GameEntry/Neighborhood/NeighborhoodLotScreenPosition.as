package gamedata.GameEntry.Neighborhood
{
   import flash.geom.Point;
   import olympus.core.OlympusObject;
   
   public class NeighborhoodLotScreenPosition extends OlympusObject
   {
      
      public var worldDescriptionId:String;
      
      public var layer:int;
      
      public var positions:Array = [Object];
      
      public var highestPosIndex:uint;
      
      public var scale:Number = 1;
      
      public var mPoints:Array;
      
      public function NeighborhoodLotScreenPosition(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc3_:Object = null;
         super.ParseObject(param1);
         this.mPoints = new Array();
         var _loc2_:Array = this.positions;
         for each(_loc3_ in _loc2_)
         {
            this.mPoints.push(new Point(_loc3_.x,_loc3_.y));
         }
      }
   }
}

