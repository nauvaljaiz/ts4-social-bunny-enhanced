package gamedata.FamilyTree
{
   import flash.geom.Point;
   import widgets.shared.controls.FamilyTree.FamilyTreeSimContainer;
   
   public class FamilyTreeGeneration
   {
      
      public var mSimGroups:Vector.<FamilyTreeSimGroup> = new Vector.<FamilyTreeSimGroup>();
      
      public var mContainerGroupWidth:Number = 0;
      
      public function FamilyTreeGeneration()
      {
         super();
      }
      
      public function GetConnectionPointsUp() : Vector.<Point>
      {
         return this.GetConnectionPoints(true);
      }
      
      public function GetConnectionPointsDown() : Vector.<Point>
      {
         return this.GetConnectionPoints(false);
      }
      
      protected function GetConnectionPoints(param1:Boolean) : Vector.<Point>
      {
         var _loc6_:FamilyTreeSimContainer = null;
         var _loc7_:Vector.<Point> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Point = null;
         var _loc2_:Vector.<Point> = new Vector.<Point>();
         var _loc3_:Vector.<FamilyTreeSimGroup> = this.mSimGroups;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_].mContainer;
            _loc7_ = param1 ? _loc6_.mConnectionPointsUp : _loc6_.mConnectionPointsDown;
            _loc8_ = int(_loc7_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc10_ = _loc7_[_loc9_];
               _loc2_.push(new Point(_loc6_.x + _loc10_.x,_loc6_.y + _loc10_.y));
               _loc9_++;
            }
            _loc5_++;
         }
         return _loc2_;
      }
   }
}

