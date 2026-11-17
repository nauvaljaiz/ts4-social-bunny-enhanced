package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class CareerBuildBuyInfo extends OlympusObject
   {
      
      public var budget_label:LocKey;
      
      public var over_budget_label:LocKey;
      
      public var payout_label:LocKey;
      
      public var help_text:LocKey;
      
      public var wallet_tooltip_budget_label:LocKey;
      
      public var wallet_tooltip_over_budget_label:LocKey;
      
      public function CareerBuildBuyInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(param1)
         {
            if("budget_label" in param1)
            {
               this.budget_label = new LocKey(param1["budget_label"]);
            }
            if("over_budget_label" in param1)
            {
               this.over_budget_label = new LocKey(param1["over_budget_label"]);
            }
            if("payout_label" in param1)
            {
               this.payout_label = new LocKey(param1["payout_label"]);
            }
            if("help_text" in param1)
            {
               this.help_text = new LocKey(param1["help_text"]);
            }
            if("wallet_tooltip_budget_label" in param1)
            {
               this.wallet_tooltip_budget_label = new LocKey(param1["wallet_tooltip_budget_label"]);
            }
            if("wallet_tooltip_over_budget_label" in param1)
            {
               this.wallet_tooltip_over_budget_label = new LocKey(param1["wallet_tooltip_over_budget_label"]);
            }
         }
      }
   }
}

