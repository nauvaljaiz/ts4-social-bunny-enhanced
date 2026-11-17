package gamedata.Gameplay.InteractionMenu.definitions
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class MoodOverride extends OlympusObject
   {
      
      public var mood_id:String;
      
      public var name_override:LocKey = new LocKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public function MoodOverride(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.tooltip.IsValid())
         {
            this.tooltip = null;
         }
      }
   }
}

