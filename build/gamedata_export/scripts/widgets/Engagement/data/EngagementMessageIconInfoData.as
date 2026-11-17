package widgets.Engagement.data
{
   import flash.display.MovieClip;
   import olympus.controls.WebIconComponent;
   import olympus.objects.UMBaseData;
   
   public class EngagementMessageIconInfoData extends UMBaseData
   {
      
      public var groupId:String;
      
      public var title:String;
      
      public var titleKey:String;
      
      public var tooltiptxt:String;
      
      public var tooltiptxtKey:String;
      
      public var imageURL:String;
      
      public var imageId:String;
      
      public function EngagementMessageIconInfoData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         TranslateKeyFieldToStringField("title");
         TranslateKeyFieldToStringField("tooltiptxt");
         if(!this.HasImageData())
         {
            invisible = UMBaseData.IS_INVISIBLE_TRUE;
         }
      }
      
      public function HasImageData() : Boolean
      {
         return Boolean(this.imageURL) || Boolean(this.imageId);
      }
      
      public function LoadImage(param1:MovieClip, param2:Function, param3:int) : Boolean
      {
         var _loc4_:WebIconComponent = param1.mcImage as WebIconComponent;
         if(!_loc4_ || !this.HasImageData())
         {
            return false;
         }
         if(Boolean(param2))
         {
            _loc4_.addEventListener(WebIconComponent.WEB_ICON_FINISHED_EVENT,param2,false,0,true);
         }
         if(this.imageURL)
         {
            _loc4_.LoadUrl(this.imageURL,param3);
         }
         else
         {
            _loc4_.LoadLocalImage(this.imageId);
         }
         return true;
      }
   }
}

