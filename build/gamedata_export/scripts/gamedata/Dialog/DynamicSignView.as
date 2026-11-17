package gamedata.Dialog
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class DynamicSignView extends OlympusObject
   {
      
      public static const DYNAMIC_SIGN_TYPE_DEFAULT:int = 0;
      
      public static const DYNAMIC_SIGN_TYPE_SCENARIO:int = 1;
      
      public var name:LocKey = new LocKey();
      
      public var venue:LocKey = new LocKey();
      
      public var time:LocKey = new LocKey();
      
      public var image:ResourceKey = new ResourceKey();
      
      public var activities:Array = [DynamicSignActivityInfo];
      
      public var action_label:LocKey = new LocKey();
      
      public var disabled_tooltip:LocKey = new LocKey();
      
      public var background_image:ResourceKey = new ResourceKey();
      
      public var drama_node_guid:String;
      
      public var household_id:String;
      
      public var time_spent:Number = NaN;
      
      public var sign_type:int;
      
      public function DynamicSignView(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("name" in param1))
         {
            this.name = null;
         }
         if(!("venue" in param1))
         {
            this.venue = null;
         }
         if(!("time" in param1))
         {
            this.time = null;
         }
         if(!("action_label" in param1))
         {
            this.action_label = null;
         }
         if(!("disabled_tooltip" in param1))
         {
            this.disabled_tooltip = null;
         }
         if(!("background_image" in param1))
         {
            this.background_image = null;
         }
         FixupArray(this.activities);
      }
   }
}

