package olympus.core
{
   import gamedata.Gameplay.shared.GameplayStateData;
   import olympus.core.data.SettingsMap;
   import olympus.io.CommunicationManager;
   
   public class UISettings
   {
      
      protected static var sAccountSettings:SettingsMap = null;
      
      protected static var sHouseholdSettings:SettingsMap = null;
      
      protected static var sSimSettings:SettingsMap = null;
      
      protected static var sSessionSettings:SettingsMap = new SettingsMap();
      
      public function UISettings()
      {
         super();
      }
      
      public static function get AccountSettings() : SettingsMap
      {
         if(!sAccountSettings)
         {
            LoadUISettings();
         }
         if(!sAccountSettings.ActiveId)
         {
            sAccountSettings.ActiveId = CommunicationManager.CallGameService("GetLocalOriginId",null,true) as String;
         }
         return sAccountSettings;
      }
      
      public static function get HouseholdSettings() : SettingsMap
      {
         if(!sHouseholdSettings)
         {
            LoadUISettings();
         }
         if(!sHouseholdSettings.ActiveId)
         {
            sHouseholdSettings.ActiveId = GameplayStateData.ActiveHouseholdId;
         }
         return sHouseholdSettings;
      }
      
      public static function get SimSettings() : SettingsMap
      {
         if(!sSimSettings)
         {
            LoadUISettings();
         }
         if(!sSimSettings.ActiveId)
         {
            sSimSettings.ActiveId = GameplayStateData.ActiveSimId;
         }
         return sSimSettings;
      }
      
      public static function get SessionSettings() : SettingsMap
      {
         return sSessionSettings;
      }
      
      protected static function LoadUISettings() : void
      {
         sAccountSettings = new SettingsMap();
         sHouseholdSettings = new SettingsMap();
         sSimSettings = new SettingsMap();
         CommunicationManager.CallGameService("LoadUISettingsFromFile",{
            "callbackFunction":UISettings.SimSettings.ParseSettings,
            "groupName":"UISimSettings"
         });
         CommunicationManager.CallGameService("LoadUISettingsFromFile",{
            "callbackFunction":UISettings.HouseholdSettings.ParseSettings,
            "groupName":"UIHouseholdSettings"
         });
         CommunicationManager.CallGameService("LoadUISettingsFromFile",{
            "callbackFunction":UISettings.AccountSettings.ParseSettings,
            "groupName":"UIAccountSettings"
         });
      }
   }
}

