package gamedata.MTX
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class PackFeatureData extends OlympusObject
   {
      
      public var title:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:String;
      
      public var lessonId:String;
      
      public function PackFeatureData(param1:Object = null)
      {
         super(param1);
      }
   }
}

