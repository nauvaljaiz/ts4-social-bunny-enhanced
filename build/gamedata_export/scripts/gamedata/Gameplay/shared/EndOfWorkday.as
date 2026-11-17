package gamedata.Gameplay.shared
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class EndOfWorkday extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var career_uid:String;
      
      public var score_text:LocKey = new LocKey();
      
      public var level_icon:ResourceKey = new ResourceKey();
      
      public var money_earned:uint;
      
      public var paid_time_off_earned:uint;
      
      public var promotion:EndOfWorkdayPromotion = new EndOfWorkdayPromotion();
      
      public function EndOfWorkday(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!("promotion" in param1) || !param1.promotion)
         {
            this.promotion = null;
         }
      }
   }
}

