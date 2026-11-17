package gamedata.Gameplay.shared
{
   import olympus.localization.LocKey;
   
   public interface ICategoryData
   {
      
      function get ObjectList() : Array;
      
      function get CategoryName() : LocKey;
      
      function get CategoryTooltip() : LocKey;
      
      function get AllObjectList() : Array;
      
      function get AllObjectListSorted() : Array;
      
      function get ItemCellView() : Class;
      
      function get NumObjectsAvailable() : int;
      
      function GetIsCompleted() : Boolean;
      
      function GetNumBonus() : int;
      
      function GetIsNew() : Boolean;
   }
}

