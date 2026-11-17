package gamedata.Achievements
{
   import olympus.core.OlympusObject;
   
   public class AchievementUpdate extends OlympusObject
   {
      
      public var account_id:String;
      
      public var achievements_completed:Array = [String];
      
      public var objectives_completed:Array = [String];
      
      public var init_message:Boolean;
      
      public function AchievementUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.achievements_completed);
         FixupArray(this.objectives_completed);
      }
   }
}

