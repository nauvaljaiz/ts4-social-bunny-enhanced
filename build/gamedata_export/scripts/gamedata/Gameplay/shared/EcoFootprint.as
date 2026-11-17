package gamedata.Gameplay.shared
{
   import gamedata.GameContent;
   import gamedata.GameEntry.Neighborhood.WorldDescription;
   import gamedata.TutorialTip.TutorialMode;
   import olympus.io.CommunicationManager;
   import widgets.shared.GENeighborhoodStateManager;
   
   public class EcoFootprint
   {
      
      public static const ECO_FOOTPRINT_STATE_GREEN:uint = 0;
      
      public static const ECO_FOOTPRINT_STATE_NEUTRAL:uint = 1;
      
      public static const ECO_FOOTPRINT_STATE_INDUSTRIAL:uint = 2;
      
      public function EcoFootprint()
      {
         super();
      }
      
      public static function IsFeatureEnabledForCurrentRegion() : Boolean
      {
         return IsFeatureEnabled() && IsRegionCompatible();
      }
      
      protected static function IsRegionCompatible() : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:WorldDescription = null;
         var _loc1_:GENeighborhoodStateManager = GENeighborhoodStateManager.getInstance();
         if(_loc1_)
         {
            for each(_loc2_ in _loc1_.mWorldDescriptionIds)
            {
               _loc3_ = new WorldDescription(CommunicationManager.CallGameService("GetWorldDescription",{"worldDescriptionId":_loc2_}));
               if(Boolean(_loc3_) && _loc3_.ecoFootprintCompatible)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function IsFeatureEnabledForCurrentWorld() : Boolean
      {
         return IsFeatureEnabled() && IsWorldCompatible();
      }
      
      protected static function IsWorldCompatible() : Boolean
      {
         var _loc1_:String = GameplayStateData.CurrentWorldId;
         var _loc2_:WorldDescription = new WorldDescription(CommunicationManager.CallGameService("GetWorldDescriptionFromWorldId",{"worldId":_loc1_}));
         return _loc2_.ecoFootprintCompatible;
      }
      
      protected static function IsFeatureEnabled() : Boolean
      {
         if(!GameContent.HAS_EP09)
         {
            return false;
         }
         if(TutorialMode.IsFTUE())
         {
            return false;
         }
         if(!CommunicationManager.CallGameService("OptionsGetValue",{"name":"EcoFootprintGameplay"}))
         {
            return false;
         }
         return true;
      }
   }
}

