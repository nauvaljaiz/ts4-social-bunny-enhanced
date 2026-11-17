package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.MoodStaticData;
   import olympus.core.OlympusObject;
   
   public class MoodUpdate extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var mood_key:String;
      
      public var mood_intensity:uint;
      
      public function MoodUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.sim_id = param1.sim_id;
         this.mood_key = param1.mood_key;
         this.mood_intensity = param1.mood_intensity;
      }
      
      public function get MoodName() : String
      {
         return MoodStaticData.GetMoodByKey(this.mood_key).GetPortraitFrame(this.mood_intensity);
      }
   }
}

