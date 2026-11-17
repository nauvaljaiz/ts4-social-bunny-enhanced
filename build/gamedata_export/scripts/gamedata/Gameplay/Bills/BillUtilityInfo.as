package gamedata.Gameplay.Bills
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public final class BillUtilityInfo extends OlympusObject
   {
      
      public var utility:String;
      
      public var cost:String;
      
      public var max_value:String;
      
      public var current_value:String;
      
      public var utility_name:LocKey = new LocKey();
      
      public var utility_symbol:int;
      
      public var rate_of_change:Number;
      
      public var selling:Boolean;
      
      public function BillUtilityInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public function get MaxValueInteger() : int
      {
         return parseInt(this.max_value);
      }
      
      public function get CurrentValueInteger() : int
      {
         return parseInt(this.current_value);
      }
      
      public function get Symbol() : String
      {
         return this.utility_symbol ? String.fromCharCode(this.utility_symbol) : "";
      }
   }
}

