package gamedata.Gameplay.SocialGroup
{
   import olympus.core.OlympusObject;
   
   public class SocialGroupMember extends OlympusObject
   {
      
      public var sim_id:String;
      
      public var social_context_bit_id:String;
      
      public var object_id:String;
      
      public var object_definition_id:String;
      
      public function SocialGroupMember(param1:Object = null)
      {
         super(param1);
      }
      
      public function get Id() : String
      {
         return this.sim_id || this.object_id;
      }
   }
}

