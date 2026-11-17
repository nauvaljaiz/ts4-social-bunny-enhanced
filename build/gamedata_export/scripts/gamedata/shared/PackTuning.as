package gamedata.shared
{
   import olympus.controls.IconComponent;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class PackTuning extends OlympusObject
   {
      
      public static var sPackTuning:Array;
      
      public var creditsTitle:LocKey = new LocKey();
      
      public var communityCreatorName:LocKey = new LocKey();
      
      public var dlcTrialTitle:LocKey = new LocKey();
      
      public var dlcTrialPackGoalsDescription:LocKey = new LocKey();
      
      public var dlcTrialImage:ResourceKey = new ResourceKey();
      
      public var dlcTrialRegion:String;
      
      public var filterName:LocKey = new LocKey();
      
      public var icon128:ResourceKey = new ResourceKey();
      
      public var icon64:ResourceKey = new ResourceKey();
      
      public var icon32:ResourceKey = new ResourceKey();
      
      public var packSubType:String;
      
      public var packType:String;
      
      public var webstoreId:String;
      
      public var packId:String;
      
      public var iconUnowned:ResourceKey = new ResourceKey();
      
      public var iconOwned:ResourceKey = new ResourceKey();
      
      public var shortDescription:LocKey = new LocKey();
      
      public var cycleImages:Array = [PackCycleImagesTuning];
      
      public function PackTuning(param1:Object = null)
      {
         super(param1);
      }
      
      public static function LoadDLCTrialImage(param1:int, param2:IconComponent) : void
      {
         var _loc3_:PackTuning = GetPackTuning(param1);
         if(Boolean(_loc3_) && Boolean(_loc3_.dlcTrialImage))
         {
            param2.LoadImage(_loc3_.dlcTrialImage.instance);
         }
      }
      
      public static function GetPackTuning(param1:int) : PackTuning
      {
         if(!sPackTuning)
         {
            LoadTuning();
         }
         if(!sPackTuning)
         {
            return null;
         }
         return sPackTuning[param1];
      }
      
      public static function GetPackDescription(param1:int) : LocKey
      {
         var _loc2_:PackTuning = GetPackTuning(param1);
         if(_loc2_)
         {
            return _loc2_.shortDescription;
         }
         return null;
      }
      
      public static function GetPackOwnedUnownedIcons(param1:int) : Array
      {
         var _loc2_:PackTuning = GetPackTuning(param1);
         if(_loc2_)
         {
            return [_loc2_.iconOwned,_loc2_.iconUnowned];
         }
         return null;
      }
      
      protected static function LoadTuning() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Array = CommunicationManager.CallGameService("GetPackTuning",null) as Array;
         if(_loc1_)
         {
            sPackTuning = new Array();
            for each(_loc2_ in _loc1_)
            {
               sPackTuning[_loc2_.packId] = new PackTuning(_loc2_);
            }
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.cycleImages);
         if(Boolean(this.filterName) && !this.filterName.IsValid())
         {
            this.filterName = null;
         }
         if(Boolean(this.creditsTitle) && !this.creditsTitle.IsValid())
         {
            this.creditsTitle = null;
         }
         if(Boolean(this.communityCreatorName) && !this.communityCreatorName.IsValid())
         {
            this.communityCreatorName = null;
         }
      }
   }
}

