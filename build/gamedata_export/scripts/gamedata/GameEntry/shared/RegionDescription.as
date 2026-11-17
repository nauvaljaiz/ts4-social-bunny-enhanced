package gamedata.GameEntry.shared
{
   import flash.utils.getDefinitionByName;
   import gamedata.GameContent;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   
   public class RegionDescription extends OlympusObject
   {
      
      protected static var sRegionDescriptions:Array;
      
      public var id:String;
      
      public var regionName:LocKey = new LocKey();
      
      public var regionDescription:LocKey = new LocKey();
      
      public var regionIcon:String;
      
      public var regionTooltip:LocKey = new LocKey();
      
      public var regionType:String;
      
      public var mapBgImageId:String;
      
      public var bVacationWorld:Boolean;
      
      public var bIsPlayerFacing:Boolean;
      
      public var overlayLayer:String;
      
      public var mapFileNameHash:String;
      
      public var parallaxLayers:Array = [String];
      
      public var isSummitWeatherEnabled:Boolean;
      
      public var packId:uint;
      
      public var packProductId:String;
      
      public var packProductName:LocKey = new LocKey();
      
      public var packDownloadDate:String;
      
      public var bLocked:Boolean = false;
      
      public var bInstalled:Boolean = true;
      
      public var bPreorder:Boolean = true;
      
      public var bDisableViewLotTypes:Boolean = false;
      
      public var bIsGuidanceRecommended:Boolean = false;
      
      public var travelOnlyLotsList:Array = [TravelOnlyLots];
      
      public var travelOnlyLots:Object = new Object();
      
      public var touristHighlightsList:Array = [IconInfo];
      
      public var regionImageId:String;
      
      public var price:Number = 0;
      
      public var devFlags:int;
      
      public var thumbnailId:String;
      
      public var instanceName:*;
      
      public function RegionDescription(param1:Object = null)
      {
         super(param1);
         FixupArray(this.parallaxLayers);
         FixupArray(this.travelOnlyLotsList);
         FixupArray(this.touristHighlightsList);
      }
      
      public static function GetRegions(param1:Boolean = false) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 || sRegionDescriptions == null)
         {
            _loc2_ = CommunicationManager.CallGameService("GetRegionList",null) as Array;
            if(_loc2_)
            {
               _loc3_ = int(_loc2_.length);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc2_[_loc4_] = new RegionDescription(_loc2_[_loc4_]);
                  _loc4_++;
               }
               sRegionDescriptions = _loc2_;
            }
            else
            {
               sRegionDescriptions = [];
            }
         }
         return sRegionDescriptions;
      }
      
      public static function GetUnavailableRegions() : Array
      {
         var _loc3_:RegionDescription = null;
         var _loc1_:Array = GetRegions();
         var _loc2_:Array = new Array();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_.bIsPlayerFacing && (_loc3_.bLocked || !_loc3_.bInstalled))
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc2_.sort(Sort);
         return _loc2_;
      }
      
      public static function GetRegionDescription(param1:String) : RegionDescription
      {
         var _loc3_:RegionDescription = null;
         var _loc2_:Array = GetRegions();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function IsVacationWorld(param1:String) : Boolean
      {
         var _loc2_:RegionDescription = GetRegionDescription(param1);
         if(!_loc2_)
         {
            return false;
         }
         return _loc2_.bVacationWorld;
      }
      
      public static function IsPlayerFacing(param1:String) : Boolean
      {
         var _loc2_:RegionDescription = GetRegionDescription(param1);
         if(!_loc2_)
         {
            return false;
         }
         return _loc2_.bIsPlayerFacing;
      }
      
      public static function Sort(param1:RegionDescription, param2:RegionDescription) : int
      {
         var _loc3_:int = GameContent.PackReleaseOrder.indexOf(param1.packId);
         var _loc4_:int = GameContent.PackReleaseOrder.indexOf(param2.packId);
         if(param1.bInstalled != param2.bInstalled)
         {
            return param1.bInstalled ? -1 : 1;
         }
         if(_loc3_ != _loc4_)
         {
            return _loc3_ < _loc4_ ? -1 : 1;
         }
         return param1.regionName.toString().localeCompare(param2.regionName.toString());
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:TravelOnlyLots = null;
         super.ParseObject(param1);
         if(this.travelOnlyLotsList.length)
         {
            for each(_loc2_ in this.travelOnlyLotsList)
            {
               this.travelOnlyLots[_loc2_.lotDescriptionId] = _loc2_.unselectableText;
            }
         }
      }
      
      public function GetRegionType() : String
      {
         return this.regionType;
      }
      
      public function IsSummitWeatherCompatible() : Boolean
      {
         return this.isSummitWeatherEnabled;
      }
   }
}

import olympus.core.OlympusObject;
import olympus.localization.LocKey;

class TravelOnlyLots extends OlympusObject
{
   
   public var lotDescriptionId:String;
   
   public var unselectableText:LocKey = new LocKey();
   
   public function TravelOnlyLots(param1:Object = null)
   {
      super(param1);
   }
   
   override public function ParseObject(param1:Object) : void
   {
      super.ParseObject(param1);
      this.unselectableText = FixupLocKey(this.unselectableText);
   }
}
