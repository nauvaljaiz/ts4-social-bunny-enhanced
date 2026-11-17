package gamedata.GameTray
{
   import olympus.core.OlympusObject;
   
   public class ToggleSimInfoPanelData extends OlympusObject
   {
      
      public static const SIM_INFO_MOTIVE_PANEL:int = 0;
      
      public static const SIM_INFO_SKILL_PANEL:int = 1;
      
      public static const SIM_INFO_RELATIONSHIP_PANEL:int = 2;
      
      public static const SIM_INFO_CAREER_PANEL:int = 3;
      
      public static const SIM_INFO_INVENTORY_PANEL:int = 4;
      
      public static const SIM_INFO_ASPIRATION_PANEL:int = 5;
      
      public static const SIM_INFO_SUMMARY_PANEL:int = 6;
      
      public static const SIM_INFO_CLUB_PANEL:int = 7;
      
      public var panel_type:int;
      
      public var stay_open:Boolean;
      
      public function ToggleSimInfoPanelData(param1:Object = null)
      {
         super(param1);
      }
   }
}

