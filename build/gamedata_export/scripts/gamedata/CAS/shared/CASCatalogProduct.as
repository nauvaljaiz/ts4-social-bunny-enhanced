package gamedata.CAS.shared
{
   import gamedata.MTX.constants.MTXState;
   import gamedata.shared.SimAgeTypes;
   import gamedata.shared.SimGenderTypes;
   import gamedata.shared.Species;
   import olympus.core.OlympusObject;
   import olympus.data.SelectableArrayDataFeed;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import olympus.resources.IImageContainer;
   import widgets.CAS.constants.CASBodyType;
   import widgets.shared.data.ColorSwatchData;
   import widgets.shared.data.ColorSwatchDataArray;
   
   public class CASCatalogProduct extends OlympusObject
   {
      
      public var data_id:String;
      
      public var title:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var lockedTooltip:LocKey = new LocKey();
      
      public var image:String;
      
      public var body_type:uint;
      
      public var menu_state:int;
      
      public var groupId:int = 0;
      
      public var packId:int;
      
      public var is_modded:Boolean = false;
      
      public var is_reward:Boolean = false;
      
      public var is_new_reward:Boolean = false;
      
      public var allows_color_shift_variations:Boolean = false;
      
      public var mtxState:int;
      
      public var buff_id:String;
      
      public var gender:int = 1;
      
      public var age:uint = 0;
      
      public var species:uint = 0;
      
      public var variation_id:String;
      
      protected var mVariation:CASCatalogProduct;
      
      protected var mBaseVariationsData:ColorSwatchDataArray;
      
      protected var mCurrentSelectedColorSwatchData:ColorSwatchData;
      
      public function CASCatalogProduct(param1:Object = null)
      {
         super(param1);
         this.groupId = param1["body_type"];
      }
      
      public function set CurrentSelectedColorSwatchData(param1:ColorSwatchData) : void
      {
         this.mCurrentSelectedColorSwatchData = param1;
      }
      
      public function get CurrentSelectedColorSwatchData() : ColorSwatchData
      {
         return this.mCurrentSelectedColorSwatchData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:CASCatalogProduct = null;
         super.ParseObject(param1);
         if(Boolean(param1) && "variation_id" in param1)
         {
            _loc2_ = param1["variation_id"];
            if(_loc2_ != null)
            {
               delete param1["variation_id"];
               _loc3_ = this.mVariation = new CASCatalogProduct(param1);
               _loc3_.data_id = _loc2_;
               this.variation_id = null;
            }
         }
      }
      
      public function LoadThumbnail(param1:IImageContainer, param2:Boolean = false, param3:String = null, param4:String = null, param5:Boolean = true, param6:int = -1, param7:int = -1, param8:String = null) : void
      {
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc9_:CASCatalogProduct = this.GetVariation();
         if(_loc9_.image == null)
         {
            if(!param3)
            {
               param3 = "c";
            }
            if(!param4)
            {
               param4 = "l";
            }
            if(!param8)
            {
               param8 = _loc9_.data_id;
            }
            _loc10_ = "thumbs/cas/" + param3 + "_" + param8 + "_" + param4;
            if(!param2)
            {
               _loc11_ = param6 != -1 ? param6 : _loc9_.gender;
               _loc10_ += SimGenderTypes.IsFemale(_loc11_) ? "_f" : "_m";
            }
            if(!param5)
            {
               _loc10_ += "_";
               _loc12_ = param7 != -1 ? uint(param7) : _loc9_.age;
               switch(_loc12_)
               {
                  case SimAgeTypes.BABY:
                     _loc10_ += "b";
                     break;
                  case SimAgeTypes.TODDLER:
                     _loc10_ += "p";
                     break;
                  case SimAgeTypes.CHILD:
                     _loc10_ += "c";
                     break;
                  case SimAgeTypes.TEEN:
                     _loc10_ += "t";
                     break;
                  case SimAgeTypes.YOUNGADULT:
                     _loc10_ += "y";
                     break;
                  case SimAgeTypes.ADULT:
                     _loc10_ += "a";
                     break;
                  case SimAgeTypes.ELDER:
                     _loc10_ += "e";
                     break;
                  default:
                     _loc10_ += "u";
               }
               _loc13_ = _loc9_.species;
               switch(_loc13_)
               {
                  case Species.TYPE_DOG:
                     _loc10_ += "d";
                     break;
                  case Species.TYPE_SMALLDOG:
                     _loc10_ += "l";
                     break;
                  case Species.TYPE_CAT:
                     _loc10_ += "c";
                     break;
                  case Species.TYPE_HORSE:
                     _loc10_ += "h";
                     break;
                  default:
                     _loc10_ += "u";
               }
            }
            _loc9_.image = _loc10_;
         }
         param1.LoadImage(_loc9_.image);
      }
      
      public function IsUnviewed() : Boolean
      {
         return this.is_new_reward || this.mtxState == MTXState.UNLOCKED_NEW;
      }
      
      public function SetViewed() : void
      {
         this.is_new_reward = false;
         if(this.mtxState == MTXState.UNLOCKED_NEW)
         {
            this.mtxState = MTXState.UNLOCKED;
         }
      }
      
      public function IsMTX() : Boolean
      {
         return this.mtxState == MTXState.UNLOCKED || this.mtxState == MTXState.UNLOCKED_NEW;
      }
      
      public function IsLocked() : Boolean
      {
         return this.lockedTooltip.IsValid();
      }
      
      public function GetColorSwatchArray(param1:String = null, param2:String = null, param3:Array = null, param4:Boolean = false) : ColorSwatchDataArray
      {
         var _loc5_:ColorSwatchDataArray = null;
         var _loc6_:Object = {
            "base":this.data_id,
            "simId":(param1 != null ? param1 : "0"),
            "targetSimId":(param2 != null ? param2 : "0")
         };
         if(param3 == null)
         {
            if(this.mBaseVariationsData == null || param4)
            {
               this.mBaseVariationsData = new ColorSwatchDataArray(CommunicationManager.CallGameService("GetCatalogColorFamilies",_loc6_));
            }
            _loc5_ = this.mBaseVariationsData;
         }
         else
         {
            _loc6_["tags"] = param3;
            _loc5_ = new ColorSwatchDataArray(CommunicationManager.CallGameService("GetCatalogColorFamilies",_loc6_));
         }
         return _loc5_;
      }
      
      public function GetColorSwatchDataFeed(param1:String = null, param2:String = null, param3:Array = null, param4:Boolean = false) : SelectableArrayDataFeed
      {
         var _loc5_:ColorSwatchDataArray = this.GetColorSwatchArray(param1,param2,param3,param4);
         var _loc6_:SelectableArrayDataFeed = new SelectableArrayDataFeed();
         if(_loc5_)
         {
            _loc6_.AddItemsFromIterable(_loc5_.mItems);
         }
         return _loc6_;
      }
      
      public function SetVariation(param1:CASCatalogProduct) : void
      {
         if(param1 == null || param1.data_id == this.data_id)
         {
            this.mVariation = null;
         }
         else
         {
            this.mVariation = param1;
         }
      }
      
      public function GetVariation() : CASCatalogProduct
      {
         if(this.mVariation)
         {
            return this.mVariation;
         }
         return this;
      }
      
      public function GetVariationOrBaseId() : String
      {
         if(this.mVariation)
         {
            return this.mVariation.data_id;
         }
         return this.data_id;
      }
      
      public function MatchesBaseOrVariationId(param1:String) : Boolean
      {
         if(Boolean(this.mVariation) && this.mVariation.data_id == param1)
         {
            return true;
         }
         return this.data_id == param1;
      }
      
      public function AllowsCreatingColorShiftVariations() : Boolean
      {
         return this.body_type == CASBodyType.LIPSTICK || this.body_type == CASBodyType.EYESHADOW || this.body_type == CASBodyType.EYELINER || this.body_type == CASBodyType.BLUSH || this.body_type == CASBodyType.COSTUMEMAKEUP || this.body_type == CASBodyType.SKINSPECULARITY || this.allows_color_shift_variations;
      }
   }
}

