package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class PackCycleImagesTuning extends OlympusObject
   {
      
      public var title:LocKey = new LocKey();
      
      public var largeImage:ResourceKey = new ResourceKey();
      
      public var smallImage:ResourceKey = new ResourceKey();
      
      public function PackCycleImagesTuning(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!this.title.IsValid())
         {
            this.title = null;
         }
      }
   }
}

