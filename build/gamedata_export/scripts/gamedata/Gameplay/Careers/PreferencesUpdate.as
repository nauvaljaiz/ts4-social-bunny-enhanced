package gamedata.Gameplay.Careers
{
   import olympus.core.OlympusObject;
   
   public class PreferencesUpdate extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var career_uid:String;
      
      public var revealed_preference_id:String;
      
      public var client_preferences:Array;
      
      public var known_client_preferences:Array;
      
      public function PreferencesUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.sim_id = param1.sim_id;
         this.career_uid = param1.career_uid;
         this.revealed_preference_id = param1.revealed_preference_id;
         if("client_preferences" in param1)
         {
            this.client_preferences = new Array();
            ConstructArrayFromArray(this.client_preferences,param1.client_preferences,String);
         }
         if("known_client_preferences" in param1)
         {
            this.known_client_preferences = new Array();
            ConstructArrayFromArray(this.known_client_preferences,param1.known_client_preferences,String);
         }
      }
   }
}

