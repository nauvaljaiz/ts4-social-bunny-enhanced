package gamedata
{
   import gamedata.shared.PackFilterData;
   import gamedata.shared.Species;
   import olympus.constants.Alignment;
   import olympus.controls.objects.MenuItem;
   import olympus.core.ConnectionManager;
   import olympus.core.tooltip.TooltipObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import widgets.shared.utils.DLCTrialsUtils;
   
   public class GameContent
   {
      
      protected static var sPackReleaseOrder:Array;
      
      protected static var sPackFilterList:Vector.<PackFilterData>;
      
      protected static var sUGCPackFilterList:Vector.<PackFilterData>;
      
      public static const PACKID_UGC_GROUP:int = 100002;
      
      public static const PACKID_RESERVED:int = 100001;
      
      public static const PACKID_KITGROUP:int = 100000;
      
      public static const PACKID_UNDEFINED:int = -1;
      
      public static const PACKID_BASE_GAME:int = 0;
      
      public static const PACKID_SP01:int = 1;
      
      public static const PACKID_GP01:int = 2;
      
      public static const PACKID_EP01:int = 3;
      
      public static const PACKID_SP02:int = 4;
      
      public static const PACKID_FP01:int = 5;
      
      public static const PACKID_GP02:int = 6;
      
      public static const PACKID_SP03:int = 7;
      
      public static const PACKID_SP04:int = 8;
      
      public static const PACKID_EP02:int = 9;
      
      public static const PACKID_GP03:int = 10;
      
      public static const PACKID_SP05:int = 11;
      
      public static const PACKID_SP06:int = 12;
      
      public static const PACKID_SP07:int = 13;
      
      public static const PACKID_SP08:int = 14;
      
      public static const PACKID_SP09:int = 15;
      
      public static const PACKID_GP04:int = 17;
      
      public static const PACKID_GP05:int = 18;
      
      public static const PACKID_GP06:int = 19;
      
      public static const PACKID_GP07:int = 20;
      
      public static const PACKID_GP08:int = 21;
      
      public static const PACKID_GP09:int = 22;
      
      public static const PACKID_EP03:int = 24;
      
      public static const PACKID_EP04:int = 25;
      
      public static const PACKID_EP05:int = 26;
      
      public static const PACKID_EP06:int = 27;
      
      public static const PACKID_EP07:int = 28;
      
      public static const PACKID_EP08:int = 29;
      
      public static const PACKID_EP09:int = 30;
      
      public static const PACKID_EP10:int = 31;
      
      public static const PACKID_SP14:int = 35;
      
      public static const PACKID_SP15:int = 36;
      
      public static const PACKID_SP22:int = 43;
      
      public static const PACKID_EP11:int = 52;
      
      public static const PACKID_EP12:int = 53;
      
      public static const PACKID_EP13:int = 54;
      
      public static const PACKID_EP14:int = 55;
      
      public static const PACKID_EP15:int = 56;
      
      public static const PACKID_EP16:int = 57;
      
      public static const PACKID_EP17:int = 58;
      
      public static const PACKID_EP18:int = 59;
      
      public static const PACKID_EP19:int = 60;
      
      public static const PACKID_EP20:int = 61;
      
      public static const PACKID_GP11:int = 62;
      
      public static const PACKID_GP12:int = 63;
      
      public static const PACKID_SP46:int = 87;
      
      public static const PACKID_SP78:int = 119;
      
      public static const PACKID_SP79:int = 120;
      
      public static const PACKID_EP21:int = 141;
      
      public static const PACKTYPE_BASE:int = 0;
      
      public static const PACKTYPE_EXPANSION:int = 1;
      
      public static const PACKTYPE_GAME:int = 2;
      
      public static const PACKTYPE_STUFF:int = 3;
      
      public static const PACKTYPE_FREE:int = 4;
      
      public static const PACKTYPE_UGC:int = 5;
      
      public static const PACKTYPE_INVALID:int = -1;
      
      public static const PACKSUBTYPE_FULL:int = 0;
      
      public static const PACKSUBTYPE_KIT:int = 1;
      
      public static const PACKSUBTYPE_KIT_CAS:int = 2;
      
      public static const PACKSUBTYPE_KIT_BB:int = 3;
      
      public static const PACKSUBTYPE_KIT_FREE:int = 4;
      
      public static const PACKSUBTYPE_KIT_FREE_CAS:int = 5;
      
      public static const PACKSUBTYPE_KIT_FREE_BB:int = 6;
      
      public static const PACKSUBTYPE_INVALID:int = -1;
      
      public static const PF_NONE:int = 0;
      
      public static const PF_ENTITLED:int = 1 << 0;
      
      public static const PF_INSTALLED:int = 1 << 1;
      
      public static const PF_ENABLED:int = 1 << 2;
      
      public static const PF_SELECTED:int = 1 << 3;
      
      public static const PF_LOADED:int = 1 << 4;
      
      public static const PACKTYPEKEY_UNENTITLED:String = "9_UNENTITLED";
      
      protected static var mEntitledPacks:Object = new Object();
      
      protected static var mInstalledPacks:Object = new Object();
      
      protected static var sFullGameAuthorized:int = -1;
      
      protected static var sExchangeMetadataVersion:int = -1;
      
      public function GameContent()
      {
         super();
      }
      
      public static function get HAS_SP22() : Boolean
      {
         return IsPackAvailable(PACKID_SP22);
      }
      
      public static function get HAS_SP01() : Boolean
      {
         return IsPackAvailable(PACKID_SP01);
      }
      
      public static function get HAS_SP15() : Boolean
      {
         return IsPackAvailable(PACKID_SP15);
      }
      
      public static function get HAS_SP46() : Boolean
      {
         return IsPackAvailable(PACKID_SP46);
      }
      
      public static function get HAS_GP01() : Boolean
      {
         return IsPackAvailable(PACKID_GP01);
      }
      
      public static function get HAS_GP02() : Boolean
      {
         return IsPackAvailable(PACKID_GP02);
      }
      
      public static function get HAS_GP03() : Boolean
      {
         return IsPackAvailable(PACKID_GP03);
      }
      
      public static function get HAS_GP04() : Boolean
      {
         return IsPackAvailable(PACKID_GP04);
      }
      
      public static function get HAS_GP08() : Boolean
      {
         return IsPackAvailable(PACKID_GP08);
      }
      
      public static function get HAS_GP09() : Boolean
      {
         return IsPackAvailable(PACKID_GP09);
      }
      
      public static function get HAS_GP11() : Boolean
      {
         return IsPackAvailable(PACKID_GP11);
      }
      
      public static function get HAS_GP12() : Boolean
      {
         return IsPackAvailable(PACKID_GP12);
      }
      
      public static function get HAS_EP01() : Boolean
      {
         return IsPackAvailable(PACKID_EP01);
      }
      
      public static function get HAS_EP02() : Boolean
      {
         return IsPackAvailable(PACKID_EP02);
      }
      
      public static function get HAS_EP04() : Boolean
      {
         return IsPackAvailable(PACKID_EP04);
      }
      
      public static function get HAS_EP05() : Boolean
      {
         return IsPackAvailable(PACKID_EP05);
      }
      
      public static function get HAS_EP06() : Boolean
      {
         return IsPackAvailable(PACKID_EP06);
      }
      
      public static function get HAS_EP07() : Boolean
      {
         return IsPackAvailable(PACKID_EP07);
      }
      
      public static function get HAS_EP08() : Boolean
      {
         return IsPackAvailable(PACKID_EP08);
      }
      
      public static function get HAS_EP09() : Boolean
      {
         return IsPackAvailable(PACKID_EP09);
      }
      
      public static function get HAS_EP10() : Boolean
      {
         return IsPackAvailable(PACKID_EP10);
      }
      
      public static function get HAS_EP11() : Boolean
      {
         return IsPackAvailable(PACKID_EP11);
      }
      
      public static function get HAS_EP12() : Boolean
      {
         return IsPackAvailable(PACKID_EP12);
      }
      
      public static function get HAS_EP13() : Boolean
      {
         return IsPackAvailable(PACKID_EP13);
      }
      
      public static function get HAS_EP14() : Boolean
      {
         return IsPackAvailable(PACKID_EP14);
      }
      
      public static function get HAS_EP15() : Boolean
      {
         return IsPackAvailable(PACKID_EP15);
      }
      
      public static function get HAS_EP16() : Boolean
      {
         return IsPackAvailable(PACKID_EP16);
      }
      
      public static function get HAS_EP17() : Boolean
      {
         return IsPackAvailable(PACKID_EP17);
      }
      
      public static function get HAS_EP18() : Boolean
      {
         return IsPackAvailable(PACKID_EP18);
      }
      
      public static function get HAS_EP19() : Boolean
      {
         return IsPackAvailable(PACKID_EP19);
      }
      
      public static function get HAS_EP20() : Boolean
      {
         return IsPackAvailable(PACKID_EP20);
      }
      
      public static function get HAS_EP21() : Boolean
      {
         return IsPackAvailable(PACKID_EP21);
      }
      
      public static function IsPackAvailable(param1:int) : Boolean
      {
         if(param1 == PACKID_BASE_GAME)
         {
            return true;
         }
         return HasPackEntitlement(param1) && HasPackInstalled(param1) && IsPackActive(param1);
      }
      
      public static function IsPackActive(param1:int) : Boolean
      {
         return (GameContent.GetPackFlags(param1) & GameContent.PF_SELECTED) != 0;
      }
      
      public static function HasPackEntitlement(param1:int) : Boolean
      {
         if(!(param1 in mEntitledPacks))
         {
            mEntitledPacks[param1] = Boolean(CommunicationManager.CallGameService("HasPackEntitlement",{"packId":param1},true));
         }
         return mEntitledPacks[param1];
      }
      
      public static function HasPackInstalled(param1:int) : Boolean
      {
         if(!(param1 in mInstalledPacks))
         {
            mInstalledPacks[param1] = Boolean(CommunicationManager.CallGameService("HasPackInstalled",{"packId":param1},true));
         }
         return mInstalledPacks[param1];
      }
      
      public static function HasPackInstalledOnFileSystem(param1:int) : Boolean
      {
         return Boolean(CommunicationManager.CallGameService("HasPackInstalledOnFileSystem",{"packId":param1},true));
      }
      
      public static function GetPackFlags(param1:int) : int
      {
         return int(CommunicationManager.CallGameService("GetPackFlags",{"packId":param1},true));
      }
      
      public static function GetPackRequirement(param1:int) : int
      {
         switch(param1)
         {
            case PACKID_SP14:
               return PACKID_EP04;
            default:
               return PACKID_BASE_GAME;
         }
      }
      
      public static function GetPackPrefix(param1:int) : String
      {
         return CommunicationManager.CallGameService("GetPackPrefix",{"packId":param1}) as String;
      }
      
      public static function GetPackData(param1:int) : PackFilterData
      {
         var _loc4_:PackFilterData = null;
         var _loc2_:Vector.<PackFilterData> = GetAllUGCFilterData();
         var _loc3_:Vector.<PackFilterData> = GetAllPackFilterData();
         if(_loc2_)
         {
            if(_loc3_)
            {
               _loc3_ = _loc3_.concat(_loc2_);
            }
            else
            {
               _loc3_ = _loc2_;
            }
         }
         if(_loc3_)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.packId == param1)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public static function get PackReleaseOrder() : Array
      {
         if(!sPackReleaseOrder)
         {
            sPackReleaseOrder = CommunicationManager.CallGameService("GetPackReleaseOrder") as Array;
         }
         return sPackReleaseOrder;
      }
      
      public static function GetPackTypeName(param1:int, param2:int = 0) : String
      {
         switch(param1)
         {
            case PACKTYPE_EXPANSION:
               return Keys.FILTER_PANEL_EXPANSIONPACKS.toString();
            case PACKTYPE_GAME:
               return Keys.FILTER_PANEL_GAMEPACKS.toString();
            case PACKTYPE_STUFF:
               if(IsKit(param2))
               {
                  return GetSubPackTypeName(param2);
               }
               return Keys.FILTER_PANEL_STUFFPACKS.toString();
               break;
            case PACKTYPE_FREE:
               return Keys.FILTER_PANEL_FREEPACKS.toString();
            case PACKTYPE_UGC:
               return Keys.FILTER_PANEL_UGC.toString();
            default:
               return "";
         }
      }
      
      public static function GetSubPackTypeName(param1:int) : String
      {
         switch(param1)
         {
            case PACKSUBTYPE_KIT:
            case PACKSUBTYPE_KIT_CAS:
            case PACKSUBTYPE_KIT_BB:
               return Keys.FILTER_PANEL_KITPACKS.toString();
            default:
               return null;
         }
      }
      
      public static function GetAllPackFilterData() : Vector.<PackFilterData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<PackFilterData> = null;
         var _loc4_:int = 0;
         if(!sPackFilterList || sPackFilterList.length == 0)
         {
            _loc1_ = CommunicationManager.CallGameService("GetPackFilterData") as Array;
            if(!_loc1_ || _loc1_.length == 0)
            {
               return null;
            }
            _loc2_ = int(_loc1_.length);
            _loc3_ = new Vector.<PackFilterData>(_loc1_.length,true);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_[_loc4_] = new PackFilterData(_loc1_[_loc4_]);
               _loc4_++;
            }
            _loc3_.sort(PackSortingFunction);
            sPackFilterList = _loc3_;
         }
         return sPackFilterList;
      }
      
      public static function GetAllUGCFilterData() : Vector.<PackFilterData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<PackFilterData> = null;
         var _loc4_:int = 0;
         if(!sUGCPackFilterList || sUGCPackFilterList.length == 0)
         {
            _loc1_ = CommunicationManager.CallGameService("GetUGCPackFilterData") as Array;
            if(!_loc1_ || _loc1_.length == 0)
            {
               return null;
            }
            _loc2_ = int(_loc1_.length);
            _loc3_ = new Vector.<PackFilterData>(_loc1_.length,true);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_[_loc4_] = new PackFilterData(_loc1_[_loc4_]);
               _loc4_++;
            }
            _loc3_.sort(PackSortingFunction);
            sUGCPackFilterList = _loc3_;
         }
         return sUGCPackFilterList;
      }
      
      public static function GetAllUGCPackIds() : Array
      {
         var _loc5_:PackFilterData = null;
         var _loc1_:Array = [];
         var _loc2_:Vector.<PackFilterData> = GetAllUGCFilterData();
         if(!_loc2_ || _loc2_.length == 0)
         {
            return _loc1_;
         }
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc1_[_loc4_] = _loc5_.packId;
            _loc4_++;
         }
         return _loc1_;
      }
      
      public static function GetPackFilterListWithPackTypes(param1:Boolean = false, param2:Array = null) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Boolean = false;
         var _loc13_:PackFilterData = null;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc3_:Vector.<PackFilterData> = GameContent.GetAllPackFilterData();
         if(!param2)
         {
            param2 = [PACKSUBTYPE_INVALID];
         }
         if(!_loc3_)
         {
            return new Array();
         }
         var _loc4_:Array = new Array();
         var _loc8_:Boolean = false;
         var _loc9_:int = GameContent.PACKTYPE_BASE;
         var _loc10_:TooltipObject = new TooltipObject(null);
         _loc10_.SetText(Keys.FILTER_DISABLED_PACK_TOOLTIP.toString());
         _loc10_.VerticalAlignment = Alignment.CENTER;
         _loc10_.HorizontalAlignment = Alignment.LEFT;
         var _loc11_:int = int(_loc3_.length);
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            _loc13_ = _loc3_[_loc12_];
            _loc14_ = _loc13_.packType;
            if(param2.indexOf(_loc13_.packSubType) == -1)
            {
               _loc15_ = IsKitFree(_loc13_.packSubType);
               if(_loc15_)
               {
                  _loc14_ = GameContent.PACKTYPE_FREE;
               }
               if(_loc14_ > _loc9_)
               {
                  _loc9_ = _loc14_;
                  _loc4_.push(new MenuItem(GameContent.GetPackTypeName(_loc9_),null,false));
               }
               if(!_loc15_ && !_loc8_ && IsKit(_loc13_.packSubType))
               {
                  _loc8_ = !_loc8_;
                  _loc4_.push(new MenuItem(GameContent.GetPackTypeName(_loc9_,_loc13_.packSubType),null,false));
               }
               _loc5_ = _loc13_.packId;
               _loc6_ = {"packId":_loc5_};
               _loc7_ = GameContent.IsPackAvailable(_loc5_);
               _loc4_.push(new MenuItem(_loc13_.title.toString(),param1 ? _loc6_ : _loc5_,_loc7_,_loc13_.icon,_loc7_ ? null : _loc10_));
            }
            _loc12_++;
         }
         return _loc4_;
      }
      
      public static function GetPackFilterMenuItemForPackId(param1:int, param2:Boolean = false) : MenuItem
      {
         var _loc4_:PackFilterData = null;
         var _loc3_:Vector.<PackFilterData> = GameContent.GetAllPackFilterData();
         if(!_loc3_)
         {
            return null;
         }
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.packId == param1)
            {
               return new MenuItem(_loc4_.title.toString(),param2 ? {"packId":param1} : param1,GameContent.IsPackAvailable(param1),_loc4_.icon,null);
            }
         }
         return null;
      }
      
      public static function GetPackTypeKey(param1:int, param2:int, param3:Boolean = false) : String
      {
         if(param3 && IsKit(param2))
         {
            param2 = PACKSUBTYPE_KIT;
         }
         return param1.toString() + "," + param2.toString();
      }
      
      public static function PackTypeKeyToObject(param1:String) : Object
      {
         var _loc2_:Array = param1.split(",");
         return {
            "packType":int(_loc2_[0]),
            "packSubType":int(_loc2_[1])
         };
      }
      
      public static function GetMenuItemsForPackSelection() : Object
      {
         var _loc5_:PackFilterData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc1_:Object = {};
         var _loc2_:Vector.<PackFilterData> = GameContent.GetAllPackFilterData();
         if(!_loc2_)
         {
            return _loc1_;
         }
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         for(; _loc4_ < _loc3_; _loc4_++)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.packType != PACKTYPE_BASE)
            {
               _loc6_ = _loc5_.packId;
               _loc7_ = GetPackFlags(_loc6_);
               _loc8_ = null;
               if((_loc7_ & GameContent.PF_ENTITLED) == 0)
               {
                  if(ConnectionManager.IsChildAccount)
                  {
                     continue;
                  }
                  _loc8_ = PACKTYPEKEY_UNENTITLED;
               }
               if(_loc8_ == null)
               {
                  _loc8_ = GetPackTypeKey(_loc5_.packType,_loc5_.packSubType,true);
               }
               if(!_loc1_.hasOwnProperty(_loc8_))
               {
                  _loc1_[_loc8_] = [];
               }
               _loc9_ = _loc1_[_loc8_];
               _loc9_.push(new MenuItem(_loc5_.title.toString(),{
                  "packId":_loc6_,
                  "packFlags":_loc7_
               },true,_loc5_.icon));
            }
         }
         return _loc1_;
      }
      
      public static function GetAllPackIds() : Array
      {
         var _loc3_:PackFilterData = null;
         var _loc1_:Vector.<PackFilterData> = GetAllPackFilterData();
         var _loc2_:Array = [];
         if(!_loc1_)
         {
            return _loc2_;
         }
         for each(_loc3_ in _loc1_)
         {
            _loc2_.push(_loc3_.packId);
         }
         return _loc2_;
      }
      
      public static function Refresh() : void
      {
         mEntitledPacks = new Object();
         mInstalledPacks = new Object();
         sPackFilterList = null;
         sUGCPackFilterList = null;
         sPackReleaseOrder = null;
         sExchangeMetadataVersion = -1;
         sFullGameAuthorized = -1;
      }
      
      public static function GetCurrentExchangeMetadataVersion() : int
      {
         if(sExchangeMetadataVersion == -1)
         {
            sExchangeMetadataVersion = CommunicationManager.CallGameService("GetExchangeMetadataVersion") as int;
         }
         return sExchangeMetadataVersion;
      }
      
      public static function IsGameFullVersion() : Boolean
      {
         var _loc1_:Boolean = false;
         if(sFullGameAuthorized == -1)
         {
            _loc1_ = CommunicationManager.CallGameService("GetIsFullGameAuthorized",null,true) as Boolean;
            sFullGameAuthorized = _loc1_ ? 1 : 0;
         }
         return sFullGameAuthorized == 1;
      }
      
      public static function IsSpeciesAvailable(param1:uint) : Boolean
      {
         switch(param1)
         {
            case Species.TYPE_CAT:
            case Species.TYPE_DOG:
            case Species.TYPE_SMALLDOG:
               return HAS_EP04;
            case Species.TYPE_HORSE:
               return HAS_EP14;
            case Species.TYPE_NONE:
            case Species.TYPE_HUMAN:
               return true;
            default:
               return false;
         }
      }
      
      public static function IsOccultPackInstalled() : Boolean
      {
         return HAS_EP01 || HAS_GP04 || HAS_EP07 || HAS_GP08 || HAS_GP12;
      }
      
      public static function PackSortingFunction(param1:Object, param2:Object) : Number
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 is PackFilterData && param2 is PackFilterData)
         {
            if(param1.packType != param2.packType)
            {
               return param1.packType - param2.packType;
            }
            _loc5_ = IsKit(param1.packSubType) ? PACKSUBTYPE_KIT : int(param1.packSubType);
            _loc6_ = IsKit(param2.packSubType) ? PACKSUBTYPE_KIT : int(param2.packSubType);
            if(_loc5_ != _loc6_)
            {
               return _loc5_ - _loc6_;
            }
         }
         var _loc3_:int = GameContent.PackReleaseOrder.indexOf(int(param1.packId));
         var _loc4_:int = GameContent.PackReleaseOrder.indexOf(int(param2.packId));
         return _loc3_ - _loc4_;
      }
      
      public static function PackSortingTrialFirstFunction(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = 0;
         if(DLCTrialsUtils.IsFreeTrial())
         {
            _loc3_ = DLCTrialsUtils.GetFreeTrialPackId();
            if(param1.packId == _loc3_)
            {
               return -1;
            }
            if(param2.packId == _loc3_)
            {
               return 1;
            }
         }
         return PackSortingFunction(param1,param2);
      }
      
      public static function GetPackIDFromName(param1:String) : int
      {
         var _loc2_:String = "PACKID_" + param1;
         if(_loc2_ in GameContent)
         {
            return int(GameContent[_loc2_]);
         }
         return PACKID_UNDEFINED;
      }
      
      public static function IsKit(param1:int) : Boolean
      {
         switch(param1)
         {
            case PACKSUBTYPE_FULL:
               return false;
            case PACKSUBTYPE_KIT:
            case PACKSUBTYPE_KIT_CAS:
            case PACKSUBTYPE_KIT_BB:
               return true;
            default:
               return false;
         }
      }
      
      public static function IsKitFree(param1:int) : Boolean
      {
         switch(param1)
         {
            case PACKSUBTYPE_KIT_FREE:
            case PACKSUBTYPE_KIT_FREE_CAS:
            case PACKSUBTYPE_KIT_FREE_BB:
               return true;
            default:
               return false;
         }
      }
   }
}

