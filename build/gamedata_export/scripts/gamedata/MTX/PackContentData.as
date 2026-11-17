package gamedata.MTX
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class PackContentData extends OlympusObject
   {
      
      public var title:LocKey = new LocKey();
      
      public var images:Array = [String];
      
      public var features:Array = [PackFeatureData];
      
      public function PackContentData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.images);
         FixupArray(this.features);
      }
   }
}

