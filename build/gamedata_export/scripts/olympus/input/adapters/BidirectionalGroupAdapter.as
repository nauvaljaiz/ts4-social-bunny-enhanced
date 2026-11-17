package olympus.input.adapters
{
   import flash.display.DisplayObject;
   
   public class BidirectionalGroupAdapter extends AbstractBidirectionalInputAdapter
   {
      
      protected var mElements:Vector.<DisplayObject>;
      
      public function BidirectionalGroupAdapter(param1:Vector.<DisplayObject> = null, param2:Boolean = false)
      {
         super();
         this.SetElements(param1);
         mbHorizontal = param2;
      }
      
      public function SetElements(param1:Vector.<DisplayObject>) : void
      {
         this.mElements = param1;
         if(!this.mElements)
         {
            this.mElements = new Vector.<DisplayObject>();
         }
      }
      
      public function AddElement(param1:DisplayObject) : void
      {
         if(!this.mElements)
         {
            this.mElements = new Vector.<DisplayObject>();
         }
         this.mElements.push(param1);
      }
      
      public function ClearElements() : void
      {
         this.mElements.length = 0;
      }
      
      override protected function GetElementAt(param1:int) : DisplayObject
      {
         if(param1 < 0 || param1 >= this.mElements.length)
         {
            return null;
         }
         return this.mElements[param1];
      }
      
      override protected function GetFirstVisibleElementIndex() : int
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this.mElements.length)
         {
            if(this.mElements[_loc2_].visible)
            {
               _loc1_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function GetListLength() : int
      {
         return this.mElements.length;
      }
      
      public function Sort() : void
      {
         this.mElements.sort(this.SortFunction);
      }
      
      protected function SortFunction(param1:DisplayObject, param2:DisplayObject) : int
      {
         if(mbHorizontal)
         {
            return param1.x < param2.x ? -1 : 1;
         }
         return param1.y < param2.y ? -1 : 1;
      }
   }
}

