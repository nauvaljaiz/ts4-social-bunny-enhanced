package gamedata.CAS
{
   import gamedata.CAS.shared.CASCatalogFilter;
   import olympus.io.CommunicationManager;
   import widgets.shared.data.ColorSwatchData;
   
   public final class CASAPI
   {
      
      public function CASAPI()
      {
         super();
      }
      
      public static function GetCatalogBaseItemSelected(param1:int, param2:Array = null, param3:Array = null, param4:int = 0, param5:int = -1) : Array
      {
         param2 ||= new Array();
         param3 ||= new Array();
         return CommunicationManager.CallGameService("GetCatalogBaseItemSelected",{
            "state":param1,
            "tags":param2,
            "bodyType":param4,
            "layer":param5,
            "excludeTags":param3
         },true) as Array;
      }
      
      public static function GetBodyTypeLayers(param1:int = 0) : Array
      {
         return CommunicationManager.CallGameService("GetBodyTypeLayers",{"bodyType":param1},true) as Array;
      }
      
      public static function GetCatalogItemsSelected(param1:int) : Array
      {
         return CommunicationManager.CallGameService("GetCatalogItemsSelected",{"state":param1}) as Array;
      }
      
      public static function GetCatalogItemSelectedWithModifiers(param1:int, param2:String) : ColorSwatchData
      {
         var _loc4_:Object = null;
         var _loc5_:ColorSwatchData = null;
         var _loc3_:Array = CommunicationManager.CallGameService("GetCatalogItemsSelectedWithModifiers",{"state":param1}) as Array;
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = _loc4_ ? new ColorSwatchData(_loc4_) : null;
               if((Boolean(_loc5_)) && (param2 == "0" || _loc5_.dataID == param2))
               {
                  return _loc5_;
               }
            }
         }
         return null;
      }
      
      public static function CatalogHasRewardItem(param1:int, param2:Array = null) : Boolean
      {
         param2 ||= new Array();
         return Boolean(CommunicationManager.CallGameService("CasCatalogHasRewardItem",{
            "state":param1,
            "tags":param2
         }));
      }
      
      public static function GetCatalogBaseItems(param1:int, param2:Array = null, param3:Array = null, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Array = null, param9:Object = null, param10:int = 0) : Array
      {
         param2 ||= new Array();
         param8 ||= new Array();
         return CommunicationManager.CallGameService("GetCatalogBaseItems",{
            "state":param1,
            "tags":param2,
            "excludeTags":param3,
            "unlocks":param4,
            "locked":param5,
            "mtx":param6,
            "mods":param7,
            "packIds":param8,
            "genusOverride":param9,
            "bodyType":param10
         }) as Array;
      }
      
      public static function GetCatalogBaseItemsUsingFilter(param1:CASCatalogFilter, param2:Object = null) : Array
      {
         return GetCatalogBaseItems(param1.menuState,param1.tags,param1.excludeTags,param1.filterByGameplayUnlocks,param1.filterLocked,param1.filterPurchasedProducts,param1.filterModdedContent,param1.packIds,param2,param1.body_type);
      }
      
      public static function ClearCatalogSlotSelected(param1:int, param2:Array, param3:Array) : void
      {
         CommunicationManager.CallGameService("ClearCatalogSlotSelected",{
            "menuState":param1,
            "tags":param2,
            "excludeTags":param3
         });
      }
      
      public static function SwapBodyTypeLayers(param1:int, param2:int, param3:int) : void
      {
         CommunicationManager.CallGameService("SwapBodyTypeLayers",{
            "bodyType":param1,
            "partLayer1":param2,
            "partLayer2":param3
         });
      }
      
      public static function MoveBodyTypeLayers(param1:int, param2:int, param3:int) : void
      {
         CommunicationManager.CallGameService("MoveOutfitPartLayerToIndex",{
            "bodyType":param1,
            "from":param2,
            "to":param3
         });
      }
      
      public static function AddEmptyLayer(param1:int, param2:int, param3:int) : void
      {
         CommunicationManager.CallGameService("AddEmptyLayer",{
            "bodyType":param1,
            "partLayer":param2,
            "partLayerId":param3
         });
      }
      
      public static function RemoveBodyTypeLayer(param1:int, param2:int) : void
      {
         CommunicationManager.CallGameService("RemoveBodyTypeLayer",{
            "bodyType":param1,
            "partLayer":param2
         });
      }
   }
}

