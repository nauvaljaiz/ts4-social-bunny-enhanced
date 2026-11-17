package gamedata.Gameplay.Pickers
{
   import olympus.core.OlympusObject;
   
   public class ObjectPickerData extends OlympusObject
   {
      
      public static const DEFAULT_COLUMN_COUNT:int = 1;
      
      public var row_data:Array = [ObjectPickerRowData];
      
      public var num_columns:uint = 1;
      
      public function ObjectPickerData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.row_data);
      }
      
      public function GetSelectionIndexArray() : Array
      {
         var _loc2_:ObjectPickerRowData = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.row_data)
         {
            _loc1_.push(_loc2_.mIndex);
         }
         return _loc1_;
      }
   }
}

