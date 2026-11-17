package gamedata.Gameplay.Pickers
{
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.CAS.shared.CASCatalogProduct;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import olympus.objects.IconInfo;
   import olympus.objects.ObjectMetadata;
   import olympus.objects.RelationshipTrackInfo;
   
   public class ObjectPickerRowData extends OlympusObject
   {
      
      public var base_data:PickerBaseRowData = new PickerBaseRowData();
      
      public var object_id:String;
      
      public var def_id:String;
      
      public var rarity_text:LocKey;
      
      public var use_catalog_product_thumbnails:Boolean = true;
      
      public var use_cas_catalog_product_thumbnails:Boolean = false;
      
      public var second_rarity_text:LocKey;
      
      public var flair_icon:IconInfo;
      
      public var status_icons:Array = [IconInfo];
      
      public var cost:uint;
      
      public var discounted_cost:uint;
      
      public var count:uint;
      
      public var object_picker_style:int = 0;
      
      public var cas_catalog_gender:int = -1;
      
      public var slot_types:Array = [ResourceKey];
      
      public var mOwnerSimId:String = null;
      
      public var is_new:Boolean = false;
      
      public var target_sim_id:String = null;
      
      public var dynasty_icon:IconInfo = null;
      
      public var mCatalogProduct:CatalogProduct;
      
      public var mCASCatalogProduct:CASCatalogProduct;
      
      public var mObjectMetadata:ObjectMetadata;
      
      public var mObjectName:String;
      
      public var mDescription:String;
      
      public var mDescriptionDisplay:int = 0;
      
      public var mIndex:int = 0;
      
      public var mRelTrackInfo:RelationshipTrackInfo = null;
      
      public function ObjectPickerRowData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.object_id = param1.object_id;
         this.count = param1.count;
         this.cost = param1.cost;
         this.discounted_cost = param1.discounted_cost;
         this.def_id = param1.def_id;
         this.use_catalog_product_thumbnails = param1.use_catalog_product_thumbnails;
         this.object_picker_style = param1.picker_object_style;
         this.use_cas_catalog_product_thumbnails = param1.use_cas_catalog_product_thumbnails;
         this.cas_catalog_gender = param1.cas_catalog_gender;
         if("base_data" in param1)
         {
            this.base_data = new PickerBaseRowData(param1.base_data);
         }
         if("rarity_text" in param1)
         {
            this.rarity_text = new LocKey(param1.rarity_text);
         }
         if("second_rarity_text" in param1)
         {
            this.second_rarity_text = new LocKey(param1.second_rarity_text);
         }
         if("flair_icon" in param1)
         {
            this.flair_icon = new IconInfo(param1.flair_icon);
         }
         FixupArray(this.status_icons);
         if("status_icons" in param1)
         {
            ConstructArrayFromArray(this.status_icons,param1.status_icons,IconInfo);
         }
         FixupArray(this.slot_types);
         if("slot_types" in param1)
         {
            ConstructArrayFromArray(this.slot_types,param1.slot_types,ResourceKey);
         }
         if("owner_sim_id" in param1)
         {
            this.mOwnerSimId = param1.owner_sim_id;
         }
         if("is_new" in param1)
         {
            this.is_new = param1.is_new;
         }
         if("target_sim_id" in param1)
         {
            this.target_sim_id = param1.target_sim_id;
         }
         if("dynasty_icon" in param1)
         {
            this.dynasty_icon = new IconInfo(param1.dynasty_icon);
         }
      }
      
      public function get RowObjectMetadata() : ObjectMetadata
      {
         var _loc1_:Object = null;
         if(this.mObjectMetadata == null || this.mObjectMetadata.hover_tip == ObjectMetadata.HOVER_TIP_DISABLED)
         {
            if(this.object_id)
            {
               _loc1_ = CommunicationManager.CallGameService("GetObjectMetadata",this.object_id,true);
            }
            this.mObjectMetadata = _loc1_ ? new ObjectMetadata(_loc1_) : null;
         }
         return this.mObjectMetadata;
      }
      
      public function get RowCatalogProduct() : CatalogProduct
      {
         if(!this.mCatalogProduct)
         {
            if(this.def_id)
            {
               this.mCatalogProduct = new CatalogProduct(CommunicationManager.CallGameService("GetCatalogProduct",{"defId":this.def_id}));
            }
         }
         return this.mCatalogProduct;
      }
      
      public function get RowCASCatalogProduct() : CASCatalogProduct
      {
         if(!this.mCASCatalogProduct)
         {
            if(this.def_id)
            {
               this.mCASCatalogProduct = new CASCatalogProduct(CommunicationManager.CallGameService("GetCatalogProduct",{"casProductId":this.def_id}));
            }
         }
         return this.mCASCatalogProduct;
      }
      
      public function get Name() : String
      {
         if(!this.mObjectName)
         {
            if(this.base_data.name)
            {
               this.mObjectName = this.base_data.name.toString();
            }
            else if(this.RowCatalogProduct)
            {
               this.mObjectName = this.mCatalogProduct.Name;
            }
         }
         return this.mObjectName;
      }
      
      public function get Description() : String
      {
         if(!this.mDescription)
         {
            if(this.base_data.description)
            {
               this.mDescription = this.base_data.description.toString();
            }
            else if(this.RowCatalogProduct)
            {
               this.mDescription = this.mCatalogProduct.Description;
            }
         }
         return this.mDescription;
      }
   }
}

