package gamedata.CAS.PlanOutfit
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class PlannedOutfitData extends OlympusObject
   {
      
      public static const BUTTON_TYPE_OUTFIT:int = 0;
      
      public static const BUTTON_TYPE_CREATE:int = 1;
      
      public static const BUTTON_TYPE_DISABLED:int = 2;
      
      public var outfit_index:int;
      
      public var outfit_type:uint;
      
      public var outfit_title:String = "";
      
      public var button_type:int = 0;
      
      public var outfit_count:uint;
      
      public var selected:Boolean;
      
      public function PlannedOutfitData(param1:Object = null)
      {
         super(param1);
      }
      
      public function get fashionInvalid() : Boolean
      {
         return CommunicationManager.CallGameService("CasIsInvalidThriftStoreOutfit",{
            "outfit_type":this.outfit_type,
            "outfit_index":this.outfit_index
         }) as Boolean;
      }
      
      public function get fashionCost() : int
      {
         return CommunicationManager.CallGameService("CasGetOutfitCost",{
            "outfit_type":this.outfit_type,
            "outfit_index":this.outfit_index
         }) as int;
      }
      
      public function get fashionTrend() : String
      {
         return CommunicationManager.CallGameService("CasGetOutfitTrend",{
            "outfit_type":this.outfit_type,
            "outfit_index":this.outfit_index
         }) as String;
      }
   }
}

