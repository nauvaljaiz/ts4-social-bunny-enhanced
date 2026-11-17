package gamedata.GameEntry.shared
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class RegionTypeHeading extends OlympusObject
   {
      
      protected static var sRegionTypeHeadings:Object = new Object();
      
      public var heading:LocKey = new LocKey();
      
      public var vacation_subheading:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public function RegionTypeHeading(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetRegionTypeHeading(param1:String) : RegionTypeHeading
      {
         var _loc2_:RegionTypeHeading = sRegionTypeHeadings[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Object = CommunicationManager.CallGameService("GetRegionTypeHeadingFromType",param1);
         if(_loc3_)
         {
            _loc2_ = new RegionTypeHeading(_loc3_);
            sRegionTypeHeadings[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
   }
}

