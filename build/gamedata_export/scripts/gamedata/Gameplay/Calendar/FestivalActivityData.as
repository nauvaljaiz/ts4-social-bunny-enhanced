package gamedata.Gameplay.Calendar
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class FestivalActivityData extends OlympusObject
   {
      
      public var name:LocKey = new LocKey();
      
      public var icon:IconInfo = new IconInfo();
      
      public var description:LocKey = new LocKey();
      
      public var mbUseOddDisplay:Boolean = false;
      
      public function FestivalActivityData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupLocKey(this.name);
         FixupLocKey(this.description);
      }
   }
}

