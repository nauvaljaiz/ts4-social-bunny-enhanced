package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.CAS.shared.SimInfo;
   import gamedata.Gameplay.shared.AgeUpdate;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.Gameplay.shared.SimTraitsInfo;
   import gamedata.shared.HouseholdSimData;
   import gamedata.shared.ResourceKey;
   import olympus.constants.GameStates;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class TraitsStaticData extends OlympusObject
   {
      
      protected static var sStaticData:Vector.<TraitsStaticData>;
      
      protected static var sCASEquippedTraitIds:Array;
      
      protected static var sLotSelectSim:HouseholdSimData;
      
      public static var sGetStaticDataFunc:Function;
      
      public static const TRAIT_IS_GHOST_TUNING:String = "381402";
      
      protected static var sTraitMap:Object = new Object();
      
      public var title:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var id:String = "0";
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var display_overrides:Array = [TraitAppearanceOverrideData];
      
      public var cas_selected_icon:ResourceKey = new ResourceKey();
      
      public var ui_category:String;
      
      public var conflictTraits:Array = [LocKey];
      
      public var conflictingTraitIds:Array = [String];
      
      public var equipped:Boolean = false;
      
      public var type:String;
      
      public var groupId:int = 0;
      
      public var tags:Array = [String];
      
      public var trait_origin_description:LocKey = new LocKey();
      
      public var bb_filter_tags:Array = [uint];
      
      public var bb_filter_styles:Array = [ResourceKey];
      
      public var neutral_title:LocKey = new LocKey();
      
      public var visualState:int;
      
      public var refresh_sim_thumbnail:Boolean;
      
      protected var mbHasAgeDisplayOverrideCriteria:Boolean = false;
      
      protected var mbHasOccultTypeDisplayOverrideCriteria:Boolean = false;
      
      protected var mbHasTraitsDisplayOverrideCriteria:Boolean = false;
      
      protected var mbHasTitleDisplayOverride:Boolean = false;
      
      protected var mbHasDescriptionDisplayOverride:Boolean = false;
      
      protected var mbHasIconDisplayOverride:Boolean = false;
      
      protected var mbHasTraitOriginDescriptionDisplayOverride:Boolean = false;
      
      public function TraitsStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function CacheCASEquippedTraits(param1:Boolean) : void
      {
         if(param1)
         {
            sCASEquippedTraitIds = CommunicationManager.CallGameService("CasGetEquippedTraits") as Array;
         }
         else
         {
            sCASEquippedTraitIds = null;
         }
      }
      
      public static function CacheLotSelectSim(param1:HouseholdSimData) : void
      {
         sLotSelectSim = param1;
      }
      
      public static function GetStaticData(param1:String) : TraitsStaticData
      {
         var _loc2_:TraitsStaticData = sTraitMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new TraitsStaticData(_loc3_[0]);
            sTraitMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      public static function SortingFunction(param1:TraitsStaticData, param2:TraitsStaticData) : Number
      {
         return param1.title.toString({"simId":"0"}).localeCompare(param2.title.toString({"simId":"0"}));
      }
      
      public static function SetStaticDataTraitConflicts(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:TraitsStaticData = null;
         for(_loc2_ in param1)
         {
            _loc3_ = param1[_loc2_];
            if(_loc3_)
            {
               _loc4_ = _loc3_.conflictTraits;
               if(_loc4_)
               {
                  ConstructArrayInPlace(_loc4_,LocKey);
                  _loc5_ = GetStaticData(_loc3_.id);
                  if(_loc5_)
                  {
                     _loc5_.conflictTraits = _loc4_;
                  }
               }
            }
         }
      }
      
      public static function ClearStaticDataTraitConflicts() : void
      {
         var _loc1_:TraitsStaticData = null;
         for each(_loc1_ in sTraitMap)
         {
            _loc1_.conflictTraits = null;
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:TraitAppearanceOverrideData = null;
         if(param1)
         {
            super.ParseObject(param1);
            this.trait_origin_description = FixupLocKey(this.trait_origin_description);
            FixupArray(this.conflictTraits);
            FixupArray(this.conflictingTraitIds);
            FixupArray(this.display_overrides);
            FixupArray(this.tags);
            FixupArray(this.bb_filter_tags);
            FixupArray(this.bb_filter_styles);
            for each(_loc2_ in this.display_overrides)
            {
               this.mbHasAgeDisplayOverrideCriteria = this.mbHasAgeDisplayOverrideCriteria || _loc2_.HasAgeCriteria;
               this.mbHasOccultTypeDisplayOverrideCriteria = this.mbHasOccultTypeDisplayOverrideCriteria || _loc2_.HasOccultTypeCriteria;
               this.mbHasTraitsDisplayOverrideCriteria = this.mbHasTraitsDisplayOverrideCriteria || _loc2_.HasTraitsCriteria;
               this.mbHasTitleDisplayOverride = this.mbHasTitleDisplayOverride || _loc2_.title != null;
               this.mbHasDescriptionDisplayOverride = this.mbHasDescriptionDisplayOverride || _loc2_.description != null;
               this.mbHasIconDisplayOverride = this.mbHasIconDisplayOverride || _loc2_.icon != null;
               this.mbHasTraitOriginDescriptionDisplayOverride = this.mbHasTraitOriginDescriptionDisplayOverride || _loc2_.trait_origin_description != null;
            }
         }
      }
      
      protected function CanOverrideTraitDisplayData() : Boolean
      {
         var _loc1_:uint = CommunicationManager.CallGameService("GetGameState",null) as uint;
         return _loc1_ != GameStates.MAIN_MENU && (_loc1_ != GameStates.LOT_SELECT && sLotSelectSim == null);
      }
      
      public function GetIconBySimIdToken(param1:Object = null) : String
      {
         var _loc2_:TraitAppearanceOverrideData = null;
         if(param1 != null && this.mbHasIconDisplayOverride && this.CanOverrideTraitDisplayData())
         {
            _loc2_ = this.GetOverrideBySimIdToken(param1);
            if(Boolean(_loc2_) && Boolean(_loc2_.icon))
            {
               return _loc2_.icon.instance;
            }
         }
         return this.icon.instance;
      }
      
      public function GetIconBySimInfo(param1:SimInfo) : String
      {
         var _loc2_:TraitAppearanceOverrideData = null;
         if(this.mbHasIconDisplayOverride && this.CanOverrideTraitDisplayData())
         {
            _loc2_ = this.GetOverrideBySimInfo(param1);
            if(Boolean(_loc2_) && Boolean(_loc2_.icon))
            {
               return _loc2_.icon.instance;
            }
         }
         return this.icon.instance;
      }
      
      public function GetTitleLocKeyBySimIdToken(param1:Object = null) : LocKey
      {
         var _loc2_:TraitAppearanceOverrideData = null;
         if(param1 != null && this.mbHasTitleDisplayOverride && this.CanOverrideTraitDisplayData())
         {
            _loc2_ = this.GetOverrideBySimIdToken(param1);
            if(Boolean(_loc2_) && Boolean(_loc2_.title))
            {
               return _loc2_.title;
            }
         }
         return this.title;
      }
      
      public function GetGenderNeutralTitleLocKey() : LocKey
      {
         return this.neutral_title;
      }
      
      public function GetTitleStringBySimIdToken(param1:Object) : String
      {
         return this.GetTitleLocKeyBySimIdToken(param1).toString(param1);
      }
      
      public function GetTitleLocKeyBySimInfo(param1:SimInfo) : LocKey
      {
         var _loc2_:TraitAppearanceOverrideData = null;
         if(this.mbHasIconDisplayOverride && this.CanOverrideTraitDisplayData())
         {
            _loc2_ = this.GetOverrideBySimInfo(param1);
            if(Boolean(_loc2_) && Boolean(_loc2_.title))
            {
               return _loc2_.title;
            }
         }
         return this.title;
      }
      
      public function GetDescriptionLocKeyBySimIdToken(param1:Object) : LocKey
      {
         var _loc2_:TraitAppearanceOverrideData = null;
         if(param1 != null && this.mbHasIconDisplayOverride && this.CanOverrideTraitDisplayData())
         {
            _loc2_ = this.GetOverrideBySimIdToken(param1);
            if(Boolean(_loc2_) && Boolean(_loc2_.description))
            {
               return _loc2_.description;
            }
         }
         return this.description;
      }
      
      public function GetDescriptionStringBySimIdToken(param1:Object) : String
      {
         return this.GetDescriptionLocKeyBySimIdToken(param1).toString(param1);
      }
      
      public function GetDescriptionLocKeyBySimInfo(param1:SimInfo) : LocKey
      {
         var _loc2_:TraitAppearanceOverrideData = null;
         if(this.mbHasIconDisplayOverride && this.CanOverrideTraitDisplayData())
         {
            _loc2_ = this.GetOverrideBySimInfo(param1);
            if(Boolean(_loc2_) && Boolean(_loc2_.description))
            {
               return _loc2_.description;
            }
         }
         return this.description;
      }
      
      public function GetTraitOriginDescriptionLocKeyBySimIdToken(param1:Object = null) : LocKey
      {
         var _loc2_:TraitAppearanceOverrideData = null;
         if(param1 != null && this.mbHasIconDisplayOverride && this.CanOverrideTraitDisplayData())
         {
            _loc2_ = this.GetOverrideBySimIdToken(param1);
            if(Boolean(_loc2_) && Boolean(_loc2_.trait_origin_description))
            {
               return _loc2_.trait_origin_description;
            }
         }
         return this.trait_origin_description;
      }
      
      public function GetTraitOriginDescriptionLocKeyBySimInfo(param1:SimInfo) : LocKey
      {
         var _loc2_:TraitAppearanceOverrideData = null;
         if(this.mbHasIconDisplayOverride && this.CanOverrideTraitDisplayData())
         {
            _loc2_ = this.GetOverrideBySimInfo(param1);
            if(Boolean(_loc2_) && Boolean(_loc2_.trait_origin_description))
            {
               return _loc2_.trait_origin_description;
            }
         }
         return this.trait_origin_description;
      }
      
      public function GetOverrideBySimIdToken(param1:Object = null) : TraitAppearanceOverrideData
      {
         var _loc2_:AgeUpdate = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = param1 != null && param1["simId"] is String && param1["simId"] != "0" ? param1["simId"] : GameplayStateData.ActiveSimId;
         if(_loc5_ == null)
         {
            _loc5_ = "0";
         }
         if(this.mbHasAgeDisplayOverrideCriteria)
         {
            if(param1["simAge"])
            {
               _loc2_ = new AgeUpdate({"age":param1["simAge"]});
            }
            else
            {
               _loc2_ = new AgeUpdate(CommunicationManager.CallGameService("GetSimAge",_loc5_));
            }
         }
         if(this.mbHasOccultTypeDisplayOverrideCriteria)
         {
            _loc3_ = CommunicationManager.CallGameService("GetSimOccultType",_loc5_) as int;
         }
         if(this.mbHasTraitsDisplayOverrideCriteria)
         {
            _loc4_ = this.GetSimTraitIds({
               "simId":_loc5_,
               "groupId":0
            });
         }
         return this.GetSpecificOverride(_loc2_,_loc3_,_loc4_);
      }
      
      public function GetOverrideBySimInfo(param1:SimInfo) : TraitAppearanceOverrideData
      {
         var _loc2_:AgeUpdate = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         if(this.mbHasAgeDisplayOverrideCriteria)
         {
            _loc2_ = new AgeUpdate({
               "simId":param1.simId,
               "age":param1.age
            });
         }
         if(this.mbHasOccultTypeDisplayOverrideCriteria)
         {
            _loc3_ = param1.occultType;
         }
         if(this.mbHasTraitsDisplayOverrideCriteria)
         {
            _loc4_ = this.GetSimTraitIds({
               "simId":param1.simId,
               "groupId":0
            });
         }
         return this.GetSpecificOverride(_loc2_,_loc3_,_loc4_);
      }
      
      private function GetSimTraitIds(param1:Object) : Array
      {
         var _loc6_:Object = null;
         var _loc7_:HouseholdSimData = null;
         var _loc8_:Vector.<TraitsStaticData> = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:Boolean = false;
         var _loc13_:TraitsStaticData = null;
         var _loc2_:Array = sCASEquippedTraitIds != null ? sCASEquippedTraitIds.slice() : null;
         var _loc3_:Array = [];
         var _loc4_:Boolean = false;
         if(sLotSelectSim != null)
         {
            _loc7_ = sLotSelectSim;
            _loc8_ = _loc7_.traits;
            _loc9_ = 0;
            while(_loc9_ < _loc8_.length)
            {
               _loc3_.push(_loc8_[_loc9_].id);
               _loc9_++;
            }
            if(_loc7_.bonusTrait)
            {
               _loc3_.push(_loc7_.bonusTrait.id);
            }
            if(_loc7_.ghostTrait)
            {
               _loc3_.push(_loc7_.ghostTrait.id);
               _loc3_.push(TRAIT_IS_GHOST_TUNING);
            }
            if(_loc7_.simPreferencesData)
            {
               _loc8_ = _loc7_.simPreferencesData.AllPreferenceTraits;
               _loc9_ = 0;
               while(_loc9_ < _loc8_.length)
               {
                  _loc3_.push(_loc8_[_loc9_].id);
                  _loc9_++;
               }
            }
            return _loc3_;
         }
         var _loc5_:Array = CommunicationManager.CallGameService("GetAllSimTraitsInfo",param1) as Array;
         for each(_loc6_ in _loc5_)
         {
            if(!_loc6_.hasOwnProperty("equipped"))
            {
               _loc3_.push(_loc6_["trait_id"]);
            }
            else
            {
               _loc4_ = true;
               if(_loc6_.equipped)
               {
                  _loc3_.push(_loc6_["id"]);
               }
               if(_loc2_ != null)
               {
                  _loc10_ = _loc2_.indexOf(_loc6_["id"]);
                  if(_loc10_ >= 0)
                  {
                     _loc2_.splice(_loc10_,1);
                  }
               }
            }
         }
         if(_loc4_)
         {
            _loc11_ = CommunicationManager.CallGameService("CasGetGhostDeathTypes",param1) as Array;
            _loc12_ = false;
            for each(_loc6_ in _loc11_)
            {
               if(_loc6_.equipped)
               {
                  _loc3_.push(_loc6_["id"]);
                  _loc12_ = true;
               }
            }
            if(_loc2_ != null)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc2_.length)
               {
                  _loc13_ = GetStaticData(_loc2_[_loc9_]);
                  if((Boolean(_loc13_)) && _loc13_.type == SimTraitsInfo.TRAIT_GHOST)
                  {
                     _loc12_ = true;
                  }
                  _loc9_++;
               }
            }
            if(_loc12_)
            {
               _loc3_.push(TRAIT_IS_GHOST_TUNING);
            }
         }
         return _loc3_;
      }
      
      public function GetSpecificOverride(param1:AgeUpdate, param2:int, param3:Array) : TraitAppearanceOverrideData
      {
         var _loc6_:TraitAppearanceOverrideData = null;
         var _loc7_:Boolean = false;
         var _loc8_:TraitApperanceOverrideCriterionData = null;
         var _loc9_:String = null;
         var _loc4_:String = param1 ? new String(param1.age) : "0";
         var _loc5_:String = new String(param2);
         for each(_loc6_ in this.display_overrides)
         {
            _loc7_ = true;
            for each(_loc8_ in _loc6_.match_all)
            {
               if(_loc8_.age.length > 0 && _loc8_.age.indexOf(_loc4_) < 0)
               {
                  _loc7_ = false;
                  break;
               }
               if(_loc8_.occult_type.length > 0 && _loc8_.occult_type.indexOf(_loc5_) < 0)
               {
                  _loc7_ = false;
                  break;
               }
               if(_loc8_.traits.length > 0)
               {
                  for each(_loc9_ in _loc8_.traits)
                  {
                     if(param3.indexOf(_loc9_) < 0)
                     {
                        _loc7_ = false;
                        break;
                     }
                  }
                  if(!_loc7_)
                  {
                     break;
                  }
               }
            }
            if(_loc7_)
            {
               return _loc6_;
            }
         }
         return null;
      }
   }
}

