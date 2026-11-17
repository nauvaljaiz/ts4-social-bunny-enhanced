package gamedata.Gameplay.FactionReputation
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysGP;
   import widgets.Gameplay.SimInfoHUD.constants.SimInfoSummaryPanelTunables;
   
   public class FactionReputationData extends OlympusObject
   {
      
      protected static var sFactionRepData:FactionReputationData;
      
      public var firstOrderRepStat:String;
      
      public var resistanceRepStat:String;
      
      public var scoundrelRepStat:String;
      
      public function FactionReputationData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get FACTIONREPDATA() : FactionReputationData
      {
         if(!sFactionRepData)
         {
            sFactionRepData = new FactionReputationData(CommunicationManager.CallGameService("GetFactionReputationTuning"));
         }
         return sFactionRepData;
      }
      
      public function GetFactionLabel(param1:String) : String
      {
         if(param1 == this.resistanceRepStat)
         {
            return "resistance";
         }
         if(param1 == this.firstOrderRepStat)
         {
            return "firstOrder";
         }
         if(param1 == this.scoundrelRepStat)
         {
            return "scoundrel";
         }
         return null;
      }
      
      public function GetFactionTitleAndColor(param1:String) : Object
      {
         var _loc2_:* = new Object();
         switch(param1)
         {
            case this.resistanceRepStat:
               _loc2_["title"] = KeysGP.RESISTANCE_TITLE;
               _loc2_["color"] = SimInfoSummaryPanelTunables.RESISTANCE_PRIMARY_COLOR;
               return _loc2_;
            case this.firstOrderRepStat:
               _loc2_["title"] = KeysGP.FIRST_ORDER_TITLE;
               _loc2_["color"] = SimInfoSummaryPanelTunables.FIRST_ORDER_PRIMARY_COLOR;
               return _loc2_;
            case this.scoundrelRepStat:
               _loc2_["title"] = KeysGP.SCOUNDREL_TITLE;
               _loc2_["color"] = SimInfoSummaryPanelTunables.SCOUNDREL_PRIMARY_COLOR;
               return _loc2_;
            default:
               return null;
         }
      }
   }
}

