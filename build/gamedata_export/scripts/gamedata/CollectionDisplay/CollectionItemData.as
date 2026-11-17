package gamedata.CollectionDisplay
{
   import gamedata.BuildBuy.shared.CollectionProduct;
   import gamedata.Gameplay.shared.IItemData;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class CollectionItemData extends OlympusObject implements IItemData
   {
      
      public var definition_id:String;
      
      public var discovered:Boolean;
      
      public var customNotFoundTooltip:LocKey;
      
      public var name:LocKey;
      
      public var desc:LocKey;
      
      public var packId:int;
      
      public var customName:String;
      
      public var customDesc:String;
      
      public var rarity:int;
      
      public var rarity_name:LocKey;
      
      protected var mCollectibleItemUpdate:CollectibleItemUpdate;
      
      protected var mCollectionProduct:CollectionProduct;
      
      protected var mIsBonusSet:Boolean;
      
      public function CollectionItemData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.definition_id = param1.definition_id;
         this.discovered = param1.discovered;
         if("rarity" in param1)
         {
            this.rarity = param1.rarity;
         }
         if("rarity_name" in param1)
         {
            this.rarity_name = new LocKey(param1.rarity_name);
         }
         else
         {
            this.rarity_name = new LocKey();
         }
         if("custom_not_found_tooltip" in param1)
         {
            this.customNotFoundTooltip = new LocKey(param1.custom_not_found_tooltip);
         }
         else
         {
            this.customNotFoundTooltip = new LocKey();
         }
      }
      
      public function get ItemCollectionProduct() : CollectionProduct
      {
         if(!this.mCollectionProduct)
         {
            this.mCollectionProduct = new CollectionProduct(CommunicationManager.CallGameService("GetCollectionProduct",{"defId":this.definition_id}));
         }
         return this.mCollectionProduct;
      }
      
      public function set UpdateInfo(param1:CollectibleItemUpdate) : void
      {
         this.mCollectibleItemUpdate = param1;
      }
      
      public function get UpdateInfo() : CollectibleItemUpdate
      {
         return this.mCollectibleItemUpdate;
      }
      
      public function get IsNew() : Boolean
      {
         if(!this.mCollectibleItemUpdate)
         {
            return false;
         }
         return this.mCollectibleItemUpdate.type == CollectibleItemUpdate.TYPE_ADD;
      }
      
      public function get IsFound() : Boolean
      {
         return this.mCollectibleItemUpdate != null;
      }
      
      public function set IsBonus(param1:Boolean) : void
      {
         this.mIsBonusSet = param1;
      }
      
      public function get IsBonus() : Boolean
      {
         return this.mIsBonusSet;
      }
      
      public function get OrderDiscovered() : int
      {
         if(!this.mCollectibleItemUpdate)
         {
            return 0;
         }
         return this.mCollectibleItemUpdate.order_discovered;
      }
      
      public function get Name() : String
      {
         var _loc1_:Object = null;
         if(this.customName)
         {
            return this.customName;
         }
         if(Boolean(this.name.tokens) && Boolean(this.name.tokens.length))
         {
            _loc1_ = this.name.tokens[0];
            if(_loc1_.catalog_name_key)
            {
               return this.name.toString();
            }
         }
         return "";
      }
      
      public function get Description() : String
      {
         var _loc1_:Object = null;
         if(this.customDesc)
         {
            return this.customDesc;
         }
         if(Boolean(this.desc.tokens) && Boolean(this.desc.tokens.length))
         {
            _loc1_ = this.desc.tokens[0];
            if(_loc1_.catalog_description_key)
            {
               return this.desc.toString();
            }
         }
         return "";
      }
   }
}

