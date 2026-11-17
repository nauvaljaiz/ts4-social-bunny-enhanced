package olympus.objects
{
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.Gameplay.shared.SimTraitsInfo;
   import gamedata.Gameplay.shared.definitions.RelationshipTrackStaticData;
   import gamedata.Gameplay.shared.definitions.TraitsStaticData;
   import gamedata.shared.ManagerObjectId;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   
   public class RelationshipInfo extends OlympusObject
   {
      
      protected static const ENGAGED_REL_BIT_ID:* = "15816";
      
      public var relBitIcons:Array = [RelationshipBitInfo];
      
      public var simProfileTracks:Array = [RelationshipTrackInfo];
      
      public var relTracks:Array = [RelationshipTrackInfo];
      
      public var sentimentTracks:Array = [RelationshipTrackInfo];
      
      public var traitBitIcons:Array = [uint];
      
      public var nonTrackedBitIcons:Array = [RelationshipBitInfo];
      
      public var targetFirstName:String;
      
      public var targetLastName:String;
      
      public var targetPersona:String;
      
      public var targetId:String;
      
      public var targetAge:int;
      
      public var targetGender:int;
      
      public var targetSpecies:uint;
      
      public var creatureType:int;
      
      public var targetCatalogId:String;
      
      public var targetManagerId:int;
      
      public var targetIconOverride:IconInfo = new IconInfo();
      
      public var actorFirstName:String;
      
      public var actorLastName:String;
      
      public var actorId:String;
      
      public var actorSpecies:uint;
      
      public var actorPersona:String;
      
      public var relHandshakeBit:Array = [RelationshipBitInfo];
      
      public var targetSpouseId:String;
      
      public var targetFianceId:String;
      
      public var numTargetTraits:uint;
      
      public var knownCareerTrackIds:Array = [String];
      
      public var knownRelationshipTrackIds:Array = [String];
      
      public var knownMajorId:String;
      
      public var knownStatIds:Array = [String];
      
      public var knowsRomanticPreference:Boolean;
      
      public var knowsWoohooPreference:Boolean;
      
      public var knownRomanticGenders:Array = [int];
      
      public var knownWoohooGenders:Array = [int];
      
      public var knownExploringSexuality:Boolean;
      
      public var compatibilityLevel:int;
      
      public var compatibilityIcon:ResourceKey = new ResourceKey();
      
      public var compatibilitySmallIcon:ResourceKey = new ResourceKey();
      
      public var compatibilityName:LocKey = new LocKey();
      
      public var compatibilityDesc:LocKey = new LocKey();
      
      public var simSecrets:Array = [SimSecretInfo];
      
      public var relationshipLabelData:RelationshipLabelData = new RelationshipLabelData();
      
      public var knownRelationshipExpectationsIds:Array = [uint];
      
      public var hidden:Boolean = false;
      
      public var displayOrder:String;
      
      public var isTargetAlive:Boolean = true;
      
      public var hasNewSentiments:Boolean = false;
      
      public var hasNewSatisfactionValue:Boolean = false;
      
      public var targetName:String;
      
      public var targetNameWithPrefix:String;
      
      public var attractionTrack:RelationshipTrackInfo;
      
      public var satisfactionTrack:RelationshipTrackInfo;
      
      public function RelationshipInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public static function SortRelationshipTracks(param1:RelationshipTrackInfo, param2:RelationshipTrackInfo) : int
      {
         return param1.track_pop_up_priority - param2.track_pop_up_priority;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:RelationshipTrackInfo = null;
         var _loc3_:Array = null;
         var _loc4_:RelationshipTrackInfo = null;
         var _loc5_:ObjectMetadata = null;
         var _loc6_:Object = null;
         var _loc7_:CatalogProduct = null;
         if("relBitIcons" in param1)
         {
            OlympusObject.ConstructArrayFromArray(this.relBitIcons,param1.relBitIcons,RelationshipBitInfo);
         }
         if("simProfileTracks" in param1)
         {
            OlympusObject.ConstructArrayFromArray(this.simProfileTracks,param1.simProfileTracks,RelationshipTrackInfo);
         }
         if("relTracks" in param1)
         {
            OlympusObject.ConstructArrayFromArray(this.relTracks,param1.relTracks,RelationshipTrackInfo);
         }
         if("sentimentTracks" in param1)
         {
            OlympusObject.ConstructArrayFromArray(this.sentimentTracks,param1.sentimentTracks,RelationshipTrackInfo);
         }
         if("traitBitIcons" in param1)
         {
            this.traitBitIcons = param1.traitBitIcons;
         }
         if("targetFirstName" in param1)
         {
            this.targetFirstName = param1.targetFirstName;
         }
         if("targetLastName" in param1)
         {
            this.targetLastName = param1.targetLastName;
         }
         if("targetPersona" in param1)
         {
            this.targetPersona = param1.targetPersona;
         }
         if("targetId" in param1)
         {
            this.targetId = param1.targetId;
         }
         if("targetAge" in param1)
         {
            this.targetAge = param1.targetAge;
         }
         if("targetGender" in param1)
         {
            this.targetGender = param1.targetGender;
         }
         if("targetSpecies" in param1)
         {
            this.targetSpecies = param1.targetSpecies;
         }
         if("creatureType" in param1)
         {
            this.creatureType = param1.creatureType;
         }
         if("targetCatalogId" in param1)
         {
            this.targetCatalogId = param1.targetCatalogId;
         }
         if("targetManagerId" in param1)
         {
            this.targetManagerId = param1.targetManagerId;
         }
         if(!("targetIconOverride" in param1) || !param1.targetIconOverride)
         {
            this.targetIconOverride = null;
         }
         else
         {
            this.targetIconOverride.ParseObject(param1.targetIconOverride);
         }
         if("actorFirstName" in param1)
         {
            this.actorFirstName = param1.actorFirstName;
         }
         if("actorLastName" in param1)
         {
            this.actorLastName = param1.actorLastName;
         }
         if("actorId" in param1)
         {
            this.actorId = param1.actorId;
         }
         if("actorSpecies" in param1)
         {
            this.actorSpecies = param1.actorSpecies;
         }
         if("actorPersona" in param1)
         {
            this.actorPersona = param1.actorPersona;
         }
         if("relHandshakeBit" in param1)
         {
            OlympusObject.ConstructArrayFromArray(this.relHandshakeBit,param1.relHandshakeBit,RelationshipBitInfo);
         }
         if("targetSpouseId" in param1)
         {
            this.targetSpouseId = param1.targetSpouseId;
         }
         if("targetFianceId" in param1)
         {
            this.targetFianceId = param1.targetFianceId;
         }
         if("numTargetTraits" in param1)
         {
            this.numTargetTraits = param1.numTargetTraits;
         }
         if("knownCareerTrackIds" in param1)
         {
            this.knownCareerTrackIds = param1.knownCareerTrackIds;
         }
         if("knownRelTrackIds" in param1)
         {
            this.knownRelationshipTrackIds = param1.knownRelTrackIds;
         }
         if("knownMajorId" in param1)
         {
            this.knownMajorId = param1.knownMajorId;
         }
         if("knownStatIds" in param1)
         {
            this.knownStatIds = param1.knownStatIds;
         }
         if("knowsRomanticPreference" in param1)
         {
            this.knowsRomanticPreference = param1.knowsRomanticPreference;
         }
         if("knowsWoohooPreference" in param1)
         {
            this.knowsWoohooPreference = param1.knowsWoohooPreference;
         }
         if("knownRomanticGenders" in param1)
         {
            this.knownRomanticGenders = param1.knownRomanticGenders;
         }
         if("knownWoohooGenders" in param1)
         {
            this.knownWoohooGenders = param1.knownWoohooGenders;
         }
         if("knownExploringSexuality" in param1)
         {
            this.knownExploringSexuality = param1.knownExploringSexuality;
         }
         if("compatibilityLevel" in param1)
         {
            this.compatibilityLevel = param1.compatibilityLevel;
         }
         if(!("compatibilityIcon" in param1) || !param1.compatibilityIcon)
         {
            this.compatibilityIcon = null;
         }
         else
         {
            this.compatibilityIcon.ParseObject(param1.compatibilityIcon);
         }
         if(!("compatibilitySmallIcon" in param1) || !param1.compatibilitySmallIcon)
         {
            this.compatibilitySmallIcon = null;
         }
         else
         {
            this.compatibilitySmallIcon.ParseObject(param1.compatibilitySmallIcon);
         }
         if(!("compatibilityName" in param1) || !param1.compatibilityName)
         {
            this.compatibilityName = null;
         }
         else
         {
            this.compatibilityName.ParseObject(param1.compatibilityName);
         }
         if(!("compatibilityDesc" in param1) || !param1.compatibilityDesc)
         {
            this.compatibilityDesc = null;
         }
         else
         {
            this.compatibilityDesc.ParseObject(param1.compatibilityDesc);
         }
         if("simSecrets" in param1)
         {
            OlympusObject.ConstructArrayFromArray(this.simSecrets,param1.simSecrets,SimSecretInfo);
         }
         if("displayOrder" in param1)
         {
            this.displayOrder = param1.displayOrder;
         }
         if("isTargetAlive" in param1)
         {
            this.isTargetAlive = param1.isTargetAlive;
         }
         if("hasNewSentiments" in param1)
         {
            this.hasNewSentiments = param1.hasNewSentiments;
         }
         if("hasNewSatisfactionValue" in param1)
         {
            this.hasNewSatisfactionValue = param1.hasNewSatisfactionValue;
         }
         if("relationshipLabelData" in param1)
         {
            this.relationshipLabelData.ParseObject(param1.relationshipLabelData);
         }
         if("knownRelationshipExpectationsIds" in param1)
         {
            this.knownRelationshipExpectationsIds = param1.knownRelationshipExpectationsIds;
         }
         if("hidden" in param1)
         {
            this.hidden = param1.hidden;
         }
         this.nonTrackedBitIcons = this.relBitIcons;
         if(this.IsSimRelationship())
         {
            this.targetName = Keys.GENERIC_SIM_NAME.toString({"simId":this.targetId});
            this.targetNameWithPrefix = Keys.GENERIC_SIM_NAME_WITH_PREFIX.toString({"simId":this.targetId});
         }
         else if(this.IsObjectRelationship())
         {
            if(this.targetCatalogId == this.targetId)
            {
               this.targetName = Keys.GENERIC_SIM_NAME.toString({"simId":this.targetId});
               this.targetNameWithPrefix = Keys.GENERIC_SIM_NAME_WITH_PREFIX.toString({"simId":this.targetId});
            }
            else
            {
               if(Boolean(this.targetIconOverride) && Boolean(this.targetIconOverride.name) && this.targetIconOverride.name.IsValid())
               {
                  this.targetName = this.targetIconOverride.name.toString();
               }
               else
               {
                  _loc5_ = new ObjectMetadata(CommunicationManager.CallGameService("GetObjectMetadata",this.targetId));
                  if(_loc5_.custom_name)
                  {
                     this.targetName = _loc5_.custom_name;
                  }
                  else if(Boolean(this.targetCatalogId) && this.targetCatalogId != this.targetId)
                  {
                     _loc6_ = CommunicationManager.CallGameService("GetCatalogProduct",{"defId":this.targetCatalogId});
                     _loc7_ = new CatalogProduct(_loc6_);
                     this.targetName = _loc7_.Name;
                  }
                  if(_loc5_.creature_type)
                  {
                     this.creatureType = _loc5_.creature_type;
                  }
               }
               this.targetFirstName = this.targetName;
               this.targetLastName = "";
            }
         }
         FixupArray(this.traitBitIcons);
         if(!param1)
         {
            this.isTargetAlive = true;
         }
         FixupArray(this.knownCareerTrackIds);
         FixupArray(this.knownRelationshipTrackIds);
         FixupArray(this.relTracks);
         FixupArray(this.simProfileTracks);
         this.attractionTrack = null;
         this.satisfactionTrack = null;
         for each(_loc2_ in this.simProfileTracks)
         {
            if(RelationshipTrackStaticData.HasAttractionRelTrackId() && _loc2_.track_id == RelationshipTrackStaticData.AttractionRelationshipTrackId)
            {
               this.attractionTrack = _loc2_;
            }
            if(RelationshipTrackStaticData.HasSatisfactionRelTrackId() && _loc2_.track_id == RelationshipTrackStaticData.RelationshipSatisfactionTrackId)
            {
               this.satisfactionTrack = _loc2_;
            }
         }
         FixupArray(this.sentimentTracks);
         _loc3_ = [{"simId":this.actorId},{"simId":this.targetId}];
         for each(_loc4_ in this.sentimentTracks)
         {
            _loc4_.track_bit.description = _loc4_.track_bit.description.Clone(_loc3_);
            _loc4_.track_bit.name = _loc4_.track_bit.name.Clone(_loc3_);
            _loc4_.archetype_name = _loc4_.archetype_name.Clone(_loc3_);
         }
         FixupArray(this.knownRomanticGenders);
         FixupArray(this.knownWoohooGenders);
         FixupArray(this.simSecrets);
         FixupArray(this.knownRelationshipExpectationsIds);
      }
      
      public function HasBitsInRelInfo(param1:Array) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:RelationshipBitInfo = null;
         var _loc4_:RelationshipTrackInfo = null;
         for each(_loc2_ in param1)
         {
            for each(_loc3_ in this.nonTrackedBitIcons)
            {
               if(_loc3_.bitId == _loc2_ && !_loc3_.IsBitExpired())
               {
                  return true;
               }
            }
            for each(_loc4_ in this.relTracks)
            {
               if(_loc4_.track_bit.bitId == _loc2_ && !_loc3_.IsBitExpired())
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function HasNewSentiment(param1:RelationshipInfo) : Boolean
      {
         var _loc2_:RelationshipTrackInfo = null;
         var _loc3_:Boolean = false;
         var _loc4_:RelationshipTrackInfo = null;
         if(this.sentimentTracks.length > param1.sentimentTracks.length)
         {
            return true;
         }
         for each(_loc2_ in this.sentimentTracks)
         {
            _loc3_ = false;
            for each(_loc4_ in param1.sentimentTracks)
            {
               if(_loc2_.track_id == _loc4_.track_id)
               {
                  _loc3_ = true;
                  break;
               }
            }
            if(!_loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function GetKnowledgeForTraitsOfType(param1:String, param2:String = null) : Array
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:TraitsStaticData = null;
         var _loc9_:* = 0;
         if(param2 == null)
         {
            param2 = SimTraitsInfo.TRAIT_UI_CATEGORY_PERSONALITY;
         }
         var _loc3_:uint = 0;
         if(param1 == SimTraitsInfo.TRAIT_PERSONALITY)
         {
            _loc3_ = this.numTargetTraits;
         }
         else
         {
            _loc7_ = CommunicationManager.CallGameService("GetFilteredSimTraitInfo",{
               "simId":this.targetId,
               "traitType":param1,
               "uiCategory":param2
            }) as Array;
            _loc3_ = _loc7_.length;
         }
         var _loc4_:Array = new Array();
         for each(_loc5_ in this.traitBitIcons)
         {
            _loc8_ = TraitsStaticData.GetStaticData(_loc5_);
            if(_loc8_.type == param1 && _loc8_.ui_category == param2)
            {
               _loc4_.push(_loc8_);
            }
         }
         _loc6_ = int(_loc4_.length);
         if(_loc6_ > 0)
         {
            _loc9_ = int(_loc3_ - _loc6_);
            while(_loc9_-- > 0)
            {
               _loc4_.push(null);
            }
         }
         return _loc4_;
      }
      
      public function GetTraitsOfType(param1:String, param2:String) : Array
      {
         var _loc6_:TraitsStaticData = null;
         var _loc3_:Array = CommunicationManager.CallGameService("GetFilteredSimTraitInfo",{
            "simId":this.targetId,
            "traitType":param1,
            "uiCategory":param2
         }) as Array;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = TraitsStaticData.GetStaticData(_loc3_[_loc5_].trait_id);
            if(_loc6_)
            {
               _loc4_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function KnowsRelationshipTrack(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.knownRelationshipTrackIds)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function IsSimRelationship() : Boolean
      {
         return this.targetManagerId == ManagerObjectId.MGR_SIM_INFO;
      }
      
      public function IsObjectRelationship() : Boolean
      {
         return this.targetManagerId == ManagerObjectId.MGR_OBJECT;
      }
      
      public function IsEngaged() : Boolean
      {
         return this.HasBitsInRelInfo([ENGAGED_REL_BIT_ID]);
      }
      
      public function IsEngagedOrMarried() : Boolean
      {
         if(Boolean(this.targetSpouseId) && this.targetSpouseId == this.actorId)
         {
            return true;
         }
         return this.IsEngaged();
      }
      
      public function HasAttractionTrack() : Boolean
      {
         return this.attractionTrack != null;
      }
      
      public function HasSatisfactionTrack() : Boolean
      {
         return this.satisfactionTrack != null;
      }
      
      public function KnowsRelationshipExpectations() : Boolean
      {
         if(this.knownRelationshipExpectationsIds != null)
         {
            return this.knownRelationshipExpectationsIds.length > 0;
         }
         return false;
      }
   }
}

