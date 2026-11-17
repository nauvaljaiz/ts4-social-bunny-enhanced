package gamedata.Dialog
{
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public class UiDialogRowData extends OlympusObject
   {
      
      public var column_info:Array = [IconInfo];
      
      public function UiDialogRowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.column_info);
      }
   }
}

