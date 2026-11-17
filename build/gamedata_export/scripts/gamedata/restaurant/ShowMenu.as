package gamedata.restaurant
{
   import olympus.core.OlympusObject;
   
   public class ShowMenu extends OlympusObject
   {
      
      public static const ORDER_MODE:int = 0;
      
      public static const EDIT_MODE:int = 1;
      
      public static const VIEW_MODE:int = 2;
      
      public var menu:Menu = new Menu();
      
      public var sim_orders:Array = [SimOrder];
      
      public var sim_ids:Array = [String];
      
      public var chef_order:Boolean;
      
      public var running_bill_total:uint;
      
      public var recommend_order:Boolean;
      
      protected var mMode:int = 0;
      
      public function ShowMenu(param1:Object = null)
      {
         super(param1);
         FixupArray(this.sim_orders);
         FixupArray(this.sim_ids);
      }
      
      public function set Mode(param1:int) : void
      {
         this.mMode = param1;
      }
      
      public function get Mode() : int
      {
         return this.mMode;
      }
   }
}

