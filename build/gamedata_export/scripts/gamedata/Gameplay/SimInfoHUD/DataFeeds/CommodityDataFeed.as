package gamedata.Gameplay.SimInfoHUD.DataFeeds
{
   import gamedata.Gameplay.SimInfoHUD.CommodityProgressUpdate;
   import olympus.data.ArrayDataFeed;
   
   public class CommodityDataFeed extends ArrayDataFeed
   {
      
      public function CommodityDataFeed()
      {
         super();
      }
      
      public function HandleCommodityProgressUpdate(param1:CommodityProgressUpdate) : void
      {
         if(!ReplaceItemByFieldName("commodity_id",param1))
         {
            AddItem(param1);
         }
      }
   }
}

