package gamedata.Gameplay.shared
{
   import olympus.objects.IconInfo;
   import olympus.resources.IImageContainer;
   
   public class InventorySlotInfo
   {
      
      public var itemInfo:InventoryItemInfo;
      
      public var isUsed:Boolean;
      
      protected var mbDisableLiveDrag:Boolean;
      
      public function InventorySlotInfo(param1:InventoryItemInfo)
      {
         super();
         this.itemInfo = param1;
         this.isUsed = true;
      }
      
      public function set DisableLiveDrag(param1:Boolean) : void
      {
         this.mbDisableLiveDrag = param1;
      }
      
      public function get DisableLiveDrag() : Boolean
      {
         return this.mbDisableLiveDrag;
      }
      
      public function get IsLocked() : Boolean
      {
         return this.itemInfo ? this.itemInfo.isLocked : false;
      }
      
      public function get ObjectId() : String
      {
         return this.itemInfo ? this.itemInfo.object_id : null;
      }
      
      public function get Icon() : IconInfo
      {
         if(Boolean(this.itemInfo) && Boolean(this.itemInfo.icon_info))
         {
            return this.itemInfo.icon_info;
         }
         return null;
      }
      
      public function get Name() : String
      {
         if(this.itemInfo)
         {
            return this.itemInfo.Name;
         }
         return "";
      }
      
      public function get Count() : uint
      {
         if(this.itemInfo)
         {
            return this.itemInfo.count;
         }
         return 0;
      }
      
      public function get IsNew() : Boolean
      {
         return this.itemInfo ? this.itemInfo.is_new : false;
      }
      
      public function get IsSellDisabled() : Boolean
      {
         return this.itemInfo.is_sell_disabled || this.itemInfo.is_sell_disabled_from_component;
      }
      
      public function LoadThumbnail(param1:IImageContainer, param2:String = null) : void
      {
         if(this.itemInfo)
         {
            this.itemInfo.LoadThumbnail(param1,param2);
         }
      }
   }
}

