package gamedata.Gameplay.Careers
{
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public final class AuditionUpdate extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var audition_info:GigInfo;
      
      public var recommended_task:IconInfo;
      
      public function AuditionUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.sim_id = param1.sim_id;
         if("audition_info" in param1)
         {
            this.audition_info = new GigInfo(param1.audition_info);
         }
         if("recommended_task" in param1)
         {
            this.recommended_task = new IconInfo(param1.recommended_task);
         }
      }
   }
}

