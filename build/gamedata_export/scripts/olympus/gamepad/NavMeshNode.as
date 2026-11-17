package olympus.gamepad
{
   import olympus.math.Geometry;
   
   public class NavMeshNode
   {
      
      public var mName:String;
      
      public var mConnections:Array;
      
      public function NavMeshNode(param1:String)
      {
         super();
         this.mName = param1;
         this.mConnections = new Array();
      }
      
      public function AddConnection(param1:NavMeshNode, param2:uint) : void
      {
         this.AddAngleConnection(param1,Geometry.DirectionToAngle(param2));
      }
      
      public function AddAngleConnection(param1:NavMeshNode, param2:Number) : void
      {
         this.mConnections.push({
            "node":param1,
            "angle":param2,
            "isDynamic":false
         });
      }
      
      public function AddDynamicConnection(param1:NavMeshNode) : void
      {
         this.mConnections.push({
            "node":param1,
            "angle":0,
            "isDynamic":true
         });
      }
      
      public function GetConnections() : Array
      {
         return this.mConnections;
      }
      
      public function AddHorizontalPairing(param1:NavMeshNode) : void
      {
         this.AddAngleConnection(param1,0);
         param1.AddAngleConnection(this,Math.PI);
      }
      
      public function AddVerticalPairing(param1:NavMeshNode) : void
      {
         this.AddAngleConnection(param1,Geometry.HALF_PI);
         param1.AddAngleConnection(this,Geometry.HALF_PI * 3);
      }
      
      public function AddAnglePairing(param1:NavMeshNode, param2:Number) : void
      {
         this.AddAngleConnection(param1,param2);
         param1.AddAngleConnection(this,Geometry.TWO_PI - param2);
      }
      
      public function AddDynamicPairing(param1:NavMeshNode) : void
      {
         this.AddDynamicConnection(param1);
         param1.AddDynamicConnection(this);
      }
      
      public function toString() : String
      {
         return "[NavMeshNode " + this.mName + "]";
      }
   }
}

