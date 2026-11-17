package gamedata.Gameplay.Business
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ReviewIconData extends OlympusObject
   {
      
      public var title:LocKey = new LocKey();
      
      public var desc:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public function ReviewIconData(param1:Object = null)
      {
         super(param1);
      }
   }
}

