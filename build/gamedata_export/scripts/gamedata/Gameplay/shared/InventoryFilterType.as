package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class InventoryFilterType extends OlympusObject
   {
      
      public var tags:Array;
      
      public var disqualifyingTags:Array;
      
      public var name:LocKey = new LocKey();
      
      public function InventoryFilterType(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.tags = param1.tags;
         this.disqualifyingTags = param1.disqualifyingTags;
         this.name = LocKey.GetValidatedLocKey(param1.name);
      }
   }
}

