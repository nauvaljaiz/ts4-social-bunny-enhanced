package olympus.gamepad
{
   import olympus.input.IInputFocusable;
   
   public class InputFocusStack
   {
      
      private var mStack:Vector.<WidgetInputFocusable>;
      
      public function InputFocusStack()
      {
         super();
         this.mStack = new Vector.<WidgetInputFocusable>();
      }
      
      public function get Root() : WidgetInputFocusable
      {
         if(this.mStack.length > 0)
         {
            return this.mStack[0];
         }
         return null;
      }
      
      public function Peek() : WidgetInputFocusable
      {
         if(this.mStack.length > 0)
         {
            return this.mStack[this.mStack.length - 1];
         }
         return null;
      }
      
      public function Push(param1:WidgetInputFocusable) : void
      {
         this.mStack.push(param1);
      }
      
      public function Pop() : WidgetInputFocusable
      {
         if(this.mStack.length > 0)
         {
            return this.mStack.pop();
         }
         return null;
      }
      
      public function Clear() : void
      {
         this.mStack.length = 0;
      }
      
      public function toString() : String
      {
         return "[InputFocusStack elements={\n\t" + this.mStack.join(",\n\t") + " }]";
      }
      
      public function Contains(param1:IInputFocusable) : Boolean
      {
         var _loc2_:* = int(this.mStack.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.mStack[_loc2_].mFocusable == param1)
            {
               return true;
            }
            _loc2_--;
         }
         return false;
      }
      
      public function ContainsWidget(param1:String) : Boolean
      {
         var _loc2_:* = int(this.mStack.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.mStack[_loc2_].mWidgetName == param1)
            {
               return true;
            }
            _loc2_--;
         }
         return false;
      }
      
      public function GetFirstFocusableForWidget(param1:String) : IInputFocusable
      {
         var _loc3_:WidgetInputFocusable = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.mStack.length)
         {
            _loc3_ = this.mStack[_loc2_];
            if(_loc3_.mWidgetName == param1)
            {
               return _loc3_.mFocusable;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function Remove(param1:IInputFocusable) : Boolean
      {
         var _loc2_:int = -1;
         var _loc3_:* = int(this.mStack.length - 1);
         while(_loc3_ >= 0)
         {
            if(this.mStack[_loc3_].mFocusable == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_--;
         }
         if(_loc2_ != -1)
         {
            this.mStack.splice(_loc2_,1);
            return true;
         }
         return false;
      }
      
      public function RemoveWidget(param1:String) : Boolean
      {
         var _loc2_:int = -1;
         var _loc3_:* = int(this.mStack.length - 1);
         while(_loc3_ >= 0)
         {
            if(this.mStack[_loc3_].mWidgetName == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_--;
         }
         if(_loc2_ != -1)
         {
            this.mStack.splice(_loc2_,1);
            return true;
         }
         return false;
      }
   }
}

