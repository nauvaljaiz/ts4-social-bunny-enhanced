package gamedata.Gameplay.CheatSheet
{
   import olympus.core.OlympusObject;
   
   public class CheatSheetItemData extends OlympusObject
   {
      
      public var description:String;
      
      public var conditions:Array = [uint];
      
      public var elements:Array = [CheatSheetElementData];
      
      public function CheatSheetItemData(param1:Object)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

