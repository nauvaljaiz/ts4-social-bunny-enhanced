package widgets.shared.data
{
   import olympus.core.OlympusObject;
   
   public class ColorSwatchDataArray extends OlympusObject
   {
      
      public var mItems:Array = [ColorSwatchData];
      
      public function ColorSwatchDataArray(param1:Object)
      {
         super(param1);
         FixupArray(this.mItems);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc3_:ColorSwatchData = null;
         super.ParseObject(param1);
         var _loc2_:* = 0;
         while(_loc2_ < this.mItems.length)
         {
            _loc3_ = this.mItems[_loc2_];
            if(_loc3_ == null)
            {
               this.mItems.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
   }
}

