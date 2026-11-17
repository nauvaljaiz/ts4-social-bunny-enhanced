package gamedata.Gameplay.Pickers
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class SlotTypesMaxSelectable extends OlympusObject
   {
      
      public var slot_type_key:ResourceKey;
      
      public var max_selectable:uint;
      
      public var selected_count:uint = 0;
      
      public function SlotTypesMaxSelectable(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.max_selectable = param1.max_selectable;
         this.slot_type_key = new ResourceKey(param1.slot_type_key);
      }
      
      public function IsAvailable() : Boolean
      {
         return this.selected_count < this.max_selectable;
      }
      
      public function IsUsed() : Boolean
      {
         return this.selected_count > 0;
      }
      
      public function Increment() : void
      {
         if(this.IsAvailable())
         {
            ++this.selected_count;
         }
      }
      
      public function Decrement() : void
      {
         if(this.selected_count > 0)
         {
            --this.selected_count;
         }
      }
   }
}

