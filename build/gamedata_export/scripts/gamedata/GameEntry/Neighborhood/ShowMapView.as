package gamedata.GameEntry.Neighborhood
{
   import gamedata.BuildBuy.Venues.VenueInfo;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class ShowMapView extends OlympusObject
   {
      
      public static const TRAVEL:uint = 0;
      
      public static const VACATION:uint = 1;
      
      public static const PURCHASE_LOT:uint = 2;
      
      public static const CHANGE_VENUE:uint = 3;
      
      public var actor_sim_id:String;
      
      public var lot_ids_for_travel:Array = [String];
      
      public var dialog_id:uint;
      
      public var traveling_sim_ids:Array = [String];
      
      public var mode:uint;
      
      public var purchase_venue_type:String;
      
      public var venue_types_allowed:Array = [String];
      
      public var target_sim_id:String;
      
      protected var mPurchaseVenueInfo:VenueInfo;
      
      public function ShowMapView(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.lot_ids_for_travel);
         FixupArray(this.traveling_sim_ids);
      }
      
      public function get PurchaseVenueInfo() : VenueInfo
      {
         var _loc1_:Object = null;
         if(!this.mPurchaseVenueInfo)
         {
            _loc1_ = CommunicationManager.CallGameService("BBGetVenueInfo",{"venueKey":this.purchase_venue_type});
            if(_loc1_)
            {
               this.mPurchaseVenueInfo = new VenueInfo(_loc1_);
            }
         }
         return this.mPurchaseVenueInfo;
      }
      
      public function get PurchaseVenueName() : String
      {
         var _loc1_:VenueInfo = this.PurchaseVenueInfo;
         return _loc1_ ? _loc1_.nameKey.toString() : null;
      }
   }
}

