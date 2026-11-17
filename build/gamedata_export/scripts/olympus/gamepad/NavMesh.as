package olympus.gamepad
{
   public class NavMesh
   {
      
      protected var mNodeMap:Object;
      
      public function NavMesh()
      {
         super();
         this.mNodeMap = {};
      }
      
      protected function CreateNodes(param1:Vector.<String>) : Vector.<NavMeshNode>
      {
         var _loc2_:Vector.<NavMeshNode> = new Vector.<NavMeshNode>();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[_loc3_] = new NavMeshNode(param1[_loc3_]);
            this.AddNodeMapping(_loc2_[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function AddNodeMapping(param1:NavMeshNode) : void
      {
         this.mNodeMap[param1.mName] = param1;
      }
      
      protected function AddNodeMappings(param1:Vector.<NavMeshNode>) : void
      {
         var _loc2_:NavMeshNode = null;
         for each(_loc2_ in param1)
         {
            this.AddNodeMapping(_loc2_);
         }
      }
      
      public function GetNode(param1:String) : NavMeshNode
      {
         return this.mNodeMap[param1] as NavMeshNode;
      }
   }
}

