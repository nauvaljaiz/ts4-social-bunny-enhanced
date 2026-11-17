package widgets.LiveEvent.data
{
   import gamedata.GameContent;
   import gamedata.shared.PackFilterData;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import widgets.shared.constants.LiveEventSharedTunables;
   
   public class AccountRewardData extends OlympusObject
   {
      
      public var instance_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var category:LocKey = new LocKey();
      
      public var category_type:int = 0;
      
      public var location_tip:LocKey = new LocKey();
      
      public var image:String;
      
      public var small_image:String;
      
      public var large_image:String;
      
      public var state:int;
      
      public var checkpoint:int;
      
      public var is_milestone:int;
      
      public var reward_thumbnail_image:String;
      
      public var required_pack_id:int;
      
      public function AccountRewardData(param1:Object = null)
      {
         super(param1);
      }
      
      public function GetRewardPackString() : String
      {
         var _loc1_:PackFilterData = GameContent.GetPackData(this.required_pack_id);
         return _loc1_ ? _loc1_.title.toString() : null;
      }
      
      public function IsRewardUnavailable() : Boolean
      {
         return this.state == LiveEventSharedTunables.REWARD_STATE_UNLOCKED || this.state == LiveEventSharedTunables.REWARD_STATE_LOCKED;
      }
   }
}

