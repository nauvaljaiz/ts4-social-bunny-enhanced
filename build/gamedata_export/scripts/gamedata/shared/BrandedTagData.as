package gamedata.shared
{
   import gamedata.CAS.shared.CASCatalogProduct;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class BrandedTagData extends OlympusObject
   {
      
      public static var sBuildBuyBrandedTagList:Array;
      
      public static const BRANDED_BACKGROUND_LIGHT:int = 0;
      
      public static const BRANDED_BACKGROUND_DARK:int = 1;
      
      public static const BRANDED_STYLE_TOP_WIDE:int = 0;
      
      public static const BRANDED_STYLE_TOP_LEFT_ICON:int = 1;
      
      public static var sCASBrandedTagList:Object = new Object();
      
      public var icon:ResourceKey;
      
      public var background_type:int;
      
      public var tag:String;
      
      public var style:int;
      
      public var tooltip_title:LocKey;
      
      public var tooltip_text:LocKey;
      
      public var products:Array = [String];
      
      public function BrandedTagData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function ClearCASBrandedProductData() : *
      {
         sCASBrandedTagList = new Object();
      }
      
      public static function GetCASBrandedProduct(param1:CASCatalogProduct) : BrandedTagData
      {
         var _loc2_:BrandedTagData = null;
         if(!sCASBrandedTagList[param1.body_type])
         {
            LoadCASTuning(param1.body_type);
         }
         for each(_loc2_ in sCASBrandedTagList[param1.body_type])
         {
            if(Boolean(_loc2_.products) && _loc2_.products.indexOf(param1.data_id) != -1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function GetBuildBuyBrandedProduct(param1:String) : BrandedTagData
      {
         var _loc2_:BrandedTagData = null;
         if(!sBuildBuyBrandedTagList)
         {
            LoadBuildBuyTuning();
         }
         for each(_loc2_ in sBuildBuyBrandedTagList)
         {
            if(Boolean(_loc2_.products) && _loc2_.products.indexOf(param1) != -1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function LoadCASTuning(param1:uint) : void
      {
         var _loc4_:Object = null;
         var _loc2_:Object = CommunicationManager.CallGameService("CasGetBrandedTagsData",{"body_type":param1});
         var _loc3_:Array = _loc2_["brandedTags"] as Array;
         if(_loc3_)
         {
            sCASBrandedTagList[param1] = new Array();
            for each(_loc4_ in _loc3_)
            {
               sCASBrandedTagList[param1][_loc4_.tag] = new BrandedTagData(_loc4_);
            }
         }
      }
      
      public static function LoadBuildBuyTuning() : void
      {
         var _loc3_:Object = null;
         var _loc1_:Object = CommunicationManager.CallGameService("BBGetBrandedTagsData");
         var _loc2_:Array = _loc1_["brandedTags"] as Array;
         if(_loc2_)
         {
            sBuildBuyBrandedTagList = new Array();
            for each(_loc3_ in _loc2_)
            {
               sBuildBuyBrandedTagList[_loc3_.tag] = new BrandedTagData(_loc3_);
            }
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.icon = new ResourceKey(param1.icon);
         this.background_type = param1.background_type;
         this.tag = param1.tag;
         this.style = param1.style;
         if(param1.tooltip_title)
         {
            this.tooltip_title = new LocKey(param1.tooltip_title);
         }
         if(param1.tooltip_text)
         {
            this.tooltip_text = new LocKey(param1.tooltip_text);
         }
         this.products = param1.products;
         FixupArray(this.products);
      }
   }
}

