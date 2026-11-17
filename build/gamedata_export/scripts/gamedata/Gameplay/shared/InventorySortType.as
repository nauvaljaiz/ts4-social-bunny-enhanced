package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class InventorySortType extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var bAscending:Boolean = true;
      
      public var type:uint;
      
      public var debugName:String;
      
      public function InventorySortType(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.name = FixupLocKey(this.name);
      }
   }
}

