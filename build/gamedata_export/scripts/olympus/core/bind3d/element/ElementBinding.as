package olympus.core.bind3d.element
{
   import flash.geom.Vector3D;
   import olympus.core.widget.Margin;
   
   public class ElementBinding
   {
      
      public var elementName:String;
      
      public var printElementName:String;
      
      public var worldOffset:Vector3D = new Vector3D();
      
      public var viewOffset:Vector3D = new Vector3D();
      
      public var screenOffset:Vector3D = new Vector3D();
      
      public var boneName:String;
      
      public var displayPriority:Number = 0;
      
      public var isOccludedByWorld:Boolean;
      
      public var isScaledByCamera:Boolean;
      
      public var minScale:Number = 0.1;
      
      public var maxVisibleScale:Number = 0;
      
      public var lockVisibility:Boolean;
      
      public var lockToScreenEdge:Boolean = false;
      
      public var lockToScreenEdgeScale:Margin = new Margin(1);
      
      public var adjustScreenPositionForMargin:Boolean = false;
      
      public function ElementBinding(param1:String)
      {
         super();
         this.elementName = param1;
         this.printElementName = param1.substring(param1.lastIndexOf(".") + 1,param1.length);
      }
      
      public static function Element(param1:String) : ElementBinding
      {
         return new ElementBinding(param1);
      }
      
      public function equals(param1:ElementBinding) : Boolean
      {
         return this.elementName == param1.elementName && this.worldOffset.equals(param1.worldOffset) && this.viewOffset.equals(param1.viewOffset) && this.screenOffset.equals(param1.screenOffset) && this.boneName == param1.boneName && this.isOccludedByWorld == param1.isOccludedByWorld && this.isScaledByCamera == param1.isScaledByCamera && this.minScale == param1.minScale && this.lockVisibility == param1.lockVisibility && this.lockToScreenEdge == param1.lockToScreenEdge && this.lockToScreenEdgeScale.mBot == param1.lockToScreenEdgeScale.mBot && this.lockToScreenEdgeScale.mTop == param1.lockToScreenEdgeScale.mTop && this.lockToScreenEdgeScale.mRight == param1.lockToScreenEdgeScale.mRight && this.lockToScreenEdgeScale.mLeft == param1.lockToScreenEdgeScale.mLeft && this.adjustScreenPositionForMargin == param1.adjustScreenPositionForMargin;
      }
      
      public function AttachBone(param1:String) : ElementBinding
      {
         this.boneName = param1;
         return this;
      }
      
      public function WorldOffset(param1:Number, param2:Number, param3:Number) : ElementBinding
      {
         this.worldOffset.x = param1;
         this.worldOffset.y = param2;
         this.worldOffset.z = param3;
         return this;
      }
      
      public function ViewOffset(param1:Number, param2:Number, param3:Number) : ElementBinding
      {
         this.viewOffset.x = param1;
         this.viewOffset.y = param2;
         this.viewOffset.z = param3;
         return this;
      }
      
      public function ScreenOffset(param1:Number, param2:Number, param3:Number = 0) : ElementBinding
      {
         this.screenOffset.x = param1;
         this.screenOffset.y = param2;
         this.screenOffset.z = param3;
         return this;
      }
      
      public function DisplayPriority(param1:Number) : ElementBinding
      {
         this.displayPriority = param1;
         return this;
      }
      
      public function OccludedByWorld(param1:Boolean) : ElementBinding
      {
         this.isOccludedByWorld = param1;
         return this;
      }
      
      public function ScaledByCamera(param1:Boolean) : ElementBinding
      {
         this.isScaledByCamera = param1;
         return this;
      }
      
      public function MinScale(param1:Number) : ElementBinding
      {
         this.minScale = param1;
         return this;
      }
      
      public function MaxVisibleScale(param1:Number) : ElementBinding
      {
         this.maxVisibleScale = param1;
         return this;
      }
      
      public function LockVisibility(param1:Boolean) : ElementBinding
      {
         this.lockVisibility = param1;
         return this;
      }
      
      public function LockToScreenEdge(param1:Boolean) : ElementBinding
      {
         this.lockToScreenEdge = param1;
         return this;
      }
      
      public function LockToScreenEdgeScale(param1:Number, param2:Number, param3:Number, param4:Number) : ElementBinding
      {
         this.lockToScreenEdgeScale = Margin.TopRightBottomLeft(param1,param2,param3,param4);
         return this;
      }
      
      public function AdjustScreenPositionForMargin(param1:Boolean) : ElementBinding
      {
         this.adjustScreenPositionForMargin = param1;
         return this;
      }
   }
}

