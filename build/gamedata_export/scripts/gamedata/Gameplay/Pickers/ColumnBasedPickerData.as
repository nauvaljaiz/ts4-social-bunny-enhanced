package gamedata.Gameplay.Pickers
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class ColumnBasedPickerData extends OlympusObject
   {
      
      public var star_ranking:Number;
      
      public var row_data:Array = [ColumnBasedPickerRowData];
      
      public var picker_background:ResourceKey = new ResourceKey();
      
      public var hide_star_rating:Boolean;
      
      public function ColumnBasedPickerData(param1:Object = null)
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

