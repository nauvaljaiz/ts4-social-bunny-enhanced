package olympus.core.widget
{
   public class LayerProps
   {
      
      protected var mLayer:int;
      
      protected var mbIsModal:Boolean;
      
      protected var mbSuppressModalitySprite:Boolean;
      
      public function LayerProps(param1:int, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this.mLayer = param1;
         this.mbIsModal = param2;
         this.mbSuppressModalitySprite = param3;
      }
      
      public function get Layer() : int
      {
         return this.mLayer;
      }
      
      public function get IsModal() : Boolean
      {
         return this.mbIsModal;
      }
      
      public function get SuppressModalitySprite() : Boolean
      {
         return this.mbSuppressModalitySprite;
      }
   }
}

