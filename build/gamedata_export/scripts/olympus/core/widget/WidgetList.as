package olympus.core.widget
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import olympus.constants.GameStates;
   import olympus.constants.Layers;
   import olympus.core.UIManager;
   import olympus.events.GenericEvent;
   import olympus.io.CommunicationManager;
   import olympus.utils.SystemUtils;
   
   public dynamic class WidgetList
   {
      
      public static const PLATFORM_PC:String = "PC";
      
      public static const PLATFORM_CONSOLE:String = "CONSOLE";
      
      public var mGameStateWidgetsMap:Object;
      
      public var mNameHashMap:Object;
      
      protected var uiMgr:UIManager;
      
      public function WidgetList(param1:UIManager)
      {
         super();
         this.uiMgr = param1;
         this.LoadFromXML();
      }
      
      protected function DispatchComplete() : void
      {
         this.uiMgr.dispatchEvent(new Event(GenericEvent.COMPLETE));
      }
      
      protected function LoadFromXML() : *
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.OnManifestLoadComplete,false,0,true);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.OnManifestLoadFailure,false,0,true);
         _loc1_.load(new URLRequest("widgetlist.xml"));
      }
      
      protected function OnManifestLoadComplete(param1:Event) : void
      {
         var _loc2_:WidgetLoader = null;
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:LayerProps = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:XML = null;
         var _loc14_:WidgetLoader = null;
         var _loc15_:WidgetGameState = null;
         this.mNameHashMap = new Object();
         this.mGameStateWidgetsMap = new Object();
         var _loc3_:URLLoader = param1.target as URLLoader;
         var _loc4_:XML = XML(_loc3_.data);
         for each(_loc5_ in _loc4_.widgets.children())
         {
            if(_loc5_.hasOwnProperty("@platform"))
            {
               _loc9_ = _loc5_.@platform;
               if(_loc9_ == PLATFORM_PC && SystemUtils.UsingController || _loc9_ == PLATFORM_CONSOLE && !SystemUtils.UsingController)
               {
                  continue;
               }
            }
            _loc7_ = XML(_loc5_.layerProps);
            _loc8_ = new LayerProps(Layers[_loc7_.@layer],_loc7_.isModal == "true",_loc7_.suppressModalitySprite == "true");
            _loc2_ = new WidgetLoader(_loc5_.@name,_loc5_.@telemetryName,_loc8_,_loc5_.@onDemandLoad == "true");
            _loc2_.mOnDemandMinTimeBeforeUnload = int(_loc5_.@onDemandMinTimeBeforeUnload);
            _loc2_.mVerticalPositionPercent = Number(_loc5_.position.@vPerc);
            _loc2_.mHorizontalPositionPercent = Number(_loc5_.position.@hPerc);
            _loc2_.mVerticalOriginPercent = Number(_loc5_.origin.@vPerc);
            _loc2_.mHorizontalOriginPercent = Number(_loc5_.origin.@hPerc);
            if(_loc5_.hasOwnProperty("margin"))
            {
               _loc2_.mMargins = new Margin(Number(_loc5_.margin.@top),Number(_loc5_.margin.@right),Number(_loc5_.margin.@bottom),Number(_loc5_.margin.@left));
            }
            _loc2_.mbUseScreenMarginBackground = _loc5_.useScreenMarginBG == "true";
            _loc2_.mbShouldHashName = _loc5_.hashName == "true";
            this[_loc2_.mName] = _loc2_;
            if(_loc2_.mbShouldHashName)
            {
               _loc2_.mNameHash = CommunicationManager.CallGameService("GenerateHash64",_loc2_.mName) as String;
               this.mNameHashMap[_loc2_.mNameHash] = _loc2_.mName;
            }
         }
         for each(_loc6_ in _loc4_.gameStates.children())
         {
            _loc10_ = GameStates.ConvertStateNameToId(_loc6_.@stateName);
            _loc11_ = new Object();
            this.mGameStateWidgetsMap[_loc10_] = _loc11_;
            _loc12_ = 1;
            for each(_loc13_ in _loc6_.children())
            {
               if(_loc13_.hasOwnProperty("@platform"))
               {
                  _loc9_ = _loc13_.@platform;
                  if(_loc9_ == PLATFORM_PC && SystemUtils.UsingController || _loc9_ == PLATFORM_CONSOLE && !SystemUtils.UsingController)
                  {
                     continue;
                  }
               }
               _loc14_ = this[_loc13_.@name] as WidgetLoader;
               if(_loc14_)
               {
                  if(_loc13_.hasOwnProperty("position"))
                  {
                     _loc15_ = new WidgetGameState(_loc10_,_loc13_.@visible != "false",Number(_loc13_.position.@vPerc),Number(_loc13_.position.@hPerc),Number(_loc13_.origin.@vPerc),Number(_loc13_.origin.@hPerc));
                  }
                  else
                  {
                     _loc15_ = new WidgetGameState(_loc10_,_loc13_.@visible != "false");
                  }
                  _loc15_.mPriority = int.MAX_VALUE - _loc12_;
                  if(!_loc14_.mGameStateMap)
                  {
                     _loc14_.mGameStateMap = new Object();
                  }
                  _loc14_.mGameStateMap[_loc10_] = _loc15_;
                  _loc11_[_loc14_.mName] = _loc14_;
                  _loc12_++;
               }
            }
         }
         this.DispatchComplete();
      }
      
      protected function OnManifestLoadFailure(param1:Event) : void
      {
      }
   }
}

