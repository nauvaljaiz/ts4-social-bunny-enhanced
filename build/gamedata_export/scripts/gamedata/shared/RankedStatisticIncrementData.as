package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class RankedStatisticIncrementData extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var short_name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var tooltip_text:LocKey = new LocKey();
      
      public var rank_color:uint;
      
      public var hide_in_ui:Boolean;
      
      public var ui_interval_override_lower_bound:Number = -1;
      
      public var ui_interval_override_upper_bound:Number = -1;
      
      public var rank_up:Boolean;
      
      public var points:int;
      
      public var rankIndex:int;
      
      public function RankedStatisticIncrementData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.name.IsValid())
         {
            this.name = null;
         }
         if(!this.short_name.IsValid())
         {
            this.short_name = null;
         }
         if(!this.description.IsValid())
         {
            this.description = null;
         }
         if(!this.tooltip_text.IsValid())
         {
            this.tooltip_text = null;
         }
         if(this.ui_interval_override_lower_bound in param1 && this.ui_interval_override_upper_bound in param1)
         {
            this.ui_interval_override_lower_bound = param1.ui_interval_override_lower_bound;
            this.ui_interval_override_upper_bound = param1.ui_interval_override_upper_bound;
         }
      }
   }
}

