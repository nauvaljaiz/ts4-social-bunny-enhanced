package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   
   public class OutfitPickerData extends OlympusObject
   {
      
      public static const SIM_INFO:uint = 1;
      
      public static const MANNEQUIN:uint = 2;
      
      public var row_data:Array = [OutfitPickerRowData];
      
      public var thumbnail_type:uint;
      
      public var outfit_category_filters:Array = [uint];
      
      public var mOptionalData:Object;
      
      public function OutfitPickerData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.row_data);
      }
   }
}

