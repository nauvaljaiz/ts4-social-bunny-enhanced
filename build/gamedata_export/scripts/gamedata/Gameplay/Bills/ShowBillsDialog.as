package gamedata.Gameplay.Bills
{
   import olympus.core.OlympusObject;
   
   public final class ShowBillsDialog extends OlympusObject
   {
      
      public static const OP_SHOW_BILLS_DIALOG:uint = 228;
      
      public var utility_info:Array = [BillUtilityInfo];
      
      public var line_items:Array = [BillLineItem];
      
      public var due_bills_line_items:Array = [BillLineItem];
      
      public function ShowBillsDialog(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.utility_info);
         FixupArray(this.line_items);
         FixupArray(this.due_bills_line_items);
      }
      
      public function GetUtilityByID(param1:String) : BillUtilityInfo
      {
         var _loc2_:BillUtilityInfo = null;
         for each(_loc2_ in this.utility_info)
         {
            if(_loc2_.utility == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

