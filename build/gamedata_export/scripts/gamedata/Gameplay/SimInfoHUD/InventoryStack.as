package gamedata.Gameplay.SimInfoHUD
{
   import gamedata.Gameplay.shared.InventoryItemInfo;
   import gamedata.Gameplay.shared.InventorySlotInfo;
   import olympus.io.CommunicationManager;
   import olympus.objects.IconInfo;
   
   public class InventoryStack
   {
      
      protected var mStackId:String;
      
      protected var mNumItemsInStack:int;
      
      protected var mTotalValueOfItemsInStack:int;
      
      protected var mItems:Vector.<InventorySlotInfo>;
      
      protected var mStackIconInfo:IconInfo;
      
      protected var mbDisableLiveDrag:Boolean;
      
      protected var mbHasPartialSelections:Boolean;
      
      protected var mbFavorited:Boolean = false;
      
      public function InventoryStack()
      {
         super();
         this.mItems = new Vector.<InventorySlotInfo>();
      }
      
      public static function ItemsSortingFunction(param1:InventorySlotInfo, param2:InventorySlotInfo) : Number
      {
         return param1.itemInfo.sort_order - param2.itemInfo.sort_order;
      }
      
      public static function GetIndexInStack(param1:String, param2:InventoryStack) : int
      {
         var _loc6_:InventorySlotInfo = null;
         var _loc3_:Vector.<InventorySlotInfo> = param2.Items;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(!_loc6_.isUsed)
            {
               return -1;
            }
            if(_loc6_.ObjectId == param1)
            {
               return _loc5_;
            }
            _loc5_++;
         }
         return -1;
      }
      
      public static function GetInventoryStacks(param1:String, param2:int) : Object
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:IconInfo = null;
         var _loc8_:Boolean = false;
         var _loc9_:InventoryStack = null;
         var _loc10_:String = null;
         var _loc11_:InventoryItemInfo = null;
         var _loc12_:Object = null;
         var _loc15_:int = 0;
         var _loc3_:Array = CommunicationManager.CallGameService("GetInventoryStacks",{
            "inventoryId":param1,
            "inventoryType":param2
         },true) as Array;
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Object = new Object();
         var _loc13_:int = int(_loc3_.length);
         var _loc14_:int = 0;
         while(_loc14_ < _loc13_)
         {
            _loc5_ = _loc3_[_loc14_].items as Array;
            _loc6_ = int(_loc5_.length);
            if(_loc6_ != 0)
            {
               _loc7_ = null;
               _loc8_ = false;
               if("stack_options" in _loc3_[_loc14_])
               {
                  _loc12_ = _loc3_[_loc14_].stack_options;
                  if("is_favorite" in _loc12_)
                  {
                     _loc8_ = Boolean(_loc12_.is_favorite);
                  }
                  if("icon_info" in _loc12_)
                  {
                     _loc7_ = new IconInfo(_loc12_.icon_info);
                  }
               }
               _loc9_ = new InventoryStack();
               _loc15_ = 0;
               while(_loc15_ < _loc6_)
               {
                  _loc11_ = new InventoryItemInfo(_loc5_[_loc15_]);
                  _loc9_.AddItem(new InventorySlotInfo(_loc11_));
                  _loc10_ = _loc11_.stack_id;
                  _loc15_++;
               }
               _loc9_.StackIconInfo = _loc7_;
               _loc9_.StackId = _loc10_;
               _loc9_.IsFavorite = _loc8_;
               _loc4_[_loc10_] = _loc9_;
            }
            _loc14_++;
         }
         return _loc4_;
      }
      
      public function set DisableLiveDrag(param1:Boolean) : void
      {
         this.mbDisableLiveDrag = param1;
      }
      
      public function get DisableLiveDrag() : Boolean
      {
         return this.mbDisableLiveDrag;
      }
      
      public function set HasPartialSelections(param1:Boolean) : void
      {
         this.mbHasPartialSelections = param1;
      }
      
      public function get HasPartialSelections() : Boolean
      {
         return this.mbHasPartialSelections;
      }
      
      public function get StackId() : String
      {
         return this.mStackId;
      }
      
      public function set StackId(param1:String) : void
      {
         this.mStackId = param1;
      }
      
      public function get StackIconInfo() : IconInfo
      {
         return this.mStackIconInfo;
      }
      
      public function set StackIconInfo(param1:IconInfo) : void
      {
         this.mStackIconInfo = param1;
      }
      
      public function get NumItems() : int
      {
         return this.mNumItemsInStack;
      }
      
      public function get TotalValue() : int
      {
         return this.mTotalValueOfItemsInStack;
      }
      
      public function get IsFavorite() : Boolean
      {
         return this.mbFavorited;
      }
      
      public function set IsFavorite(param1:Boolean) : void
      {
         this.mbFavorited = param1;
      }
      
      public function get IsSellDisabled() : Boolean
      {
         var _loc1_:InventorySlotInfo = null;
         for each(_loc1_ in this.mItems)
         {
            if(_loc1_.IsSellDisabled)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get Items() : Vector.<InventorySlotInfo>
      {
         return this.mItems;
      }
      
      public function get TopItem() : InventorySlotInfo
      {
         if(!this.mItems || this.mItems.length == 0)
         {
            return null;
         }
         return this.mItems[0];
      }
      
      public function get ClickItem() : InventorySlotInfo
      {
         if(!this.mStackIconInfo)
         {
            return this.TopItem;
         }
         if(this.mNumItemsInStack == 1)
         {
            return this.mItems[0];
         }
         return null;
      }
      
      public function AddItem(param1:InventorySlotInfo) : void
      {
         this.mItems.push(param1);
         this.mNumItemsInStack += param1.Count;
         this.mTotalValueOfItemsInStack += param1.itemInfo.TotalValue;
         this.mItems.sort(ItemsSortingFunction);
      }
      
      public function AddItems(param1:Object) : void
      {
         var _loc2_:InventorySlotInfo = null;
         for each(_loc2_ in param1)
         {
            this.mItems.push(_loc2_);
            this.mNumItemsInStack += _loc2_.Count;
            this.mTotalValueOfItemsInStack += _loc2_.itemInfo.TotalValue;
         }
         this.mItems.sort(ItemsSortingFunction);
      }
      
      public function RemoveItem(param1:InventoryItemInfo) : void
      {
         var _loc2_:int = GetIndexInStack(param1.object_id,this);
         if(_loc2_ < 0)
         {
            return;
         }
         var _loc3_:InventorySlotInfo = this.mItems[_loc2_];
         this.mItems.splice(_loc2_,1);
         this.mNumItemsInStack -= _loc3_.Count;
         this.mTotalValueOfItemsInStack -= _loc3_.itemInfo.TotalValue;
      }
      
      public function UpdateItem(param1:InventoryItemInfo) : void
      {
         var _loc2_:int = GetIndexInStack(param1.object_id,this);
         if(_loc2_ < 0)
         {
            return;
         }
         var _loc3_:InventoryItemInfo = this.mItems[_loc2_].itemInfo;
         this.mItems[_loc2_].itemInfo = param1;
         this.mNumItemsInStack = this.mNumItemsInStack - _loc3_.count + param1.count;
         this.mTotalValueOfItemsInStack = this.mTotalValueOfItemsInStack - _loc3_.TotalValue + param1.TotalValue;
         this.mItems.sort(ItemsSortingFunction);
      }
      
      public function ReplaceItem(param1:InventoryItemInfo) : void
      {
         var _loc2_:int = GetIndexInStack(param1.old_object_id,this);
         if(_loc2_ < 0)
         {
            return;
         }
         var _loc3_:InventoryItemInfo = this.mItems[_loc2_].itemInfo;
         this.mItems[_loc2_].itemInfo = param1;
         this.mNumItemsInStack = this.mNumItemsInStack - _loc3_.count + param1.count;
         this.mTotalValueOfItemsInStack = this.mTotalValueOfItemsInStack - _loc3_.TotalValue + param1.TotalValue;
         this.mItems.sort(ItemsSortingFunction);
      }
      
      public function UpdateItemValue(param1:String, param2:uint) : void
      {
         var _loc3_:int = GetIndexInStack(param1,this);
         if(_loc3_ < 0)
         {
            return;
         }
         var _loc4_:InventoryItemInfo = this.mItems[_loc3_].itemInfo;
         var _loc5_:uint = uint(_loc4_.TotalValue);
         _loc4_.value = param2;
         this.mTotalValueOfItemsInStack = this.mTotalValueOfItemsInStack - _loc5_ + _loc4_.TotalValue;
      }
      
      public function ContainsObjectId(param1:String) : Boolean
      {
         var _loc2_:InventorySlotInfo = null;
         for each(_loc2_ in this.mItems)
         {
            if(_loc2_.ObjectId == param1)
            {
               return true;
            }
         }
         return false;
      }
   }
}

