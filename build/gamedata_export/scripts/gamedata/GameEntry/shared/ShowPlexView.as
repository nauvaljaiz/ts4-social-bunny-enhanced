package gamedata.GameEntry.shared
{
   import gamedata.Exchange.ExchangeData;
   import olympus.core.OlympusObject;
   
   public class ShowPlexView extends OlympusObject
   {
      
      public var actor_sim_id:String;
      
      public var lot_ids_for_travel:Array = [String];
      
      public var dialog_id:uint;
      
      public var traveling_sim_ids:Array = [String];
      
      public var mMode:int = -1;
      
      public var mExchangeData:ExchangeData;
      
      public function ShowPlexView(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.lot_ids_for_travel);
         FixupArray(this.traveling_sim_ids);
      }
   }
}

