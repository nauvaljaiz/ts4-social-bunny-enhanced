package gamedata.Gameplay.Pickers.DataFeeds
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class RecipeGroupOverrideData extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public var skill_level:uint;
      
      public function RecipeGroupOverrideData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("name" in param1) || !param1.name)
         {
            this.name = null;
         }
         if(!("tooltip" in param1) || !param1.tooltip)
         {
            this.tooltip = null;
         }
      }
   }
}

