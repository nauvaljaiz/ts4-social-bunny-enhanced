package gamedata.shared
{
   import gamedata.GameContent;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   import widgets.shared.constants.PackStaticSharedData;
   
   public class PackFilterData extends OlympusObject
   {
      
      public var packId:int;
      
      public var title:LocKey = new LocKey();
      
      public var icon:String;
      
      public var packType:int;
      
      public var packSubType:int = -1;
      
      public var titleString:String;
      
      public var bundleId:String;
      
      public var bundleType:int;
      
      public var fallbackIcon:String;
      
      public function PackFilterData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         if(param1)
         {
            if(param1.hasOwnProperty("title"))
            {
               FixupLocKey(this.title);
            }
            if(param1.hasOwnProperty("titleString"))
            {
               this.title = LocKey.UntranslatedString(param1.titleString);
            }
            if(param1.hasOwnProperty("bundleType"))
            {
               this.ConvertBundleTypeToPackType(param1.bundleType);
            }
         }
      }
      
      protected function ConvertBundleTypeToPackType(param1:int) : void
      {
         switch(param1)
         {
            case PackStaticSharedData.PACK_TYPE_EP:
               this.packType = GameContent.PACKTYPE_EXPANSION;
               break;
            case PackStaticSharedData.PACK_TYPE_GP:
               this.packType = GameContent.PACKTYPE_GAME;
               break;
            case PackStaticSharedData.PACK_TYPE_SP:
               this.packType = GameContent.PACKTYPE_STUFF;
               if(this.packSubType == GameContent.PACKSUBTYPE_INVALID)
               {
                  this.packSubType = GameContent.PACKSUBTYPE_FULL;
               }
               break;
            case PackStaticSharedData.PACK_TYPE_KIT:
               this.packType = GameContent.PACKTYPE_STUFF;
               if(this.packSubType == GameContent.PACKSUBTYPE_INVALID)
               {
                  this.packSubType = GameContent.PACKSUBTYPE_KIT;
               }
               break;
            case PackStaticSharedData.PACK_TYPE_UGC:
               this.packType = GameContent.PACKTYPE_UGC;
               break;
            case PackStaticSharedData.PACK_TYPE_FP:
               this.packType = GameContent.PACKTYPE_FREE;
               break;
            case PackStaticSharedData.PACK_TYPE_SDX:
            default:
               this.packType = GameContent.PACKTYPE_BASE;
         }
      }
   }
}

