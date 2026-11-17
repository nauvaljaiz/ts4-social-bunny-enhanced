package gamedata.Gameplay.SocialGroup
{
   import olympus.core.OlympusObject;
   
   public class SocialGroup extends OlympusObject
   {
      
      public var social_group_id:String;
      
      public var members:Array = [SocialGroupMember];
      
      public function SocialGroup(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.members);
      }
   }
}

