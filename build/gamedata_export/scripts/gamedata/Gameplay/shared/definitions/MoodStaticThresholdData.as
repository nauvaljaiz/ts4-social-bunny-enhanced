package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.objects.IconInfo;
   
   public class MoodStaticThresholdData extends OlympusObject
   {
      
      public var intensity:uint;
      
      public var icon_info:IconInfo = new IconInfo();
      
      public function MoodStaticThresholdData(param1:Object = null)
      {
         super(param1);
      }
   }
}

