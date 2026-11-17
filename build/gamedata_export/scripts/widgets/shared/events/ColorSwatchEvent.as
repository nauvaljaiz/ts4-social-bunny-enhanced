package widgets.shared.events
{
   import flash.events.Event;
   import widgets.shared.data.ColorSwatchData;
   
   public class ColorSwatchEvent extends Event
   {
      
      public static const VARIATION_SELECTED:String = "variationSelected";
      
      public static const VARIATION_ROLL_OVER:String = "variationRollOver";
      
      public static const VARIATION_ROLL_OUT:String = "variationRollOut";
      
      public var swatchData:ColorSwatchData;
      
      public var stateIndex:int;
      
      public var bCloseSelector:Boolean = false;
      
      public var bShapeChanged:Boolean = false;
      
      public function ColorSwatchEvent(param1:String, param2:Boolean = true, param3:Boolean = false, param4:ColorSwatchData = null, param5:int = 0, param6:Boolean = false, param7:Boolean = false)
      {
         super(param1,param2,param3);
         this.swatchData = param4;
         this.stateIndex = param5;
         this.bCloseSelector = param6;
         this.bShapeChanged = param7;
      }
      
      public function get dataID() : String
      {
         return this.swatchData ? this.swatchData.dataID : null;
      }
      
      override public function clone() : Event
      {
         return new ColorSwatchEvent(type,bubbles,cancelable,this.swatchData,this.stateIndex,this.bCloseSelector,this.bShapeChanged);
      }
      
      override public function toString() : String
      {
         return formatToString("ColorSwatchEvent","type","bubbles","cancelable","swatchData","stateIndex");
      }
   }
}

