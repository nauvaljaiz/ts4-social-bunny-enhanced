package gamedata.Gameplay.Pickers
{
   public interface IComparableRow
   {
      
      function CanCompareColumn(param1:PickerColumn) : Boolean;
      
      function CompareColumn(param1:PickerColumn, param2:IComparableRow) : Number;
   }
}

