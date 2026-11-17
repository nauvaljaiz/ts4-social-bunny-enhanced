package olympus.events
{
   import flash.events.Event;
   import olympus.interfaces.IExtendable;
   
   public class SelectableGroupEvent extends Event
   {
      
      public static const SELECTION_CHANGED:String = "SelectableGroupEventSelectionChanged";
      
      public static const SELECTION_CLICKED:String = "SelectableGroupEventSelectionClicked";
      
      public var selectedIndex:int = -1;
      
      public var selectedComponent:IExtendable;
      
      public var deselectedIndex:int = -1;
      
      public var deselectedComponent:IExtendable;
      
      public function SelectableGroupEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function toString() : String
      {
         return formatToString("SelectableGroupEvent","type","index","button","bubbles","cancelable","selectedIndex","selectedComponent","deselectedIndex","deselectedComponent");
      }
      
      override public function clone() : Event
      {
         var _loc1_:SelectableGroupEvent = new SelectableGroupEvent(this.type,this.bubbles,this.cancelable);
         _loc1_.selectedIndex = this.selectedIndex;
         _loc1_.selectedComponent = this.selectedComponent;
         _loc1_.deselectedIndex = this.deselectedIndex;
         _loc1_.deselectedComponent = this.deselectedComponent;
         return _loc1_;
      }
   }
}

