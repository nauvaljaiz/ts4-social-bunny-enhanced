package gamedata.shared
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class BundleTuning extends OlympusObject
   {
      
      public static var sBundleTuning:Object;
      
      public var iconUnowned:ResourceKey = new ResourceKey();
      
      public var iconOwned:ResourceKey = new ResourceKey();
      
      public var shortDescription:LocKey = new LocKey();
      
      public var promoData:PromoData = new PromoData();
      
      public var url:String;
      
      public var bundleId:String;
      
      public var bundleName:LocKey = new LocKey();
      
      public function BundleTuning(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetBundleTuning(param1:String) : BundleTuning
      {
         if(!sBundleTuning)
         {
            LoadTuning();
         }
         return sBundleTuning[param1];
      }
      
      protected static function LoadTuning() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Array = CommunicationManager.CallGameService("GetBundleTuning",null,true) as Array;
         if(_loc1_)
         {
            sBundleTuning = new Object();
            for each(_loc2_ in _loc1_)
            {
               sBundleTuning[_loc2_.bundleId] = new BundleTuning(_loc2_);
            }
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(!param1.promoData)
         {
            this.promoData = null;
         }
         if(!this.bundleName.IsValid())
         {
            this.bundleName = null;
         }
      }
   }
}

