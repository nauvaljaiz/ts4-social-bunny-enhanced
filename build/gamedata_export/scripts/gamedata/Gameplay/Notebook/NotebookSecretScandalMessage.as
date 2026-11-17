package gamedata.Gameplay.Notebook
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class NotebookSecretScandalMessage extends OlympusObject
   {
      
      public var secret_status:LocKey = new LocKey();
      
      public var expiration_text:LocKey = new LocKey();
      
      public var expiration_seconds:uint;
      
      public var complicit_sim_id:String;
      
      public var secret_holder_sim_id:String;
      
      public var severity:IconInfo = new IconInfo();
      
      public var blackmailers:Array = [String];
      
      public var confidantes:Array = [String];
      
      public var scandal_effects:LocKey = new LocKey();
      
      public var secret_id:String;
      
      public function NotebookSecretScandalMessage(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.secret_status = FixupLocKey(this.secret_status);
         this.expiration_text = FixupLocKey(this.expiration_text);
         FixupArray(this.blackmailers);
         FixupArray(this.confidantes);
      }
   }
}

