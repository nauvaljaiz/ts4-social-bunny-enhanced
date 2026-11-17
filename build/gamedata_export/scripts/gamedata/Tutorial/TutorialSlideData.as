package gamedata.Tutorial
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class TutorialSlideData extends OlympusObject
   {
      
      public var resourceId:ResourceKey = new ResourceKey();
      
      public var text:LocKey = new LocKey();
      
      public function TutorialSlideData(param1:Object = null)
      {
         super(param1);
      }
   }
}

