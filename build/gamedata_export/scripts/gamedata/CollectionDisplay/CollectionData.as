package gamedata.CollectionDisplay
{
   public class CollectionData
   {
      
      protected var mData:Vector.<CollectionCategoryData> = new Vector.<CollectionCategoryData>();
      
      public function CollectionData(param1:Array)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super();
         if(Boolean(param1) && param1.length > 0)
         {
            _loc2_ = int(param1.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this.mData[_loc3_] = new CollectionCategoryData(param1[_loc3_]);
               _loc3_++;
            }
         }
      }
      
      public function get Data() : Vector.<CollectionCategoryData>
      {
         return this.mData;
      }
      
      public function GetCategoryData(param1:String) : CollectionCategoryData
      {
         var _loc2_:CollectionCategoryData = null;
         if(this.mData != null)
         {
            for each(_loc2_ in this.mData)
            {
               if(_loc2_.collection_id == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function GetItemData(param1:String) : CollectionItemData
      {
         var _loc2_:CollectionCategoryData = null;
         var _loc3_:Array = null;
         var _loc4_:CollectionItemData = null;
         if(this.mData != null)
         {
            for each(_loc2_ in this.mData)
            {
               _loc3_ = _loc2_.AllObjectList;
               for each(_loc4_ in _loc3_)
               {
                  if(_loc4_.definition_id == param1)
                  {
                     return _loc4_;
                  }
               }
            }
         }
         return null;
      }
   }
}

