package olympus.input.adapters
{
   import flash.display.DisplayObject;
   import olympus.controllers.SelectableGroup;
   import olympus.layout.GridLayout;
   
   public class InputAdapterFactory
   {
      
      public function InputAdapterFactory()
      {
         super();
      }
      
      public static function FromGridLayout(param1:GridLayout) : GridInputAdapter
      {
         return new GridInputAdapter(param1);
      }
      
      public static function BidirectionalFromSelectableGroup(param1:SelectableGroup) : BidirectionalGroupAdapter
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:BidirectionalGroupAdapter = new BidirectionalGroupAdapter();
         var _loc4_:int = 0;
         while(_loc4_ < param1.Length)
         {
            _loc3_ = param1.GetElementAt(_loc4_) as DisplayObject;
            if(_loc3_)
            {
               _loc2_.AddElement(_loc3_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function OmnidirectionalFromSelectableGroup(param1:SelectableGroup) : OmnidirectionalGroupAdapter
      {
         var _loc4_:DisplayObject = null;
         var _loc2_:OmnidirectionalGroupAdapter = new OmnidirectionalGroupAdapter();
         var _loc3_:int = 0;
         while(_loc3_ < param1.Length)
         {
            _loc4_ = param1.GetElementAt(_loc3_) as DisplayObject;
            if(_loc4_)
            {
               _loc2_.AddElement(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function BidirectionalFromGridLayout(param1:GridLayout) : BidirectionalGroupAdapter
      {
         var _loc5_:DisplayObject = null;
         var _loc2_:BidirectionalGroupAdapter = new BidirectionalGroupAdapter();
         var _loc3_:* = param1.GetNumItems();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.GetViewAtIndex(_loc4_) as DisplayObject;
            if(_loc5_)
            {
               _loc2_.AddElement(_loc5_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
   }
}

