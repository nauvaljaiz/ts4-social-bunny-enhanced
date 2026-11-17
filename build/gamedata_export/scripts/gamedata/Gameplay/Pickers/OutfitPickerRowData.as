package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   
   public class OutfitPickerRowData extends OlympusObject
   {
      
      public static const EDIT_OUFITS_NUM_OUTFITS_PER_GENDER:int = 5;
      
      public var base_data:PickerBaseRowData = new PickerBaseRowData();
      
      public var outfit_sim_id:String;
      
      public var outfit_category:uint;
      
      public var outfit_index:uint;
      
      public var mOptionalData:Object;
      
      public function OutfitPickerRowData(param1:Object = null)
      {
         super(param1);
      }
   }
}

