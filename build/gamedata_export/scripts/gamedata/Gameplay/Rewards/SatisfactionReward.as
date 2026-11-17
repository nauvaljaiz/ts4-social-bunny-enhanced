package gamedata.Gameplay.Rewards
{
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class SatisfactionReward extends OlympusObject implements IReward
   {
      
      public static const REWARD_TYPE_MONEY:int = 0;
      
      public static const REWARD_TYPE_BUFF:int = 1;
      
      public static const REWARD_TYPE_OBJECT:int = 2;
      
      public static const REWARD_TYPE_TRAIT:int = 3;
      
      public static const REWARD_TYPE_CASPART:int = 4;
      
      public static const REWARD_TYPE_CHILDHOOD_INSPIRATION:int = 5;
      
      public var reward_id:String;
      
      public var cost:uint;
      
      public var affordable:Boolean;
      
      public var available:Boolean;
      
      public var type:int;
      
      public var unavailable_tooltip:LocKey;
      
      public var name:String;
      
      public var desc:String;
      
      public var icon:String;
      
      public function SatisfactionReward(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(Boolean(param1) && "unavailable_tooltip" in param1)
         {
            this.unavailable_tooltip = new LocKey(param1["unavailable_tooltip"]);
         }
      }
      
      public function get Id() : String
      {
         return this.reward_id;
      }
      
      public function get Name() : String
      {
         return this.name;
      }
      
      public function get Description() : String
      {
         return this.desc;
      }
      
      public function get Icon() : String
      {
         return this.icon;
      }
      
      public function get Cost() : uint
      {
         return this.cost;
      }
      
      public function get Affordable() : Boolean
      {
         return this.affordable;
      }
      
      public function set Affordable(param1:Boolean) : void
      {
         this.affordable = param1;
      }
      
      public function get Available() : Boolean
      {
         return this.available;
      }
      
      public function get Locked() : Boolean
      {
         return false;
      }
      
      public function get DisabledTooltip() : LocKey
      {
         if(!this.affordable)
         {
            return KeysGP.REWARDS_PICKER_INSUFFICIENT_POINTS_TOOLTIP;
         }
         if(!this.available)
         {
            return this.unavailable_tooltip ? this.unavailable_tooltip : KeysGP.REWARDS_PICKER_UNAVAILABLE_TOOLTIP;
         }
         return null;
      }
   }
}

