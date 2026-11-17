package gamedata.Gameplay.SimCompetition
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class SimCompetitionObjectData extends OlympusObject
   {
      
      public var selected_object_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var icon:IconInfo = new IconInfo();
      
      public function SimCompetitionObjectData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
      }
   }
}

