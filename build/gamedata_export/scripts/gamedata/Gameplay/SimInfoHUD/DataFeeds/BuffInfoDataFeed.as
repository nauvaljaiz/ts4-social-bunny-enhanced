package gamedata.Gameplay.SimInfoHUD.DataFeeds
{
   import gamedata.Gameplay.Buffs.BuffInfo;
   import olympus.data.ArrayDataFeed;
   
   public class BuffInfoDataFeed extends ArrayDataFeed
   {
      
      public function BuffInfoDataFeed()
      {
         super();
      }
      
      public function HandleBuffUpdate(param1:BuffInfo) : void
      {
         if(!ReplaceItemByFieldName("buff_id",param1))
         {
            if(param1.update_type == BuffInfo.BUFF_UPDATE_TYPE_ADD)
            {
               AddItem(param1);
            }
         }
      }
   }
}

