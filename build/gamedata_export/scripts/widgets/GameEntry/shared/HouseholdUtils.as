package widgets.GameEntry.shared
{
   import gamedata.BuildBuy.Venues.VenueInfo;
   import gamedata.Dialog.UiDialogMessage;
   import gamedata.Exchange.ExchangeData;
   import gamedata.GameContent;
   import gamedata.GameEntry.Neighborhood.HouseholdLocationStatus;
   import gamedata.GameEntry.Neighborhood.NeighborhoodLotData;
   import gamedata.GameEntry.Neighborhood.SimInfoLocationStatus;
   import gamedata.GameEntry.Neighborhood.TravelGroupData;
   import gamedata.GameEntry.shared.HouseholdData;
   import gamedata.GameEntry.shared.NeighborhoodStateData;
   import gamedata.Gameplay.Business.BusinessData;
   import gamedata.Gameplay.Pickers.UiDialogPicker;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.shared.GameplayOptionsData;
   import gamedata.shared.HouseholdSimData;
   import gamedata.shared.SimAgeTypes;
   import gamedata.shared.Species;
   import olympus.audio.Audio;
   import olympus.constants.DialogTypes;
   import olympus.constants.GameStates;
   import olympus.core.Ticker;
   import olympus.core.UISettings;
   import olympus.errors.Assert;
   import olympus.events.TickerEvent;
   import olympus.io.CommunicationManager;
   import olympus.io.TelemetryAttribute;
   import olympus.io.TelemetryManager;
   import olympus.localization.Keys;
   import olympus.localization.KeysGE;
   import olympus.localization.LocKey;
   import widgets.Dialog.constants.GenericDialogOption;
   import widgets.GameEntry.HouseholdPanel.constants.HouseholdPanelModes;
   import widgets.shared.GENeighborhoodStateManager;
   import widgets.shared.constants.GENeighborhoodMode;
   import widgets.shared.constants.HouseholdExtrema;
   import widgets.shared.constants.TransitionScreenMode;
   
   public class HouseholdUtils
   {
      
      protected static var sTravelGroupDeletionData:Object;
      
      protected static var sReincarnationData:Object;
      
      protected static var sPendingMoveHousehold:Object;
      
      protected static var sPendingMoveHouseholdLot:NeighborhoodLotData;
      
      protected static var sPendingMoveTargetLot:NeighborhoodLotData;
      
      protected static var sPendingMergeTargetHousehold:HouseholdData;
      
      protected static const LOT_REFRESH_LISTENER_CONTEXT:String = "HouseholdUtils.PendingMoveLotRefresh";
      
      protected static const LOT_REFRESH_TIMEOUT_MS:int = 500;
      
      protected static const LOT_REFRESH_MAX_RETRIES:int = 3;
      
      protected static const LOT_REFRESH_TIMEOUT_TICKER_KEY:Object = {};
      
      protected static var sPendingMoveLotRefreshRetryCount:int = 0;
      
      public function HouseholdUtils()
      {
         super();
      }
      
      protected static function HandleTravelGroupDeleted(param1:String) : void
      {
         var _loc2_:NeighborhoodLotData = null;
         var _loc3_:TravelGroupData = null;
         for each(_loc2_ in sTravelGroupDeletionData.lotDatas)
         {
            for each(_loc3_ in _loc2_.LotTravelGroups.TravelGroupDatas)
            {
               if(_loc3_.travel_group_id != param1 && _loc3_.group_type == TravelGroupData.GROUPTYPE_STAYOVER)
               {
                  CommunicationManager.CallGameService("DeleteTravelGroupData",_loc3_.travel_group_id);
                  return;
               }
            }
         }
         CommunicationManager.RemoveMessageListenerByName("TravelGroupDeleted",HandleTravelGroupDeleted,"HouseholdUtils");
         sTravelGroupDeletionData.callback(sTravelGroupDeletionData.parameters,param1);
         sTravelGroupDeletionData = null;
      }
      
      protected static function TryDestroyStayoverTravelGroup(param1:Array, param2:Object, param3:Function, param4:String) : Boolean
      {
         var _loc5_:NeighborhoodLotData = null;
         var _loc6_:TravelGroupData = null;
         for each(_loc5_ in param1)
         {
            for each(_loc6_ in _loc5_.LotTravelGroups.TravelGroupDatas)
            {
               if(_loc6_.travel_group_id != param4 && _loc6_.group_type == TravelGroupData.GROUPTYPE_STAYOVER)
               {
                  CommunicationManager.CallGameService("DeleteTravelGroupData",_loc6_.travel_group_id);
                  CommunicationManager.AddMessageListenerByName("TravelGroupDeleted",HandleTravelGroupDeleted,"HouseholdUtils");
                  sTravelGroupDeletionData = {
                     "parameters":param2,
                     "callback":param3,
                     "lotDatas":param1
                  };
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function GetTravelGroupWarning(param1:Array, param2:Array) : String
      {
         var _loc7_:HouseholdData = null;
         var _loc8_:NeighborhoodLotData = null;
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         for each(_loc7_ in param1)
         {
            if(_loc7_)
            {
               _loc4_ += NeighborhoodStateData.GetTravelGroupSimNames(_loc7_.familyId,TravelGroupData.GROUPTYPE_VACATION);
               _loc5_ += NeighborhoodStateData.GetTravelGroupSimNames(_loc7_.familyId,TravelGroupData.GROUPTYPE_STAYOVER);
               _loc6_ += NeighborhoodStateData.GetTravelGroupSimNames(_loc7_.familyId,TravelGroupData.GROUPTYPE_GETAWAY);
            }
         }
         if(_loc4_)
         {
            _loc3_ += KeysGE.VACATION_WILL_END_WARNING.toString("\n\n" + _loc4_);
         }
         if(_loc5_)
         {
            if(_loc3_)
            {
               _loc3_ += "\n";
            }
            _loc3_ += KeysGE.STAYOVER_WILL_END_GUEST_WARNING.toString("\n\n" + _loc5_);
         }
         for each(_loc8_ in param2)
         {
            if(Boolean(_loc8_) && _loc8_.LotTravelGroups.HasTravelGroupType(TravelGroupData.GROUPTYPE_STAYOVER))
            {
               if(_loc8_.OwnerData)
               {
                  if(_loc3_)
                  {
                     _loc3_ += "\n";
                  }
                  _loc3_ += KeysGE.STAYOVER_WILL_END_HOST_WARNING.toString(_loc8_.OwnerData.familyName) + "\n";
               }
            }
         }
         if(_loc6_)
         {
            if(_loc3_)
            {
               _loc3_ += "\n";
            }
            _loc3_ += KeysGE.GETAWAY_WILL_END_WARNING.toString("\n\n" + _loc6_);
         }
         return _loc3_;
      }
      
      public static function ShowDeleteDialog(param1:HouseholdData) : void
      {
         if(param1 == null)
         {
            return;
         }
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.YES_NO,
            "title":KeysGE.DETAIL_PANEL_DELETE_CONFIRMATION.toString(param1.familyName),
            "optionOneCallback":OnDeleteHousehold,
            "optionOneParams":{"household":param1},
            "closeText":Keys.GENERIC_CANCEL.toString()
         });
      }
      
      protected static function OnDeleteHousehold(param1:Object, param2:String = null) : void
      {
         var _loc3_:HouseholdData = param1.household as HouseholdData;
         if(_loc3_)
         {
            if(!_loc3_.IsHomeless)
            {
               if(TryDestroyStayoverTravelGroup(new Array(CommunicationManager.CallUIService("GetNeighborhoodLotData",_loc3_.familyLotId)),param1,OnDeleteHousehold,param2))
               {
                  return;
               }
            }
            CommunicationManager.SendUIMessage("HouseholdDeleteRequested",_loc3_.familyId);
            CommunicationManager.CallGameService("DeleteHousehold",_loc3_.familyId);
         }
      }
      
      public static function HouseholdHasNoble(param1:HouseholdData) : Boolean
      {
         var _loc2_:HouseholdSimData = null;
         var _loc3_:Boolean = false;
         if(!GameContent.HAS_EP21)
         {
            return false;
         }
         if(param1 == null || param1.familySims == null)
         {
            return false;
         }
         for each(_loc2_ in param1.familySims)
         {
            _loc3_ = CommunicationManager.CallGameService("HasKingdomData",{"sim_id":_loc2_.id}) as Boolean;
            if(_loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function MovingAffectsNoblesByRegion(param1:HouseholdData, param2:String) : Boolean
      {
         var _loc3_:HouseholdSimData = null;
         var _loc4_:Object = null;
         if(!GameContent.HAS_EP21)
         {
            return false;
         }
         if(param1 == null || param1.familySims == null)
         {
            return false;
         }
         for each(_loc3_ in param1.familySims)
         {
            _loc4_ = CommunicationManager.CallGameService("GetKingdomData",{"sim_id":_loc3_.id});
            if(_loc4_ != null && _loc4_.region_id != param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function MovingAffectsNoblesByNeighborhood(param1:Array, param2:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(!GameContent.HAS_EP21)
         {
            return false;
         }
         for each(_loc3_ in param1)
         {
            _loc4_ = CommunicationManager.CallGameService("GetKingdomData",{"sim_id":_loc3_});
            if(_loc4_ != null && _loc4_.neighborhood_id != param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function ShowEvictDialog(param1:HouseholdData, param2:NeighborhoodLotData, param3:Function = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(Boolean(param1) && Boolean(param2))
         {
            _loc4_ = GetTravelGroupWarning(new Array(param1),new Array(param2));
            _loc5_ = GetOwnedBusinessZoneIds(param1.familyId);
            _loc6_ = (Boolean(_loc5_)) && _loc5_.length > 0 ? Keys.GENERIC_NEWLINE.toString(KeysGE.RETAIL_WILL_SELL_WARNING.toString(),Keys.GENERIC_NEWLINE.toString("","")) : "";
            _loc7_ = HouseholdHasNoble(param1) ? Keys.GENERIC_NEWLINE.toString(KeysGE.EVICT_DIALOG_NOBLE_WARNING.toString(),Keys.GENERIC_NEWLINE.toString("","")) : "";
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.YES_NO,
               "title":KeysGE.EVICT_DIALOG_TITLE.toString(param1.familyName),
               "description":_loc4_ + _loc6_ + _loc7_ + KeysGE.EVICT_DIALOG_DESC.toString(),
               "options":GenericDialogOption.SMALL_TITLE,
               "optionOneText":KeysGE.EVICT_DIALOG_BUTTON.toString(),
               "optionOneCallback":OnEvictHousehold,
               "optionOneParams":{
                  "evictedLot":param2,
                  "businessLots":_loc5_
               },
               "closeText":Keys.GENERIC_CANCEL.toString(),
               "closeCallback":param3
            });
         }
      }
      
      public static function GetRetailFunds(param1:NeighborhoodLotData) : Number
      {
         var _loc2_:String = param1.venueData.venueOwnerId ? param1.venueData.venueOwnerId : param1.lotOwnerId;
         var _loc3_:Array = CommunicationManager.CallGameService("GetHouseholdRetailFunds",{
            "householdId":_loc2_,
            "zoneInstanceId":param1.zoneInstanceId
         }) as Array;
         if(!_loc3_ || _loc3_.length == 0)
         {
            _loc3_ = CommunicationManager.CallGameService("GetHouseholdRetailFundsFromFamily",{
               "householdId":_loc2_,
               "zoneInstanceId":param1.zoneInstanceId
            },true) as Array;
         }
         return Boolean(_loc3_) && _loc3_.length > 0 ? Number(_loc3_[0]) : 0;
      }
      
      public static function GetRetailValue(param1:NeighborhoodLotData) : Number
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc2_:Number = param1.IsMultiUnitBuilding || param1.venueData.IsSmallBusinessLot ? 0 : HouseholdUtils.GetRetailFunds(param1);
         if(param1.IsMultiUnitBuilding)
         {
            _loc3_ = CommunicationManager.CallGameService("GetZonesForLot",param1.zoneInstanceId) as Array;
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = CommunicationManager.CallGameService("GetNeighborhoodLotPrice",{"zoneInstanceId":_loc4_}) as Object;
               if(_loc5_)
               {
                  _loc6_ = _loc5_["lotOwnerId"] != null && _loc5_["lotOwnerId"] != "0";
                  _loc7_ = _loc6_ ? 0 : Number(_loc5_["furnishingsPrice"]);
                  _loc2_ += _loc5_["housePrice"] + _loc7_;
               }
            }
            return param1.LotPrice + _loc2_;
         }
         return param1.TotalPrice + _loc2_;
      }
      
      public static function GetSellDialogTitle(param1:NeighborhoodLotData, param2:String) : String
      {
         if(param1.IsMultiUnitBuilding)
         {
            return KeysGE.SELL_MULTI_UNIT_VENUE_DIALOG_TITLE.toString();
         }
         if(Boolean(param1.venueData) && param1.venueData.IsSmallBusinessLot)
         {
            return KeysGE.SELL_SMALL_BUSINESS_VENUE_DIALOG_TITLE.toString();
         }
         return KeysGE.SELL_VENUE_DIALOG_TITLE.toString(param1.venueData.nameKey.toString(),param2);
      }
      
      public static function GetSellDialogDesc(param1:NeighborhoodLotData, param2:Number, param3:String) : String
      {
         if(param1.IsMultiUnitBuilding)
         {
            return KeysGE.SELL_MULTI_UNIT_VENUE_DIALOG_DESC.toString(param2,param3);
         }
         if(Boolean(param1.venueData) && param1.venueData.IsSmallBusinessLot)
         {
            return KeysGE.SELL_SMALL_BUSINESS_VENUE_DIALOG_DESC.toString(param2,param3);
         }
         return KeysGE.SELL_VENUE_DIALOG_DESC.toString(param1.venueData.nameKey.toString(),param3,param2);
      }
      
      public static function ShowSellVenueDialog(param1:NeighborhoodLotData, param2:Function = null) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:String = null;
         var _loc4_:Object = CommunicationManager.CallGameService("GetFamilyInfo",param1.venueData.venueOwnerId);
         if(_loc4_)
         {
            _loc3_ = _loc4_.familyName;
         }
         var _loc5_:Number = HouseholdUtils.GetRetailValue(param1);
         CommunicationManager.SendUIMessage("ShowDialog",{
            "type":DialogTypes.YES_NO,
            "title":GetSellDialogTitle(param1,_loc3_),
            "description":GetSellDialogDesc(param1,_loc5_,_loc3_),
            "options":GenericDialogOption.SMALL_TITLE,
            "optionOneText":KeysGE.SELL_VENUE_DIALOG_BUTTON.toString(),
            "optionOneCallback":OnSellOwnedVenue,
            "optionOneParams":{"lotToSell":param1},
            "closeText":Keys.GENERIC_CANCEL.toString(),
            "closeCallback":param2
         });
      }
      
      protected static function OnEvictHousehold(param1:Object, param2:String = null) : void
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:NeighborhoodLotData = null;
         var _loc3_:Number = 0;
         var _loc4_:NeighborhoodLotData = param1["evictedLot"] as NeighborhoodLotData;
         if(_loc4_)
         {
            if(TryDestroyStayoverTravelGroup(new Array(_loc4_),param1,OnEvictHousehold,param2))
            {
               return;
            }
            _loc5_ = param1["businessLots"];
            if(_loc5_)
            {
               for each(_loc6_ in _loc5_)
               {
                  _loc7_ = CommunicationManager.CallUIService("GetNeighborhoodLotData",_loc6_) as NeighborhoodLotData;
                  if(_loc7_)
                  {
                     _loc3_ += _loc7_.TotalPrice;
                  }
               }
            }
            CommunicationManager.CallUIService("LockNeighborhoodMapTillUpdate",{"householdId":_loc4_.lotOwnerId});
            CommunicationManager.CallGameService("EvictHousehold",{
               "lotInstanceId":_loc4_.zoneInstanceId,
               "deltaFunds":(_loc3_ + _loc4_.TotalPrice).toFixed(0)
            });
            Audio.PlayAudio(Audio.GE_MOVE_IN_EVICTION);
            CommunicationManager.SendUIMessage("MapItemDeselected",_loc4_);
         }
      }
      
      protected static function OnSellOwnedVenue(param1:Object) : void
      {
         var _loc7_:Array = null;
         var _loc2_:NeighborhoodLotData = param1["lotToSell"] as NeighborhoodLotData;
         var _loc3_:Boolean = _loc2_.IsMultiUnitBuilding;
         var _loc4_:String = _loc3_ ? "SellMultiUnitVenue" : "SellOwnedVenue";
         var _loc5_:String = _loc3_ || _loc2_.venueData.IsSmallBusinessLot ? _loc2_.venueData.venueOwnerId : _loc2_.lotOwnerId;
         CommunicationManager.CallUIService("LockNeighborhoodMapTillUpdate",{"householdId":_loc5_});
         CommunicationManager.CallGameService(_loc4_,{
            "zoneInstanceId":_loc2_.zoneInstanceId,
            "deltaFunds":GetRetailValue(_loc2_).toFixed(0)
         });
         var _loc6_:uint = CommunicationManager.CallGameService("GetGameState") as uint;
         if(_loc6_ == GameStates.PLAY)
         {
            if(_loc3_)
            {
               CommunicationManager.PostServerCommand("business.finalize_multi_unit_sale",_loc2_.zoneInstanceId);
            }
            else if(_loc2_.venueData.IsSmallBusinessLot)
            {
               CommunicationManager.PostServerCommand("business.finalize_small_business_venue_sale",_loc2_.zoneInstanceId,GetRetailValue(_loc2_).toFixed(0),_loc5_);
            }
         }
         if(_loc2_.venueData.IsSmallBusinessLot)
         {
            _loc7_ = new Array();
            _loc7_.push(new TelemetryAttribute("btyp",BusinessData.SMALL_BUSINESS_TYPE));
            TelemetryManager.DispatchTelemetryEvent("GAME","BUSI","BUSS",_loc7_);
         }
      }
      
      protected static function OnMoveEvictHousehold(param1:Object) : void
      {
         var _loc2_:HouseholdData = param1["evictedHH"] as HouseholdData;
         if(_loc2_)
         {
            ShowMoveDialog(param1["movedHH"],param1["movedHHLot"],param1["targetLot"]);
         }
      }
      
      public static function ShowMergeDialog(param1:Object, param2:NeighborhoodLotData, param3:HouseholdData, param4:NeighborhoodLotData, param5:Boolean = true, param6:Boolean = false) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:String = null;
         var _loc13_:uint = 0;
         var _loc14_:Boolean = false;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:Object = null;
         if(Boolean(param1) && Boolean(param3) && Boolean(param4))
         {
            _loc7_ = param1 is HouseholdData ? (param1 as HouseholdData).GetNumSimsAndPendingBabies() : (param1 as ExchangeData).GetNumSimsWithPendingBabies();
            _loc8_ = param3.GetNumSimsAndPendingBabies();
            _loc9_ = _loc7_ + _loc8_ > HouseholdExtrema.MAX_SIMS_PER_HOUSEHOLD;
            _loc10_ = Boolean(GetHouseholdScenarioId(param1.familyId)) || Boolean(GetHouseholdScenarioId(param3.familyId));
            _loc11_ = !_loc9_ && !_loc10_;
            _loc12_ = null;
            _loc13_ = CommunicationManager.CallGameService("GetGameState") as uint;
            if(_loc13_ == GameStates.PLAY)
            {
               _loc12_ = KeysGE.MERGE_DIALOG_TOOLTIP_EVICT_DISABLED.toString();
            }
            else if(param1 is HouseholdData)
            {
               _loc12_ = (param1 as HouseholdData).ContainsAdults() ? null : KeysGE.MOVE_DIALOG_TOOLTIP_NO_ADULTS.toString();
            }
            else
            {
               _loc12_ = (param1 as ExchangeData).HouseholdContainsAdults() ? null : KeysGE.MOVE_DIALOG_TOOLTIP_NO_ADULTS.toString();
            }
            _loc14_ = _loc12_ == null;
            _loc15_ = null;
            if(_loc11_)
            {
               _loc15_ = param6 ? KeysGE.REINCARNATION_DIALOG_TOOLTIP_MERGE.toString() : KeysGE.MERGE_DIALOG_TOOLTIP_MERGE.toString();
            }
            else if(_loc9_)
            {
               _loc15_ = KeysGE.MERGE_DIALOG_TOOLTIP_MOVEIN_DISABLED.toString(param3.familyName);
            }
            else if(_loc10_)
            {
               _loc15_ = KeysGE.MERGE_DIALOG_TOOLTIP_MOVEIN_DISABLED_SCENARIO_ACTIVE.toString();
            }
            _loc16_ = null;
            if(param5)
            {
               _loc16_ = KeysGE.MERGE_DIALOG_TITLE.toString(param3.familyName);
            }
            else if(param6)
            {
               _loc16_ = KeysGE.REINCARNATION_DIALOG_TITLE.toString(param3.familyName);
            }
            else
            {
               _loc16_ = KeysGE.MERGE_NO_EVICT_DIALOG_TITLE.toString(param3.familyName);
            }
            _loc17_ = {
               "type":(param5 ? DialogTypes.THREE_BUTTON : DialogTypes.TWO_BUTTON),
               "title":_loc16_,
               "description":(param5 ? KeysGE.MERGE_DIALOG_DESC.toString() : null),
               "options":GenericDialogOption.SMALL_TITLE
            };
            if(param6)
            {
               _loc17_.optionOneText = KeysGE.REINCARNATION_DIALOG_BUTTON.toString();
               _loc17_.optionOneCallback = OnMergeAndReincarnate;
               _loc17_.optionOneParams = {
                  "mergedHH":param3,
                  "movedHH":param1,
                  "mergedHHLot":param4
               };
               _loc17_.optionOneEnabled = _loc11_;
               _loc17_.optionOneTooltipText = _loc15_;
            }
            else
            {
               _loc17_.optionOneText = KeysGE.MERGE_DIALOG_BUTTON.toString();
               _loc17_.optionOneCallback = OnMergeHousehold;
               _loc17_.optionOneParams = {
                  "mergedHH":param3,
                  "movedHH":param1,
                  "movedHHLot":param2,
                  "mergedHHLot":param4
               };
               _loc17_.optionOneEnabled = _loc11_;
               _loc17_.optionOneTooltipText = _loc15_;
            }
            if(param5)
            {
               _loc17_.optionTwoText = KeysGE.EVICT_DIALOG_BUTTON.toString();
               _loc17_.optionTwoCallback = OnMergeEvictHousehold;
               _loc17_.optionTwoParams = {
                  "evictedHH":param3,
                  "movedHH":param1,
                  "movedHHLot":param2,
                  "targetLot":param4
               };
               _loc17_.optionTwoEnabled = _loc14_;
               _loc17_.optionTwoTooltipText = _loc14_ ? KeysGE.MERGE_DIALOG_TOOLTIP_EVICT.toString() : _loc12_;
               _loc17_.optionThreeText = Keys.GENERIC_CANCEL.toString();
               _loc17_.optionThreeCallback = OnMergeCancel;
               _loc17_.closeCallback = OnMergeCancel;
            }
            else
            {
               _loc17_.optionTwoText = Keys.GENERIC_CANCEL.toString();
               _loc17_.optionTwoCallback = OnMergeCancel;
               _loc17_.closeCallback = OnMergeCancel;
            }
            CommunicationManager.SendUIMessage("MapItemSelected",param4);
            CommunicationManager.SendUIMessage("ShowDialog",_loc17_);
         }
      }
      
      protected static function OnMergeCancel(param1:Object) : void
      {
         CommunicationManager.CallUIService("HideDockTray");
      }
      
      public static function OnMergeAndReincarnate(param1:Object) : void
      {
         CommunicationManager.CallGameService("ShowStateChangeLoad",TransitionScreenMode.NHD_MAP_TO_CAS);
         CommunicationManager.AddMessageListenerByName("TransitionScreenUp",HandleTransitionScreenUp,"HouseholdUtils");
         sReincarnationData = {
            "sourceHouseholdId":param1.movedHH.familyId,
            "targetHouseholdId":param1.mergedHH.familyId,
            "targetZoneId":param1.mergedHHLot.zoneInstanceId
         };
      }
      
      protected static function HandleTransitionScreenUp(param1:Object) : void
      {
         if(param1.mode == TransitionScreenMode.NHD_MAP_TO_CAS)
         {
            CommunicationManager.RemoveMessageListenerByName("TransitionScreenUp",HandleTransitionScreenUp,"HouseholdUtils");
            CommunicationManager.CallGameService("MergeAndEditReincarnatedHousehold",sReincarnationData);
            sReincarnationData = null;
         }
      }
      
      protected static function OnMergeHousehold(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:uint = CommunicationManager.CallGameService("GetGameState") as uint;
         if(_loc2_ == GameStates.PLAY)
         {
            if(param1.mergedHH.familyId == GameplayStateData.ActiveHouseholdId)
            {
               CommunicationManager.CallGameService("ApplyHouseholdToLiveMode",{"householdId":param1.movedHH.id});
            }
            else
            {
               CommunicationManager.CallGameService("ApplyHouseholdToNeighborLot",{
                  "lotId":param1.mergedHHLot.zoneInstanceId,
                  "bMerge":true,
                  "householdId":param1.movedHH.id
               });
            }
            CommunicationManager.SendUIMessage("HideGameEntryDock");
         }
         else
         {
            _loc3_ = GetTravelGroupWarning(new Array(param1.mergedHH),new Array(param1.mergedHHLot,param1.movedHHLot));
            if(param1.movedHH is HouseholdData)
            {
               _loc3_ += Keys.GENERIC_NEWLINE.toString(KeysGE.MERGE_CONFIRM_DIALOG_DESC.toString(),"");
            }
            _loc4_ = GetHouseholdScenarioId(param1.movedHH.familyId);
            if(_loc4_)
            {
               _loc3_ += KeysGE.MERGE_CONFIRM_DIALOG_DESC_CURRENT_SCENARIO_WARNING.toString();
            }
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.YES_NO,
               "title":KeysGE.MERGE_CONFIRM_DIALOG_TITLE.toString(param1.mergedHH.familyName),
               "description":_loc3_,
               "options":GenericDialogOption.SMALL_TITLE,
               "optionOneText":KeysGE.MERGE_DIALOG_BUTTON.toString(),
               "optionOneCallback":OnMergeConfirmedHousehold,
               "optionOneParams":{
                  "mergedHH":param1.mergedHH,
                  "movedHH":param1.movedHH,
                  "movedHHLot":param1.movedHHLot,
                  "mergedHHLot":param1.mergedHHLot
               },
               "closeText":Keys.GENERIC_CANCEL.toString()
            });
         }
      }
      
      protected static function OnMergeEvictHousehold(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc2_:HouseholdData = param1["evictedHH"] as HouseholdData;
         if(_loc2_)
         {
            _loc3_ = GetTravelGroupWarning(new Array(_loc2_),new Array(param1.movedHHLot,param1.targetLot));
            _loc4_ = HouseholdHasNoble(_loc2_) ? Keys.GENERIC_NEWLINE.toString(KeysGE.EVICT_DIALOG_NOBLE_WARNING.toString(),Keys.GENERIC_NEWLINE.toString("","")) : "";
            _loc5_ = CommunicationManager.CallGameService("GetHouseholdRetailFunds",{"householdId":_loc2_.familyId}) as Array;
            if(!_loc5_ || _loc5_.length == 0)
            {
               _loc5_ = CommunicationManager.CallGameService("GetHouseholdRetailFundsFromFamily",{"householdId":_loc2_.familyId},true) as Array;
            }
            _loc6_ = Boolean(_loc5_) && _loc5_.length > 0 ? Keys.GENERIC_NEWLINE.toString(KeysGE.RETAIL_WILL_SELL_WARNING.toString(),Keys.GENERIC_NEWLINE.toString("","")) : "";
            CommunicationManager.SendUIMessage("ShowDialog",{
               "type":DialogTypes.YES_NO,
               "title":KeysGE.EVICT_DIALOG_TITLE.toString(_loc2_.familyName),
               "description":_loc3_ + _loc6_ + _loc4_ + KeysGE.EVICT_DIALOG_DESC.toString(),
               "options":GenericDialogOption.SMALL_TITLE,
               "optionOneText":KeysGE.EVICT_DIALOG_BUTTON.toString(),
               "optionOneCallback":OnMoveEvictHousehold,
               "optionOneParams":param1,
               "closeText":Keys.GENERIC_CANCEL.toString()
            });
         }
      }
      
      protected static function OnMergeConfirmedHousehold(param1:Object) : void
      {
         var _loc2_:HouseholdData = param1["mergedHH"] as HouseholdData;
         var _loc3_:NeighborhoodLotData = param1["mergedHHLot"] as NeighborhoodLotData;
         var _loc4_:Object = param1["movedHH"];
         var _loc5_:NeighborhoodLotData = param1["movedHHLot"] as NeighborhoodLotData;
         if(Boolean(_loc2_) && Boolean(_loc4_) && Boolean(_loc3_))
         {
            ShowMovePanelAfterTargetLotRefresh(_loc4_,_loc5_,_loc3_,_loc2_);
         }
      }
      
      public static function ShowMoveDialog(param1:Object, param2:NeighborhoodLotData, param3:NeighborhoodLotData) : void
      {
         ShowMovePanelAfterTargetLotRefresh(param1,param2,param3);
      }
      
      public static function ShowPurchaseVenueDialog(param1:HouseholdData, param2:NeighborhoodLotData, param3:VenueInfo, param4:NeighborhoodLotData, param5:String) : void
      {
         if(Boolean(param1 && param2 && param3) && Boolean(param4) && Boolean(param5))
         {
            CommunicationManager.SendUIMessage("ShowGameEntryMovePanel",{
               "household":param1,
               "lot":param2,
               "purchaseVenueInfo":param3,
               "householdLot":param4,
               "actorSimId":param5
            });
         }
      }
      
      public static function ShowPlaceBlueprintDialog(param1:ExchangeData, param2:NeighborhoodLotData) : void
      {
         CommunicationManager.SendUIMessage("ShowGameEntryMovePanel",{
            "blueprint":param1,
            "targetLot":param2
         });
      }
      
      public static function GoToBuildMode(param1:NeighborhoodLotData, param2:String, param3:String = null, param4:Boolean = false) : void
      {
         var _loc5_:String = "0";
         if(param1.mLotType == NeighborhoodLotData.MY_PLAYABLE_LOT || param1.mLotType == NeighborhoodLotData.VENUE_OWNED || param1.mLotType == NeighborhoodLotData.VENUE_OWNED_INCOMPLETE)
         {
            _loc5_ = param1.lotOwnerId;
         }
         else if(param1.mLotType == NeighborhoodLotData.VACANT_LOT && Boolean(param1.venueData.venueOwnerId))
         {
            _loc5_ = param1.venueData.venueOwnerId;
         }
         UISettings.SessionSettings.SetValue("world.lastSelectedNeighborhoodId",param2,"lotselect");
         if(param4)
         {
            UISettings.SessionSettings.SetValue("world.showConstructedLotAnimation",param1.zoneInstanceId,"lotselect");
         }
         CommunicationManager.CallGameService("EditLotInBuildBuy",{
            "householdId":_loc5_,
            "lotInstanceId":param1.zoneInstanceId,
            "venueKey":param3,
            "resumeToNhd":param4
         });
      }
      
      public static function FilterBabiesAndSort(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:uint = param1.length;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = param1[_loc5_];
            _loc6_ = int(_loc3_.age);
            if(_loc6_ != SimAgeTypes.BABY)
            {
               _loc7_ = 0;
               _loc8_ = int(_loc4_.length);
               while(_loc7_ < _loc8_)
               {
                  if(HouseholdSimSortFunction(_loc3_,_loc4_[_loc7_]) <= 0)
                  {
                     _loc4_.splice(_loc7_,0,_loc3_);
                     break;
                  }
                  _loc7_++;
               }
               if(_loc7_ == _loc8_)
               {
                  _loc4_.push(_loc3_);
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function HouseholdSimSortFunction(param1:Object, param2:Object) : int
      {
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc3_:Boolean = Species.IsPet(param1.species);
         var _loc4_:Boolean = Species.IsPet(param2.species);
         var _loc5_:Boolean = Species.IsHorse(param1.species);
         var _loc6_:Boolean = Species.IsHorse(param2.species);
         var _loc7_:Boolean = SimAgeTypes.IsChildOrYounger(param1.age);
         var _loc8_:Boolean = SimAgeTypes.IsChildOrYounger(param2.age);
         var _loc9_:Boolean = _loc7_ && _loc5_;
         var _loc10_:Boolean = _loc8_ && _loc6_;
         if(_loc9_ != _loc10_)
         {
            _loc17_ = Species.IsHuman(param1.species);
            _loc18_ = Species.IsHuman(param2.species);
            if(Boolean(_loc9_) && (Boolean(_loc4_ && _loc6_ == false || _loc8_ && _loc18_)) || Boolean(_loc10_) && (Boolean(_loc7_ == false && _loc17_)))
            {
               return -1;
            }
            if(Boolean(_loc9_) && (Boolean(_loc8_ == false && _loc18_)) || Boolean(_loc10_) && (Boolean(_loc3_ && _loc5_ == false || _loc7_ && _loc17_)))
            {
               return 1;
            }
         }
         var _loc11_:Boolean = _loc3_ && _loc7_ && _loc5_ == false;
         var _loc12_:Boolean = _loc4_ && _loc8_ && _loc6_ == false;
         if(_loc11_ != _loc12_)
         {
            return _loc12_ ? -1 : 1;
         }
         var _loc13_:int = Species.GetSpeciesSortPriority(param1.species);
         var _loc14_:int = Species.GetSpeciesSortPriority(param2.species);
         if(_loc13_ != _loc14_)
         {
            return _loc13_ - _loc14_;
         }
         var _loc15_:uint = uint(param1.age);
         var _loc16_:uint = uint(param2.age);
         return SimAgeTypes.CompareAges(_loc16_,_loc15_);
      }
      
      public static function ShowSimPicker(param1:Array, param2:LocKey, param3:Boolean = false, param4:String = "", param5:String = "0", param6:Array = null, param7:Array = null, param8:Boolean = true) : void
      {
         var _loc9_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc17_:uint = 0;
         var _loc18_:Boolean = false;
         var _loc23_:HouseholdSimData = null;
         var _loc24_:Boolean = false;
         var _loc25_:Boolean = false;
         var _loc26_:Boolean = false;
         var _loc27_:NeighborhoodLotData = null;
         _loc9_ = GENeighborhoodStateManager.getInstance().Mode;
         var _loc10_:Boolean = _loc9_ == GENeighborhoodMode.TRAVEL || _loc9_ == GENeighborhoodMode.CHANGE_VENUE;
         var _loc11_:Array = new Array();
         var _loc14_:Object = new Object();
         var _loc15_:int = 0;
         var _loc16_:int = int(param1.length);
         while(_loc15_ < _loc16_)
         {
            _loc23_ = param1[_loc15_] as HouseholdSimData;
            if(!SimAgeTypes.IsBaby(_loc23_.age))
            {
               if(!(!_loc10_ && Species.IsPet(_loc23_.species)))
               {
                  _loc24_ = _loc23_.id == param5 && (Boolean(param5) && param5 != "0");
                  if(!((_loc24_) && _loc10_ && _loc23_.bCanTravel))
                  {
                     _loc25_ = _loc10_ ? _loc23_.bCanTravel : true;
                     if(Boolean(param6) && !SimAgeTypes.IsTeenOrOlder(_loc23_.age))
                     {
                        _loc26_ = param6.indexOf(_loc23_.currentLotId) >= 0;
                        _loc25_ &&= _loc26_;
                     }
                     _loc12_ = {
                        "option_id":_loc23_.id,
                        "is_enable":_loc25_,
                        "disabledTooltip":(_loc25_ ? null : param4)
                     };
                     _loc13_ = {
                        "sim_id":_loc23_.id,
                        "select_default":param7 && param7.indexOf(_loc23_.id) != -1,
                        "base_data":_loc12_
                     };
                     if(param3)
                     {
                        _loc27_ = CommunicationManager.CallUIService("GetNeighborhoodLotData",_loc23_.currentLotId) as NeighborhoodLotData;
                        _loc13_.SimLocation = _loc27_ ? _loc27_.lotName : KeysGE.PLAY_SIM_PICKER_SECRET_LOT_NAME.toString();
                     }
                     _loc11_.push(_loc13_);
                  }
               }
            }
            _loc15_++;
         }
         _loc17_ = CommunicationManager.CallGameService("GetGameState") as uint;
         _loc18_ = _loc17_ == GameStates.TRAVEL;
         var _loc19_:int = _loc18_ ? UiDialogPicker.OBJECTPICKERTYPE_SIM_TRAVEL_LIVE : UiDialogPicker.OBJECTPICKERTYPE_SIM_TRAVEL;
         _loc14_.row_data = _loc11_;
         var _loc20_:int = _loc18_ ? 0 : 1;
         _loc14_.should_show_names = true;
         var _loc21_:Object = {
            "type":_loc19_,
            "sim_picker_data":_loc14_,
            "title":param2,
            "owner_sim_id":param5,
            "max_selectable":(!param8 ? 1 : (_loc18_ ? HouseholdExtrema.MAX_SIMS_PER_HOUSEHOLD - 1 : HouseholdExtrema.MAX_SIMS_PER_HOUSEHOLD)),
            "min_selectable":_loc20_
         };
         var _loc22_:Object = {
            "dialog_type":UiDialogMessage.TYPE_OBJECT_PICKER,
            "text":(_loc18_ ? KeysGE.TRAVEL_SIM_PICKER_SUBTITLE : null),
            "picker_data":_loc21_
         };
         CommunicationManager.SendUIMessage("UiDialogMessage",_loc22_);
      }
      
      public static function UpdateLotOwnerData(param1:NeighborhoodLotData, param2:HouseholdLocationStatus, param3:Boolean = false) : void
      {
         var _loc5_:HouseholdSimData = null;
         var _loc6_:SimInfoLocationStatus = null;
         var _loc7_:int = 0;
         var _loc4_:HouseholdData = param1.OwnerData;
         if(!_loc4_)
         {
            if(param3)
            {
               param1.UpdateOwner(param2.household_id);
               _loc4_ = param1.OwnerData;
            }
         }
         if(!_loc4_)
         {
            throw new Assert("A household has been moved in through gameplay but the Neighborhood data has not been updated correctly.                     LotOwnerInfo is null but HouseholdLocationStatus indicates that household " + param2.household_name + " lives in zone " + param1.lotName + ". Send to Gameplay or Client Systems to investigate.");
         }
         _loc4_.isNPC = !param2.is_played;
         _loc4_.familyName = param2.household_name;
         if(!_loc4_.familySims)
         {
            _loc4_.familySims = new Array();
         }
         for each(_loc6_ in param2.sim_info_status)
         {
            _loc7_ = _loc4_.FamilySimIds.indexOf(_loc6_.sim_id);
            if(_loc7_ == -1)
            {
               _loc5_ = new HouseholdSimData(CommunicationManager.CallGameService("GetSimStatInfo",_loc6_.sim_id));
               _loc5_.householdId = param2.household_id;
               _loc4_.familySims.push(_loc5_);
            }
            else
            {
               _loc5_ = _loc4_.familySims[_loc7_];
            }
            _loc5_.id = _loc6_.sim_id;
            _loc5_.age = _loc6_.age;
            _loc5_.bAtHome = _loc6_.is_at_home;
            _loc5_.currentLotId = _loc6_.zone_id;
         }
      }
      
      public static function IsTravelingWithNonHouseholdSims(param1:HouseholdData, param2:Array) : Boolean
      {
         var _loc4_:String = null;
         var _loc3_:Array = param1.FamilySimIds;
         for each(_loc4_ in param2)
         {
            if(_loc4_ != null && _loc3_.indexOf(_loc4_) == -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function GetOwnedBusinessZoneIds(param1:String) : Array
      {
         var _loc2_:Array = CommunicationManager.CallGameService("GetHouseholdBusinessLots",{"householdId":param1}) as Array;
         if(!_loc2_ || _loc2_.length == 0)
         {
            _loc2_ = CommunicationManager.CallGameService("GetHouseholdRetailLotsFromFamily",{"householdId":param1}) as Array;
         }
         return _loc2_;
      }
      
      public static function GetOwnedSmallBusinessZoneIds(param1:String) : Array
      {
         return CommunicationManager.CallGameService("GetHouseholdSmallBusinessLots",{"householdId":param1}) as Array;
      }
      
      public static function IsSimCountOverCap() : Boolean
      {
         var _loc1_:int = int(CommunicationManager.CallGameService("OptionsGetValue",{"name":GameplayOptionsData.MAX_SIM_COUNT_NAME}) as uint);
         var _loc2_:uint = uint(GameplayOptionsData.GetMaxProtectedSimsValueForIndex(_loc1_));
         if(_loc2_ == 0)
         {
            return false;
         }
         var _loc3_:uint = CommunicationManager.CallGameService("GetPlayerSimCount") as uint;
         return _loc3_ >= _loc2_;
      }
      
      public static function ShowHouseholdCapPanelIfAboveLimit(param1:Array = null) : Boolean
      {
         var _loc2_:Boolean = IsSimCountOverCap();
         if(_loc2_)
         {
            CommunicationManager.SendUIMessage("ShowGameEntryHouseholdPanel",{
               "mode":HouseholdPanelModes.MODE_CAP,
               "disabledHHIds":param1
            });
            return true;
         }
         return false;
      }
      
      public static function GetHouseholdScenarioId(param1:String) : String
      {
         var _loc2_:String = CommunicationManager.CallGameService("GetScenarioOnHousehold",param1) as String;
         return _loc2_ != "0" ? _loc2_ : null;
      }
      
      protected static function GetFreshNeighborhoodLotData(param1:NeighborhoodLotData) : NeighborhoodLotData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:Object = CommunicationManager.CallGameService("GetNeighborhoodLotData",param1.zoneInstanceId);
         return _loc2_ ? new NeighborhoodLotData(_loc2_) : null;
      }
      
      protected static function ClearPendingMoveLotRefresh() : void
      {
         Ticker.Remove(LOT_REFRESH_TIMEOUT_TICKER_KEY);
         sPendingMoveHousehold = null;
         sPendingMoveHouseholdLot = null;
         sPendingMoveTargetLot = null;
         sPendingMergeTargetHousehold = null;
         sPendingMoveLotRefreshRetryCount = 0;
      }
      
      protected static function OpenPendingMovePanel(param1:NeighborhoodLotData) : void
      {
         var _loc2_:Object = null;
         if(Boolean(sPendingMoveHousehold) && Boolean(param1))
         {
            _loc2_ = {
               "household":sPendingMoveHousehold,
               "lot":param1,
               "householdLot":sPendingMoveHouseholdLot
            };
            if(sPendingMergeTargetHousehold)
            {
               _loc2_.mergeTargetHousehold = sPendingMergeTargetHousehold;
            }
            if(sPendingMoveTargetLot)
            {
               CommunicationManager.SendUIMessage("MapItemDeselected",sPendingMoveTargetLot);
            }
            CommunicationManager.CallUIService("HideDockTray");
            CommunicationManager.SendUIMessage("ShowGameEntryMovePanel",_loc2_);
         }
      }
      
      protected static function OnPendingMoveLotRefreshTimeout(param1:TickerEvent = null) : void
      {
         if(!sPendingMoveTargetLot)
         {
            ClearPendingMoveLotRefresh();
            return;
         }
         if(sPendingMoveLotRefreshRetryCount < LOT_REFRESH_MAX_RETRIES)
         {
            ++sPendingMoveLotRefreshRetryCount;
            StartPendingMoveLotRefreshFallback();
            CommunicationManager.CallGameService("RequestNeighborhoodZoneDataUpdate",sPendingMoveTargetLot.zoneInstanceId);
            return;
         }
         CommunicationManager.RemoveMessageListenerByName("LotUpdated",OnPendingMoveLotUpdated,LOT_REFRESH_LISTENER_CONTEXT);
         ClearPendingMoveLotRefresh();
      }
      
      protected static function OnPendingMoveLotUpdated(param1:Object) : void
      {
         if(!sPendingMoveTargetLot)
         {
            return;
         }
         var _loc2_:NeighborhoodLotData = new NeighborhoodLotData(param1);
         if(!_loc2_ || _loc2_.zoneInstanceId != sPendingMoveTargetLot.zoneInstanceId)
         {
            return;
         }
         CommunicationManager.RemoveMessageListenerByName("LotUpdated",OnPendingMoveLotUpdated,LOT_REFRESH_LISTENER_CONTEXT);
         var _loc3_:NeighborhoodLotData = GetFreshNeighborhoodLotData(sPendingMoveTargetLot);
         OpenPendingMovePanel(_loc3_ ? _loc3_ : _loc2_);
         ClearPendingMoveLotRefresh();
      }
      
      protected static function ShowMovePanelAfterTargetLotRefresh(param1:Object, param2:NeighborhoodLotData, param3:NeighborhoodLotData, param4:HouseholdData = null) : void
      {
         if(!param1 || !param3)
         {
            return;
         }
         CommunicationManager.RemoveMessageListenerByName("LotUpdated",OnPendingMoveLotUpdated,LOT_REFRESH_LISTENER_CONTEXT);
         Ticker.Remove(LOT_REFRESH_TIMEOUT_TICKER_KEY);
         sPendingMoveHousehold = param1;
         sPendingMoveHouseholdLot = param2;
         sPendingMoveTargetLot = param3;
         sPendingMergeTargetHousehold = param4;
         CommunicationManager.AddMessageListenerByName("LotUpdated",OnPendingMoveLotUpdated,LOT_REFRESH_LISTENER_CONTEXT);
         sPendingMoveLotRefreshRetryCount = 0;
         StartPendingMoveLotRefreshFallback();
         CommunicationManager.CallGameService("RequestNeighborhoodZoneDataUpdate",param3.zoneInstanceId);
      }
      
      protected static function StartPendingMoveLotRefreshFallback() : void
      {
         Ticker.Remove(LOT_REFRESH_TIMEOUT_TICKER_KEY);
         Ticker.Add(LOT_REFRESH_TIMEOUT_TICKER_KEY,LOT_REFRESH_TIMEOUT_MS,OnPendingMoveLotRefreshTimeout,false,false);
      }
   }
}

