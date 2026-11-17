package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class AgeProgressUpdate extends OlympusObject
   {
      
      public var progress:uint = 0;
      
      public var aging_disabled_tooltip:LocKey = new LocKey();
      
      public var simId:String;
      
      public function AgeProgressUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.aging_disabled_tooltip.IsValid())
         {
            this.aging_disabled_tooltip = null;
         }
      }
      
      public function UpdateAgeProgress(param1:Object) : void
      {
         if(param1)
         {
            this.progress = param1["progress"];
            this.aging_disabled_tooltip = param1["aging_disabled_tooltip"];
         }
      }
   }
}

