package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class UiDialogInfoInColumns extends OlympusObject
   {
      
      public var column_headers:Array = [LocKey];
      
      public var rows:Array = [UiDialogRowData];
      
      public function UiDialogInfoInColumns(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.column_headers);
         FixupArray(this.rows);
      }
   }
}

