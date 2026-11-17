package widgets.shared.controls.FamilyTree
{
   import flash.events.Event;
   import flash.geom.Point;
   import olympus.views.CellView;
   
   public class FamilyTreeSimContainer extends CellView
   {
      
      public var mConnectionPointsUp:Vector.<Point>;
      
      public var mConnectionPointsDown:Vector.<Point>;
      
      protected var mSimsLoaded:uint = 0;
      
      public function FamilyTreeSimContainer()
      {
         super();
      }
      
      override public function Draw(param1:Object, param2:Object = null) : void
      {
         this.mConnectionPointsUp = new Vector.<Point>();
         this.mConnectionPointsDown = new Vector.<Point>();
         this.mSimsLoaded = 0;
      }
      
      protected function OnSimIconLoadComplete(param1:Event) : void
      {
         dispatchEvent(new FamilyTreeEvent(FamilyTreeEvent.SIMS_LOADED));
      }
   }
}

