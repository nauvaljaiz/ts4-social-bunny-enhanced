package widgets.shared.utils
{
   import gamedata.Gameplay.Business.BusinessData;
   import gamedata.Gameplay.shared.GameplayStateData;
   import olympus.io.CommunicationManager;
   
   public class BusinessUtils
   {
      
      public function BusinessUtils()
      {
         super();
      }
      
      public static function CurrentZoneHasSimBusiness(param1:int, param2:Boolean = false) : Boolean
      {
         var businessData:BusinessData = null;
         var businessType:int = param1;
         var bCheckIsOpen:Boolean = param2;
         var smallBusinessData:Array = CommunicationManager.CallGameService("GetSimBusinessDataForZone",GameplayStateData.CurrentZoneId) as Array;
         if(!smallBusinessData)
         {
            return false;
         }
         smallBusinessData = smallBusinessData.filter(function(param1:Object):Boolean
         {
            if(!param1)
            {
               return false;
            }
            businessData = new BusinessData(param1);
            return businessData.GetBusinessType() == businessType && (bCheckIsOpen ? businessData.is_open : true);
         });
         return smallBusinessData.length > 0;
      }
   }
}

