package gamedata.Gameplay.shared.definitions
{
   import gamedata.GameEntry.Neighborhood.NeighborhoodData;
   import gamedata.GameEntry.Neighborhood.StreetInfoData;
   import gamedata.Gameplay.shared.EcoFootprint;
   import gamedata.Gameplay.shared.EcoFootprintStateInfo;
   import gamedata.Gameplay.shared.EcoFootprintStreetDescriptorInfo;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysGE;
   import widgets.GameEntry.Neighborhood.data.StreetDescriptorInitData;
   import widgets.shared.GENeighborhoodStateManager;
   
   public class EcoFootprintStaticData extends OlympusObject
   {
      
      protected static var sEcoFootprintStaticData:EcoFootprintStaticData = null;
      
      public var ecoFootprintStateInfoArray:Array;
      
      public var mEcoFootprintStateInfoMap:Object;
      
      public function EcoFootprintStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData() : EcoFootprintStaticData
      {
         if(!sEcoFootprintStaticData)
         {
            sEcoFootprintStaticData = new EcoFootprintStaticData(CommunicationManager.CallGameService("GetEcoFootprintTuning"));
         }
         return sEcoFootprintStaticData;
      }
      
      public static function GetEcoFootprintStateForWorldDescription(param1:String) : int
      {
         var _loc2_:GENeighborhoodStateManager = GENeighborhoodStateManager.getInstance();
         var _loc3_:NeighborhoodData = _loc2_ ? _loc2_.ActiveNeighborhood : null;
         var _loc4_:StreetInfoData = _loc3_ ? _loc3_.GetStreetInfoDataByWorldDescriptionId(param1) : null;
         return _loc4_ ? int(_loc4_.ecoFootprintState) : int(EcoFootprint.ECO_FOOTPRINT_STATE_NEUTRAL);
      }
      
      public static function GetStreetDescriptorInitData(param1:int) : StreetDescriptorInitData
      {
         var _loc2_:EcoFootprintStaticData = EcoFootprintStaticData.GetStaticData();
         var _loc3_:EcoFootprintStateInfo = _loc2_ ? _loc2_.mEcoFootprintStateInfoMap[param1] : null;
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:EcoFootprintStreetDescriptorInfo = _loc3_.streetDescriptorTuning;
         var _loc5_:String = _loc3_.nameText.toString();
         var _loc6_:String = KeysGE.NHD_ECO_FOOTPRINT_STREET_DESCRIPTOR_NAME_FORMAT.toString(_loc5_);
         return new StreetDescriptorInitData(_loc3_.icon ? _loc3_.icon.instance : null,_loc6_,_loc4_.descriptionText.toString(),_loc4_.backgroundColor,_loc4_.nameTextColor,_loc4_.descriptionTextColor);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc4_:EcoFootprintStateInfo = null;
         this.ecoFootprintStateInfoArray = new Array();
         ConstructArrayFromArray(this.ecoFootprintStateInfoArray,param1.ecoFootprintStateInfoArray,EcoFootprintStateInfo);
         this.mEcoFootprintStateInfoMap = new Object();
         var _loc2_:Array = this.ecoFootprintStateInfoArray;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            this.mEcoFootprintStateInfoMap[_loc4_.ecoFootprintState] = _loc4_;
            _loc3_++;
         }
      }
   }
}

