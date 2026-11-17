package widgets.shared.constants
{
   import olympus.localization.KeysGE;
   
   public final class GENeighborhoodMode
   {
      
      public static const NONE:int = -1;
      
      public static const EDIT:int = 0;
      
      public static const MOVE:int = 1;
      
      public static const PLACE_HOUSEHOLD:int = 2;
      
      public static const PLACE_BLUEPRINT:int = 3;
      
      public static const TRAVEL:int = 4;
      
      public static const VACATION:int = 5;
      
      public static const PURCHASE_VENUE:int = 6;
      
      public static const PLACE_BLUEPRINT_AND_EDIT:int = 7;
      
      public static const ECO_FOOTPRINT:int = 8;
      
      public static const CHANGE_VENUE:int = 9;
      
      public static const REINCARNATION:int = 10;
      
      public static const HUD_BUTTON_DISABLED_TOOLTIPS:Array = [null,KeysGE.NHD_NOT_AVAILABLE_WHILE_MOVING,KeysGE.NHD_NOT_AVAILABLE_WHILE_PLACING_HH,KeysGE.NHD_NOT_AVAILABLE_WHILE_PLACING_BP,KeysGE.NHD_NOT_AVAILABLE_WHILE_TRAVELING,KeysGE.NHD_NOT_AVAILABLE_WHILE_VACATIONING,KeysGE.NHD_NOT_AVAILABLE_WHILE_PURCHASING_VENUE,KeysGE.NHD_NOT_AVAILABLE_WHILE_PLACING_BP,KeysGE.NHD_NOT_AVAILABLE_WHILE_VIEWING_ECO_FOOTPRINT,null,KeysGE.NHD_NOT_AVAILABLE_WHILE_REINCARNATION];
      
      public function GENeighborhoodMode()
      {
         super();
      }
   }
}

