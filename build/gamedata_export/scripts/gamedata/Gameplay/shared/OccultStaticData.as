package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class OccultStaticData extends OlympusObject
   {
      
      protected static var sOccultStaticData:Object = new Object();
      
      public var cas_add_occult_tooltip:LocKey = new LocKey();
      
      public var cas_alternative_form_add_tooltip:LocKey = new LocKey();
      
      public var cas_alternative_form_delete_tooltip:LocKey = new LocKey();
      
      public var cas_alternative_form_delete_confirmation:LocKey = new LocKey();
      
      public var cas_alternative_form_sim_name_tooltip:LocKey = new LocKey();
      
      public var cas_alternative_form_copy_tooltip:LocKey = new LocKey();
      
      public var cas_alternative_form_copy_options_heading:LocKey = new LocKey();
      
      public var cas_alternative_form_link_tooltip:LocKey = new LocKey();
      
      public var cas_disabled_while_in_alternative_form_tooltip:LocKey = new LocKey();
      
      public var cas_invalid_age_warning_body:LocKey = new LocKey();
      
      public var cas_invalid_age_warning_title:LocKey = new LocKey();
      
      public var cas_molecule_disabled_while_in_alternative_form_tooltip:LocKey = new LocKey();
      
      public var cas_base_form_copy_tooltip:LocKey = new LocKey();
      
      public var cas_base_form_link_tooltip:LocKey = new LocKey();
      
      public var cas_default_to_alternative_form:Boolean = false;
      
      public var cas_can_delete_alternative_form:Boolean = false;
      
      public var cas_selected_tooltip:LocKey = new LocKey();
      
      public function OccultStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetOccultStaticData(param1:int) : OccultStaticData
      {
         if(!sOccultStaticData[param1])
         {
            sOccultStaticData[param1] = new OccultStaticData(CommunicationManager.CallGameService("GetCASOccultStaticData",param1));
         }
         return sOccultStaticData[param1];
      }
   }
}

