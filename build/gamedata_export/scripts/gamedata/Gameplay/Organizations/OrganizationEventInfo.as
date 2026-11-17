package gamedata.Gameplay.Organizations
{
   import gamedata.Gameplay.shared.Schedule;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class OrganizationEventInfo extends OlympusObject
   {
      
      public var drama_node_id:String;
      
      public var schedule:Schedule = new Schedule();
      
      public var event_info:IconInfo = new IconInfo();
      
      public var location:LocKey = new LocKey();
      
      public var zone_id:String;
      
      public function OrganizationEventInfo(param1:Object = null)
      {
         super(param1);
      }
   }
}

