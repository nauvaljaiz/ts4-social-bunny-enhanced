package gamedata.Exchange
{
   import olympus.core.OlympusObject;
   import olympus.resources.IImageContainer;
   import olympus.utils.ImageUtils;
   import widgets.shared.constants.ExchangeDetailStates;
   
   public class ExchangePartData extends OlympusObject
   {
      
      public var index:int;
      
      public var thumbnailContext:String;
      
      public var itemRemoteId:String;
      
      public var bodyPartSimId:String;
      
      public var bodyType:int;
      
      public function ExchangePartData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.bodyPartSimId = param1.bodyPartSimId;
         this.bodyType = param1.bodyType;
         this.index = param1.index;
         this.thumbnailContext = param1.thumbnailContext;
         this.itemRemoteId = param1.itemRemoteId;
      }
      
      public function LoadThumbnail(param1:IImageContainer, param2:String = null) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         switch(this.thumbnailContext)
         {
            case ExchangeDetailStates.GALLERY:
               return ImageUtils.LoadGalleryThumbnail(param1,this.itemRemoteId,"p",param2,this.index);
            case ExchangeDetailStates.MY_SAVES:
               return ImageUtils.LoadPartLocalThumbnail(param1,ImageUtils.SIM_THUMBNAIL_TYPE_GALLERY,this.itemRemoteId,param2,this.index);
            case ExchangeDetailStates.CAS_SHARE_PLAY:
            case ExchangeDetailStates.SAVE_SUMMARY:
         }
         return ImageUtils.LoadPartThumbnail(param1,ImageUtils.SIM_THUMBNAIL_TYPE_PART,this.bodyType,this.bodyPartSimId,param2,this.index);
      }
   }
}

