package gamedata.Gameplay.Careers
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public final class PrepTaskData extends OlympusObject
   {
      
      public var task_name:LocKey = new LocKey();
      
      public var task_icon:ResourceKey = new ResourceKey();
      
      public var is_completed:Boolean;
      
      public var task_tooltip:LocKey = new LocKey();
      
      public function PrepTaskData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1 || !("task_icon" in param1))
         {
            this.task_icon = null;
         }
      }
   }
}

