package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class InventoryFilterCategory extends OlympusObject
   {
      
      public var name:LocKey;
      
      public var filters:Array;
      
      public var mbShowSingleFilter:Boolean = false;
      
      public function InventoryFilterCategory(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.name = new LocKey(param1.name);
         this.filters = new Array();
         if("filters" in param1)
         {
            ConstructArrayFromArray(this.filters,param1.filters,InventoryFilterType);
         }
      }
   }
}

