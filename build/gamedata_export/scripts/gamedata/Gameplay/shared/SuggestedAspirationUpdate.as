package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class SuggestedAspirationUpdate extends OlympusObject
   {
      
      public static var MAX_CHILDHOOD_INSPIRATION:int = 5;
      
      public var sim_id:String;
      
      public var visible_suggested_aspiration_list:Array = [String];
      
      public function SuggestedAspirationUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.visible_suggested_aspiration_list);
      }
   }
}

