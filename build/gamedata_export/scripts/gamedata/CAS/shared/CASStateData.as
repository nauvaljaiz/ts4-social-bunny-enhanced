package gamedata.CAS.shared
{
   import gamedata.CAS.GenderOptions.GenderOptionsList;
   import gamedata.CAS.Relationships.CASSimRomanceTropesStaticData;
   import gamedata.CAS.Relationships.CASSimTropesStaticData;
   import gamedata.shared.OccultTypes;
   import olympus.constants.GameStates;
   import olympus.io.CommunicationManager;
   
   public class CASStateData
   {
      
      public static var sIsFullEditingEnabled:Object;
      
      public static var sSimInfo:SimInfo;
      
      public static var sSimTropeData:CASSimTropesStaticData;
      
      public static var sSimRomanceTropeData:CASSimRomanceTropesStaticData;
      
      protected static var sSelectedGhostTrait:String;
      
      protected static const CAS_STATE_DATA_STRING:String = "CASStateData";
      
      public static var sCASSubState:uint = 0;
      
      public static var sbGhostToggleState:Boolean = false;
      
      public static var sbWingToggleState:Boolean = true;
      
      protected static var sbTattooMode:Boolean = false;
      
      protected static var sbPetPaintMode:Boolean = false;
      
      public function CASStateData()
      {
         super();
      }
      
      public static function AddListeners(param1:CommunicationManager) : void
      {
         param1.AddMessageListener("GameStateChanged",HandleGameStateChanged,CAS_STATE_DATA_STRING);
         param1.AddMessageListener("CASSetSubState",HandleCASSetSubState,CAS_STATE_DATA_STRING);
      }
      
      public static function get IsFullEditingEnabled() : Boolean
      {
         if(sIsFullEditingEnabled == null)
         {
            sIsFullEditingEnabled = CommunicationManager.CallGameService("CasIsFullEditingEnabled") as Boolean;
         }
         return Boolean(sIsFullEditingEnabled);
      }
      
      public static function set TattooMode(param1:Boolean) : void
      {
         if(sbTattooMode != param1)
         {
            sbTattooMode = param1;
            CommunicationManager.CallGameService("CasEnableTattooMode",sbTattooMode || sbPetPaintMode);
         }
      }
      
      public static function set PetPaintMode(param1:Boolean) : void
      {
         var _loc2_:Boolean = sSimInfo.occultType == OccultTypes.OCCULT_FAIRY && sSimInfo.IsOccultAlternateForm();
         param1 &&= !_loc2_;
         if(sbPetPaintMode != param1)
         {
            sbPetPaintMode = param1;
            CommunicationManager.CallGameService("CasEnableTattooMode",sbTattooMode || sbPetPaintMode);
         }
      }
      
      public static function set SelectedGhostTrait(param1:String) : void
      {
         if(param1)
         {
            sSelectedGhostTrait = param1;
         }
         else
         {
            sSelectedGhostTrait = null;
         }
      }
      
      public static function get SelectedGhostTrait() : String
      {
         return sSelectedGhostTrait;
      }
      
      public static function GetCurrentSimInfo(param1:Boolean = false) : SimInfo
      {
         if(!sSimInfo || param1)
         {
            sSimInfo = new SimInfo(CommunicationManager.CallGameService("CASGetSimInfo"));
         }
         return sSimInfo;
      }
      
      public static function get SimTropeData() : CASSimTropesStaticData
      {
         if(!sSimTropeData)
         {
            sSimTropeData = new CASSimTropesStaticData(CommunicationManager.CallGameService("GetTropesTuning"));
         }
         return sSimTropeData;
      }
      
      public static function get TattooMode() : Boolean
      {
         return sbTattooMode;
      }
      
      public static function get SimRomanceTropeData() : CASSimRomanceTropesStaticData
      {
         if(!sSimRomanceTropeData)
         {
            sSimRomanceTropeData = new CASSimRomanceTropesStaticData(CommunicationManager.CallGameService("GetTropesTuning"));
         }
         return sSimRomanceTropeData;
      }
      
      public static function GetGenderOptionsData() : GenderOptionsList
      {
         return new GenderOptionsList(CommunicationManager.CallGameService("CasGetGenderOptionsData"));
      }
      
      public static function set GhostToggleState(param1:Boolean) : void
      {
         if(!sSimInfo.isGhost)
         {
            sbGhostToggleState = false;
            return;
         }
         sbGhostToggleState = param1;
      }
      
      public static function get GhostToggleState() : Boolean
      {
         return sbGhostToggleState;
      }
      
      public static function set WingToggleState(param1:Boolean) : void
      {
         if(sSimInfo.occultType != OccultTypes.OCCULT_FAIRY)
         {
            sbWingToggleState = true;
            return;
         }
         sbWingToggleState = param1;
      }
      
      public static function get WingToggleState() : Boolean
      {
         return sbWingToggleState;
      }
      
      protected static function HandleGameStateChanged(param1:uint) : void
      {
         sIsFullEditingEnabled = null;
         sSimInfo = null;
         sSimTropeData = null;
         sSimRomanceTropeData = null;
         sSelectedGhostTrait = null;
         sbGhostToggleState = false;
         sbWingToggleState = true;
         sbTattooMode = false;
         sbPetPaintMode = false;
         CASConfiguration.ResetConfiguration();
         if(param1 == GameStates.CAS)
         {
            CASConfiguration.DetermineConfiguration();
            SimTropeData.SetupRelationshipTypeToTropesMap();
            SimRomanceTropeData.SetupRelationshipTypeToTropesMap();
            sCASSubState = 0;
         }
      }
      
      protected static function HandleCASSetSubState(param1:uint) : void
      {
         SetCASSubState(param1);
      }
      
      public static function SetCASSubState(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(sCASSubState != param1)
         {
            _loc2_ = sCASSubState;
            sCASSubState = param1;
            CommunicationManager.SendUIMessage("CASSubStateChanged",{
               "prevState":_loc2_,
               "newState":param1
            });
         }
      }
      
      public static function GetCASSubState() : uint
      {
         return sCASSubState;
      }
      
      public static function SimIdIsReincarnating(param1:String) : Boolean
      {
         var _loc2_:Object = null;
         if(CASConfiguration.IsReincarnationMode)
         {
            _loc2_ = CommunicationManager.CallGameService("CASGetSimInfo",param1);
            return Boolean(_loc2_) && Boolean(_loc2_.isCASReincarnating);
         }
         return false;
      }
   }
}

