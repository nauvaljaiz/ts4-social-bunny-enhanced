package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class SmallBusinessCareerData extends OlympusObject
   {
      
      public var business_name:String;
      
      public var career_level:int;
      
      public var owner_id:String;
      
      public var business_icon:ResourceKey = new ResourceKey();
      
      public function SmallBusinessCareerData(param1:Object = null)
      {
         super(param1);
      }
   }
}

