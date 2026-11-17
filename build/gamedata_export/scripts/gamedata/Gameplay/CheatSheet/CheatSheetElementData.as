package gamedata.Gameplay.CheatSheet
{
   import olympus.core.OlympusObject;
   
   public class CheatSheetElementData extends OlympusObject
   {
      
      public var element_type:uint;
      
      public var keyframe:String;
      
      public var control:String;
      
      public function CheatSheetElementData(param1:Object)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

