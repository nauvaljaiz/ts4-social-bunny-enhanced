package widgets.shared.controls
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import gamedata.Exchange.FeedData;
   import gamedata.Exchange.FeedDataFeed;
   import olympus.controls.GUIComponent;
   import olympus.core.ConnectionManager;
   import olympus.events.DataFeedEvent;
   import olympus.io.CommunicationManager;
   import olympus.localization.Keys;
   import widgets.shared.utils.SharedExchangeUtils;
   
   public class BadgeContainer extends GUIComponent
   {
      
      internal static const LABEL_INTRO:String = "intro";
      
      internal static const LABEL_OUTRO:String = "outro";
      
      internal static const LABEL_SMALL:String = "small";
      
      internal static const LABEL_MEDIUM:String = "medium";
      
      internal static const LABEL_LARGE:String = "large";
      
      internal static const LABEL_NEW:String = "new";
      
      public var mcBadge:MovieClip;
      
      public var mcGodRay:MovieClip;
      
      protected var mTextContainer:MovieClip;
      
      protected var txtNumber:TextField;
      
      protected var mValue:int = -1;
      
      public function BadgeContainer()
      {
         super();
      }
      
      override protected function ConfigUI() : void
      {
         var _loc1_:FeedDataFeed = null;
         this.mTextContainer = this.mcBadge["mcBadge"];
         this.SetValue(0);
         this.mcGodRay.visible = false;
         if(SharedExchangeUtils.IsHomepagePanelAvailable())
         {
            _loc1_ = FeedDataFeed.Instance;
            _loc1_.addEventListener(DataFeedEvent.UPDATE,this.OnFeedUpdate,false,0,true);
            _loc1_.addEventListener(DataFeedEvent.ADD,this.OnFeedUpdate,false,0,true);
            _loc1_.addEventListener(DataFeedEvent.ADD_TO_FRONT,this.OnFeedUpdate,false,0,true);
            _loc1_.addEventListener(DataFeedEvent.REMOVE,this.OnFeedUpdate,false,0,true);
            _loc1_.addEventListener(DataFeedEvent.REMOVE_ALL,this.OnFeedUpdate,false,0,true);
            _loc1_.RequestData(ConnectionManager.IsConnectedToOnlineServices,true);
         }
      }
      
      public function get Value() : int
      {
         return this.mValue;
      }
      
      protected function OnFeedUpdate(param1:DataFeedEvent) : void
      {
         this.SetValue(this.CountNewItemsInDataFeed());
      }
      
      public function CountNewItemsInDataFeed() : int
      {
         var _loc5_:FeedData = null;
         if(CommunicationManager.CallGameService("OptionsGetValue",{"name":"ShowOnlineNotifications"}) == false)
         {
            return 0;
         }
         var _loc1_:FeedDataFeed = FeedDataFeed.Instance;
         var _loc2_:int = 0;
         var _loc3_:int = _loc1_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc1_.RequestItemAt(_loc4_) as FeedData;
            if((Boolean(_loc5_)) && Boolean(_loc5_.isNew) && SharedExchangeUtils.CanShowSocialFeedItemType(_loc5_.feed_type,_loc5_.nucleusid,_loc5_.is_maxis_curated,true))
            {
               _loc2_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      protected function SetValue(param1:int) : void
      {
         if(this.mValue == param1)
         {
            return;
         }
         if(this.mValue == 0)
         {
            this.mcGodRay.visible = true;
            this.mcGodRay.gotoAndPlay(0);
            visible = true;
            gotoAndPlay(LABEL_INTRO);
         }
         this.mValue = param1;
         if(param1 == 0)
         {
            gotoAndPlay(LABEL_OUTRO);
            return;
         }
         var _loc2_:String = LABEL_SMALL;
         var _loc3_:String = param1.toString();
         if(param1 > 99)
         {
            _loc2_ = LABEL_LARGE;
            _loc3_ = Keys.GAME_TRAY_EXCHANGE_BADGE_ABOVE_NINETY_NINE.toString();
         }
         else if(param1 > 9)
         {
            _loc2_ = LABEL_MEDIUM;
         }
         if(this.mTextContainer.currentLabel != _loc2_)
         {
            this.mTextContainer.gotoAndPlay(_loc2_);
         }
         this.mcBadge.gotoAndPlay(LABEL_NEW);
         this.mTextContainer.txtNumber.text = _loc3_;
      }
   }
}

