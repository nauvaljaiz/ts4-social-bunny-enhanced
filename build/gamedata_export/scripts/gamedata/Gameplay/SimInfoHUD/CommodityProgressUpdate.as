package gamedata.Gameplay.SimInfoHUD
{
   import olympus.core.OlympusObject;
   
   public class CommodityProgressUpdate extends OlympusObject
   {
      
      public var commodity_id:String;
      
      public var current_value:Number;
      
      public var rate_of_change:Number;
      
      public var commodity_state_index:uint;
      
      public var is_rate_change:Boolean;
      
      public var elapsedSeconds:int = 0;
      
      public function CommodityProgressUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.commodity_id = param1.commodity_id;
         this.current_value = param1.current_value;
         this.rate_of_change = param1.rate_of_change;
         this.commodity_state_index = param1.commodity_state_index;
         this.is_rate_change = param1.is_rate_change;
         this.elapsedSeconds = Math.max(param1.elapsedSeconds,0);
      }
   }
}

