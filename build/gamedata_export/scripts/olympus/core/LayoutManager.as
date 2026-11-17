package olympus.core
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getTimer;
   import olympus.constants.Layers;
   import olympus.core.widget.LayerProps;
   import olympus.core.widget.Margin;
   import olympus.core.widget.WidgetBase;
   import olympus.core.widget.WidgetGameState;
   import olympus.core.widget.WidgetList;
   import olympus.core.widget.WidgetLoader;
   import olympus.events.GenericEvent;
   import olympus.gamepad.EnterParams;
   import olympus.gamepad.LayoutAPI;
   import olympus.io.CommunicationManager;
   import olympus.utils.DisplayObjectUtils;
   import olympus.utils.SystemUtils;
   import scaleform.clik.managers.FocusHandler;
   
   public class LayoutManager
   {
      
      protected static const ON_DEMAND_RETENTION_COUNT:int = 3;
      
      protected static const ON_DEMAND_UNLOAD_WIDGETS_TIME:int = 10000;
      
      protected static const LOAD_WIDGET_PRIORITY:int = 1000;
      
      protected static const CLOCK_PAUSE_HANDLE_NAME:String = "Layout Manager Set Modal Visible";
      
      public static const SCREEN_MARGIN_BACKGROUND_COLOR:uint = 16777215;
      
      protected var mStage:Stage;
      
      protected var mStageSize:Point;
      
      protected var mScreenMarginPcts:Point;
      
      protected var mbScreenMarginsEnabled:Boolean;
      
      public var mWidgetList:WidgetList;
      
      protected var uiMgr:UIManager;
      
      protected var mModalityWidgets:Vector.<WidgetLoader> = new Vector.<WidgetLoader>();
      
      protected var mQueuedWidgets:Vector.<WidgetLoader>;
      
      protected var mLoadingWidget:WidgetLoader;
      
      protected var mLoadedWidgets:Object;
      
      protected var mCurrentGameState:uint;
      
      protected var mOnDemandLoads:Vector.<WidgetLoader>;
      
      protected var mLayers:Vector.<Layer>;
      
      protected var mModalitySprite:Sprite;
      
      protected var mbModalShown:Boolean = false;
      
      protected var mbGameStateCompleteSent:Boolean = false;
      
      protected var mWidgetLayerMask:Shape;
      
      protected var mScreenMarginBGSprite:Sprite;
      
      public function LayoutManager(param1:UIManager)
      {
         super();
         this.uiMgr = param1;
         this.mLoadedWidgets = new Object();
         this.mQueuedWidgets = new Vector.<WidgetLoader>();
         this.mOnDemandLoads = new Vector.<WidgetLoader>();
         param1.addEventListener(GenericEvent.COMPLETE,this.OnWidgetListComplete,false,1,true);
         this.mWidgetList = new WidgetList(param1);
         LayoutAPI.SetManager(this);
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mScreenMarginPcts = new Point();
            this.mbScreenMarginsEnabled = true;
         }
      }
      
      public function Initialize() : void
      {
         var _loc2_:Layer = null;
         this.uiMgr.communicationMgr.RegisterServiceHandler("LoadWidget",this.LoadWidgetHandler,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("UnloadWidget",this.UnloadWidgetHandler,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("UnloadAllWidgets",this.UnloadAllWidgetsHandler,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("IsWidgetVisible",this.HandleIsWidgetVisible,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("IsWidgetVisibleAndNotHiding",this.HandleIsWidgetVisibleAndNotHiding,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("IsWidgetLoaded",this.HandleIsWidgetLoaded,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("IsWidgetLoading",this.HandleIsWidgetLoading,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("IsWidgetTopModal",this.HandleIsWidgetTopModal,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("IsUILoading",this.HandleIsUILoading,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("IsUILoadingScreenVisible",this.HandleIsUILoadingScreenVisible,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("NumberOfModals",this.HandleIsNumberOfModals,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("IsModalVisible",this.HandleIsModalVisible,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("GetLayer",this.HandleGetLayer,"UIContainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("GetWidgetNameFromHash",this.HandleGetWidgetNameFromHash,"UIcontainer");
         this.uiMgr.communicationMgr.RegisterServiceHandler("SetWidgetModality",this.HandleSetWidgetModality,"UIcontainer");
         this.mLayers = new Vector.<Layer>(Layers.count,true);
         var _loc1_:* = int(Layers.count - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = new Layer();
            _loc2_.name = "Layer" + _loc1_;
            this.mLayers[_loc1_] = _loc2_;
            this.uiMgr.addChild(_loc2_);
            if(_loc1_ == Layers.ALWAYS_ON_TOP_NO_INPUT || _loc1_ == Layers.ALWAYS_ON_TOP_TOOLTIP)
            {
               _loc2_.mouseEnabled = false;
               _loc2_.mouseChildren = false;
            }
            if(SystemUtils.UsingConsoleInputMode)
            {
               if(_loc1_ == Layers.WIDGETS)
               {
                  this.mWidgetLayerMask = this.CreateWidgetsLayerMask();
                  this.uiMgr.addChild(this.mWidgetLayerMask);
                  _loc2_.mask = this.mWidgetLayerMask;
               }
            }
            _loc1_--;
         }
         this.mModalitySprite = new Sprite();
         this.mModalitySprite.x = this.mModalitySprite.y = DisplayObjectUtils.MODALITY_BLEED_NEG_HALF;
         this.mScreenMarginBGSprite = new Sprite();
         this.mScreenMarginBGSprite.x = 0;
         this.mScreenMarginBGSprite.y = 0;
         this.mStage = this.uiMgr.stage;
      }
      
      protected function OnWidgetListComplete(param1:Event) : void
      {
         this.uiMgr.removeEventListener(GenericEvent.COMPLETE,this.OnWidgetListComplete);
      }
      
      public function GetLayer(param1:int) : Layer
      {
         if(param1 < Layers.count)
         {
            return this.mLayers[param1] as Layer;
         }
         return null;
      }
      
      public function GetLoadedWidgetByName(param1:String) : WidgetBase
      {
         if(this.mLoadedWidgets[param1])
         {
            return this.mLoadedWidgets[param1].GetWidget();
         }
         return null;
      }
      
      public function GetCurrentModalWidgetsNames() : Array
      {
         var _loc3_:WidgetLoader = null;
         var _loc1_:Array = new Array(this.mModalityWidgets.length);
         var _loc2_:* = 0;
         for each(_loc3_ in this.mModalityWidgets)
         {
            var _loc6_:Number;
            _loc1_[_loc6_ = _loc2_++] = _loc3_.mName;
         }
         return _loc1_;
      }
      
      public function PrepGameStateChange(param1:uint) : void
      {
         var _loc3_:WidgetLoader = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:WidgetLoader = null;
         FocusHandler.getInstance().setFocus(null);
         this.mbGameStateCompleteSent = false;
         if(!this.IsGameStateAvailable(param1))
         {
            return;
         }
         var _loc2_:* = int(this.mModalityWidgets.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this.mModalityWidgets[_loc2_];
            if(!(Boolean(_loc3_.mbOnDemandLoad) && Boolean(_loc3_.GetWidget()) && _loc3_.GetWidget().OnDemandModalRemainVisibleAcrossGameStateChange))
            {
               this.SetWidgetModality(_loc3_,false);
            }
            _loc2_--;
         }
         for each(_loc3_ in this.mQueuedWidgets)
         {
            if(_loc3_.mbOnDemandLoad)
            {
               this.uiMgr.communicationMgr.ClearOnDemandMessagesForWidget(_loc3_.mName);
            }
         }
         this.mQueuedWidgets = new Vector.<WidgetLoader>();
         _loc6_ = new Array();
         for(_loc5_ in this.mLoadedWidgets)
         {
            if(!this.DoesWidgetExistInGameState(_loc5_,param1))
            {
               if(this.mLoadedWidgets[_loc5_].mbOnDemandLoad)
               {
                  this.RemoveOnDemandWidget(this.mLoadedWidgets[_loc5_]);
               }
               _loc6_.push(this.mLoadedWidgets[_loc5_]);
            }
         }
         if(this.mLoadingWidget)
         {
            if(!this.DoesWidgetExistInGameState(this.mLoadingWidget.mName,param1))
            {
               if(this.mLoadingWidget.mbOnDemandLoad)
               {
                  this.RemoveOnDemandWidget(this.mLoadingWidget);
               }
               _loc6_.push(this.mLoadingWidget);
            }
         }
         for each(_loc7_ in _loc6_)
         {
            this.UnloadWidget(_loc7_);
         }
         this.uiMgr.communicationMgr.RemoveWidgetFunctions("OnDemandLoad");
      }
      
      public function SwitchToGameState(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc4_:WidgetLoader = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!this.IsGameStateAvailable(param1))
         {
            this.GameStateLoadComplete();
            return;
         }
         var _loc3_:Object = this.mWidgetList.mGameStateWidgetsMap[param1];
         this.mCurrentGameState = param1;
         for(_loc2_ in _loc3_)
         {
            _loc4_ = _loc3_[_loc2_] as WidgetLoader;
            if(_loc4_.mbOnDemandLoad)
            {
               this.SetupOnDemandWidgetLoad(_loc4_);
            }
            else if(this.mLoadedWidgets[_loc2_])
            {
               this.PositionWidget(_loc4_);
            }
            else if(this.mLoadingWidget != _loc4_)
            {
               this.LoadWidget(_loc4_,_loc4_.GetVisibilityInGameState(param1));
            }
         }
         this.ResortAllWidgets();
         this.ReinsertAllModalityWidgets();
         if(!this.IsLoadingWidgets())
         {
            this.GameStateLoadComplete();
         }
      }
      
      public function IsLoadingWidgets() : Boolean
      {
         return this.mLoadingWidget != null || this.mQueuedWidgets.length > 0;
      }
      
      public function IsLoadingNamedWidget(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         if(this.mLoadingWidget != null && this.mLoadingWidget.mName == param1)
         {
            return true;
         }
         var _loc3_:int = int(this.mQueuedWidgets.length);
         while(_loc2_ < _loc3_)
         {
            if(this.mQueuedWidgets[_loc2_].mName == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      protected function LoadWidgetHandler(param1:Object) : Boolean
      {
         var _loc2_:String = param1.widgetName;
         var _loc3_:WidgetLoader = this.mWidgetList[_loc2_];
         var _loc4_:Boolean = this.DoesWidgetExistInGameState(_loc2_,this.uiMgr.mGameState);
         if(!_loc4_)
         {
            return false;
         }
         if(_loc3_)
         {
            this.LoadWidget(_loc3_);
            return true;
         }
         return false;
      }
      
      protected function UnloadWidgetHandler(param1:Object) : Boolean
      {
         var _loc2_:String = param1.widgetName;
         var _loc3_:WidgetLoader = this.mLoadedWidgets[_loc2_];
         if(_loc3_)
         {
            return this.UnloadWidget(_loc3_);
         }
         return false;
      }
      
      protected function UnloadAllWidgetsHandler(param1:Object) : Boolean
      {
         var _loc2_:String = null;
         FocusHandler.getInstance().setFocus(null);
         for(_loc2_ in this.mLoadedWidgets)
         {
            this.UnloadWidget(this.mLoadedWidgets[_loc2_]);
         }
         if(this.mLoadingWidget)
         {
            this.UnloadWidget(this.mLoadingWidget);
         }
         return true;
      }
      
      protected function DebugWidgetHandler(param1:Object) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc2_:String = param1.widgetName;
         var _loc3_:WidgetLoader = this.mWidgetList[_loc2_];
         if(_loc3_)
         {
            if(!_loc3_.mbDebugging)
            {
               _loc3_.mbDebugging = true;
               this.LoadWidget(_loc3_,true);
               return true;
            }
            _loc3_.mbDebugging = false;
            _loc4_ = this.DoesWidgetExistInGameState(_loc3_.mName,this.uiMgr.mGameState);
            if(!_loc4_)
            {
               return this.UnloadWidget(_loc3_);
            }
         }
         return false;
      }
      
      protected function HandleIsWidgetVisible(param1:Object) : Boolean
      {
         var _loc2_:String = param1 as String;
         return this.IsWidgetVisible(_loc2_);
      }
      
      protected function HandleIsWidgetVisibleAndNotHiding(param1:Object) : Boolean
      {
         var _loc2_:String = param1 as String;
         return this.IsWidgetVisibleAndNotHiding(_loc2_);
      }
      
      protected function HandleIsWidgetLoaded(param1:Object) : Boolean
      {
         var _loc2_:String = param1 as String;
         return this.GetLoadedWidgetByName(_loc2_) != null;
      }
      
      protected function HandleIsWidgetLoading(param1:Object) : Boolean
      {
         var _loc2_:String = param1 as String;
         return this.IsLoadingNamedWidget(_loc2_);
      }
      
      public function IsWidgetVisible(param1:String) : Boolean
      {
         var _loc3_:WidgetBase = null;
         var _loc2_:WidgetLoader = this.mLoadedWidgets[param1];
         if(_loc2_)
         {
            _loc3_ = _loc2_.GetWidget();
            return _loc3_.visible;
         }
         return false;
      }
      
      public function IsWidgetVisibleAndNotHiding(param1:String) : Boolean
      {
         var _loc3_:WidgetBase = null;
         var _loc2_:WidgetLoader = this.mLoadedWidgets[param1];
         if(_loc2_)
         {
            _loc3_ = _loc2_.GetWidget();
            return _loc3_.visible && !_loc3_.IsAnimatingHide;
         }
         return false;
      }
      
      public function IsWidgetReadyToEnter(param1:String, param2:EnterParams = null) : Boolean
      {
         var _loc4_:WidgetBase = null;
         var _loc3_:WidgetLoader = this.mLoadedWidgets[param1];
         if(_loc3_)
         {
            _loc4_ = _loc3_.GetWidget();
            return _loc4_.IsReadyToEnter(param2);
         }
         return false;
      }
      
      protected function HandleIsWidgetTopModal(param1:Object) : Boolean
      {
         var _loc4_:Vector.<WidgetLoader> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:String = param1 as String;
         var _loc3_:WidgetLoader = this.mLoadedWidgets[_loc2_];
         if(_loc3_)
         {
            _loc4_ = this.mModalityWidgets;
            if(_loc4_.indexOf(_loc3_) < 0)
            {
               return _loc4_.length == 0;
            }
            _loc5_ = _loc3_.GetPriorityInGameState(this.mCurrentGameState);
            _loc6_ = 0;
            _loc7_ = int(_loc4_.length);
            while(_loc6_ < _loc7_)
            {
               if(_loc4_[_loc6_].GetPriorityInGameState(this.mCurrentGameState) > _loc5_)
               {
                  return false;
               }
               _loc6_++;
            }
            return true;
         }
         return false;
      }
      
      protected function HandleIsUILoading(param1:Object) : Boolean
      {
         if(!this.mbGameStateCompleteSent)
         {
            return true;
         }
         if(this.mLoadingWidget)
         {
            return true;
         }
         var _loc2_:WidgetLoader = this.mLoadedWidgets["TransitionScreenMolecule"];
         if(_loc2_)
         {
            return _loc2_.GetWidget().visible;
         }
         return false;
      }
      
      protected function HandleIsUILoadingScreenVisible(param1:Object) : Boolean
      {
         if(!this.mbGameStateCompleteSent)
         {
            return true;
         }
         var _loc2_:WidgetLoader = this.mLoadedWidgets["TransitionScreenMolecule"];
         if(_loc2_)
         {
            return _loc2_.GetWidget().visible;
         }
         return false;
      }
      
      protected function HandleIsNumberOfModals(param1:Object) : int
      {
         return this.mModalityWidgets.length;
      }
      
      protected function HandleIsModalVisible(param1:Object) : Boolean
      {
         return this.mbModalShown;
      }
      
      protected function HandleGetLayer(param1:Object) : Object
      {
         return this.GetLayer(param1["layer"]);
      }
      
      protected function HandleGetWidgetNameFromHash(param1:Object) : String
      {
         var _loc2_:WidgetLoader = null;
         var _loc3_:String = param1 as String;
         if(Boolean(_loc3_) && _loc3_ in this.mWidgetList.mNameHashMap)
         {
            return this.mWidgetList.mNameHashMap[_loc3_];
         }
         return null;
      }
      
      protected function HandleSetWidgetModality(param1:Object) : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:String = param1.widgetName as String;
         var _loc3_:WidgetLoader = this.mLoadedWidgets[_loc2_];
         if(_loc3_)
         {
            _loc4_ = param1.bOn as Boolean;
            this.SetWidgetModality(_loc3_,_loc4_);
         }
      }
      
      protected function LoadWidget(param1:WidgetLoader, param2:Boolean = true) : void
      {
         param1.visible = param2;
         if(this.mLoadingWidget)
         {
            this.mQueuedWidgets.push(param1);
         }
         else
         {
            this.BeginWidgetLoad(param1);
         }
      }
      
      protected function BeginWidgetLoad(param1:WidgetLoader) : void
      {
         var _loc2_:String = param1.mName;
         if(Boolean(this.mLoadedWidgets[_loc2_]) || Boolean(this.mLoadingWidget))
         {
            return;
         }
         var _loc3_:URLRequest = new URLRequest(_loc2_ + ".swf");
         if(param1.mbOnDemandLoad)
         {
            param1.contentLoaderInfo.addEventListener(Event.COMPLETE,this.OnDemandWidgetLoadComplete);
            param1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.OnDemandWidgetLoadFail);
         }
         param1.contentLoaderInfo.addEventListener(Event.COMPLETE,this.LoadWidgetCompleteHandler,false,LOAD_WIDGET_PRIORITY,true);
         param1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.LoadWidgetErrorHandler,false,LOAD_WIDGET_PRIORITY,true);
         this.mLoadingWidget = param1;
         param1.load(_loc3_,new LoaderContext(false,ApplicationDomain.currentDomain));
      }
      
      protected function UnloadWidget(param1:WidgetLoader) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:String = param1.mName;
         if(this.mLoadingWidget == param1)
         {
            if(param1.mbUseScreenMarginBackground)
            {
               this.ShowScreenMarginBackground(false);
            }
            param1.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.LoadWidgetCompleteHandler);
            param1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.LoadWidgetErrorHandler);
            if(param1.mbOnDemandLoad)
            {
               param1.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.OnDemandWidgetLoadComplete);
               param1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.OnDemandWidgetLoadFail);
               this.uiMgr.communicationMgr.ClearOnDemandMessagesForWidget(_loc2_);
            }
            param1.close();
            this.mLoadingWidget = null;
            this.uiMgr.communicationMgr.SendUIMessage("Unloaded" + _loc2_,null);
            return true;
         }
         if(this.mLoadedWidgets[_loc2_])
         {
            if(param1.mbUseScreenMarginBackground)
            {
               this.ShowScreenMarginBackground(false);
            }
            if(param1.GetWidget())
            {
               param1.GetWidget().Unload();
            }
            this.GetLayer(param1.mLayerProps.Layer).removeChild(param1);
            param1.unloadAndStop(false);
            delete this.mLoadedWidgets[_loc2_];
            this.uiMgr.communicationMgr.SendUIMessage("Unloaded" + _loc2_,null);
            return true;
         }
         return false;
      }
      
      protected function IsGameStateAvailable(param1:uint) : Boolean
      {
         return this.mWidgetList.mGameStateWidgetsMap[param1] != null;
      }
      
      protected function DoesWidgetExistInGameState(param1:String, param2:uint) : Boolean
      {
         var _loc3_:Object = this.mWidgetList.mGameStateWidgetsMap[param2];
         if(Boolean(_loc3_) && Boolean(_loc3_[param1]))
         {
            return true;
         }
         return false;
      }
      
      public function StageResized(param1:Number, param2:Number) : void
      {
         this.mStageSize = new Point(param1,param2);
         this.RepositionAllWidgets();
         if(SystemUtils.UsingConsoleInputMode)
         {
            this.mScreenMarginBGSprite.graphics.clear();
            this.mScreenMarginBGSprite.graphics.beginFill(SCREEN_MARGIN_BACKGROUND_COLOR);
            this.mScreenMarginBGSprite.graphics.drawRect(0,0,param1,param2);
            this.mScreenMarginBGSprite.graphics.endFill();
            this.UpdateMaskSize();
         }
         DisplayObjectUtils.DrawModality(this.mModalitySprite.graphics,param1,param2);
      }
      
      public function RepositionAllWidgets() : void
      {
         var _loc1_:WidgetLoader = null;
         for each(_loc1_ in this.mLoadedWidgets)
         {
            this.PositionWidget(_loc1_,false);
         }
      }
      
      public function ResortAllWidgets() : void
      {
         var _loc1_:WidgetLoader = null;
         for each(_loc1_ in this.mLoadedWidgets)
         {
            this.ResortWidgetWithinLayer(_loc1_);
         }
      }
      
      public function ReinsertAllModalityWidgets() : void
      {
         var _loc1_:Vector.<WidgetLoader> = null;
         var _loc2_:WidgetLoader = null;
         if(this.mModalityWidgets.length > 0)
         {
            _loc1_ = this.mModalityWidgets;
            this.mModalityWidgets = new Vector.<WidgetLoader>();
            for each(_loc2_ in _loc1_)
            {
               this.SetWidgetModality(_loc2_,true,false);
            }
         }
      }
      
      protected function CreateWidgetsLayerMask() : Shape
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.lineStyle(1,0);
         _loc1_.graphics.beginFill(16711680);
         _loc1_.graphics.drawRect(0,0,this.uiMgr.stage.stageWidth - 2 * this.mScreenMarginPcts.x * this.uiMgr.stage.stageWidth,this.uiMgr.stage.stageHeight - 2 * this.mScreenMarginPcts.y * this.uiMgr.stage.stageHeight);
         _loc1_.x = this.mScreenMarginPcts.x * this.uiMgr.stage.stageWidth;
         _loc1_.y = this.mScreenMarginPcts.y * this.uiMgr.stage.stageHeight;
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      protected function PositionWidget(param1:WidgetLoader, param2:Boolean = true) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Margin = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc3_:WidgetBase = param1.GetWidget();
         var _loc4_:DisplayObject = _loc3_.mcPositionHelper as DisplayObject;
         var _loc5_:uint = this.uiMgr.mGameState;
         var _loc6_:WidgetGameState = param1.GetGameStateSettings(_loc5_);
         if(this.uiMgr.stage)
         {
            _loc7_ = this.mbScreenMarginsEnabled ? this.StageWidth : this.uiMgr.stage.stageWidth;
            _loc8_ = this.mbScreenMarginsEnabled ? this.StageHeight : this.uiMgr.stage.stageHeight;
            _loc9_ = param1.mMargins;
            _loc10_ = _loc7_ - _loc9_.mRight;
            _loc11_ = _loc8_ - _loc9_.mBot;
            _loc12_ = 0;
            _loc13_ = 0;
            _loc14_ = 0;
            _loc15_ = 0;
            if(Boolean(_loc6_) && _loc6_.mDefinedPosition)
            {
               _loc14_ = _loc10_ * _loc6_.mHorizontalPositionPercent;
               _loc15_ = _loc11_ * _loc6_.mVerticalPositionPercent;
               _loc12_ = _loc4_.width * _loc6_.mHorizontalOriginPercent;
               _loc13_ = _loc4_.height * _loc6_.mVerticalOriginPercent;
            }
            else
            {
               _loc14_ = _loc10_ * param1.mHorizontalPositionPercent;
               _loc15_ = _loc11_ * param1.mVerticalPositionPercent;
               _loc12_ = _loc4_.width * param1.mHorizontalOriginPercent;
               _loc13_ = _loc4_.height * param1.mVerticalOriginPercent;
            }
            param1.x = _loc14_ - _loc12_ - _loc4_.x + _loc9_.mLeft;
            param1.y = _loc15_ - _loc13_ - _loc4_.y + _loc9_.mTop;
            if(this.mbScreenMarginsEnabled)
            {
               param1.x += this.mScreenMarginPcts.x * this.uiMgr.stage.stageWidth;
               param1.y += this.mScreenMarginPcts.y * this.uiMgr.stage.stageHeight;
            }
            _loc3_.HandleStageResized(_loc7_,_loc8_);
            if(param2)
            {
               this.ResortWidgetWithinLayer(param1);
            }
         }
      }
      
      protected function ResortWidgetWithinLayer(param1:WidgetLoader) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:WidgetLoader = null;
         if(!param1.parent)
         {
            return;
         }
         var _loc2_:int = param1.GetPriorityInGameState(this.mCurrentGameState);
         var _loc3_:Layer = this.GetLayer(param1.mLayerProps.Layer);
         if(_loc3_ != param1.parent)
         {
            return;
         }
         var _loc4_:int = _loc3_.numChildren;
         var _loc5_:int = _loc3_.getChildIndex(param1);
         if(_loc2_ == 0)
         {
            _loc3_.setChildIndex(param1,0);
         }
         else
         {
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               if(_loc5_ == _loc7_)
               {
                  _loc6_ = 1;
               }
               else
               {
                  _loc8_ = _loc3_.getChildAt(_loc7_) as WidgetLoader;
                  if(_loc8_)
                  {
                     if(_loc8_.GetPriorityInGameState(this.mCurrentGameState) > _loc2_)
                     {
                        _loc3_.setChildIndex(param1,_loc7_ == 0 ? 0 : int(_loc7_ - _loc6_));
                        break;
                     }
                  }
               }
               _loc7_++;
            }
         }
      }
      
      protected function SetWidgetModality(param1:WidgetLoader, param2:Boolean, param3:Boolean = true) : void
      {
         var _loc6_:* = 0;
         var _loc4_:Layer = this.GetLayer(param1.mLayerProps.Layer);
         var _loc5_:Vector.<WidgetLoader> = this.mModalityWidgets;
         var _loc7_:* = int(_loc5_.length);
         var _loc8_:Boolean = false;
         _loc6_ = int(_loc7_ - 1);
         while(_loc6_ >= 0)
         {
            if(param1 == _loc5_[_loc6_])
            {
               this.ResortWidgetWithinLayer(_loc5_[_loc6_]);
               _loc5_.splice(_loc6_,1);
               _loc7_--;
               _loc8_ = true;
               break;
            }
            _loc6_--;
         }
         var _loc9_:Boolean = false;
         if(param2)
         {
            if(!_loc8_ && param3)
            {
               _loc9_ = true;
               CommunicationManager.CallGameService("PostServerCommand",{
                  "command":"clock.request_pause",
                  "commandArgs":[CLOCK_PAUSE_HANDLE_NAME]
               });
            }
         }
         else
         {
            if(_loc8_ && this.mbModalShown)
            {
               if(param3)
               {
                  _loc9_ = true;
                  CommunicationManager.CallGameService("PostServerCommand",{
                     "command":"clock.unrequest_pause",
                     "commandArgs":[CLOCK_PAUSE_HANDLE_NAME]
                  });
               }
               _loc4_.removeChild(this.mModalitySprite);
               this.mbModalShown = false;
            }
            if(_loc7_ == 0)
            {
               this.ResortAllWidgets();
               if(_loc9_)
               {
                  CommunicationManager.SendMessage("SetModalVisible",param2);
               }
               return;
            }
            param1 = _loc5_[_loc7_ - 1];
            _loc4_ = this.GetLayer(param1.mLayerProps.Layer);
         }
         if(this.mbModalShown)
         {
            _loc4_.removeChild(this.mModalitySprite);
            if(_loc7_ > 0)
            {
               this.ResortWidgetWithinLayer(_loc5_[_loc7_ - 1]);
            }
            this.mbModalShown = false;
         }
         if(!param1.mLayerProps.SuppressModalitySprite)
         {
            _loc4_.addChildAt(this.mModalitySprite,_loc4_.numChildren);
         }
         _loc4_.setChildIndex(param1,_loc4_.numChildren - 1);
         this.mbModalShown = true;
         if(param2)
         {
            _loc5_.push(param1);
         }
         if(_loc9_)
         {
            CommunicationManager.SendMessage("SetModalVisible",param2);
         }
      }
      
      public function HandleEscapeKey() : Boolean
      {
         var _loc1_:int = int(this.mModalityWidgets.length);
         if(_loc1_ > 0)
         {
            CommunicationManager.CallUIService("RequestHide" + this.mModalityWidgets[_loc1_ - 1].mName,null);
            return true;
         }
         return false;
      }
      
      protected function LoadWidgetCompleteHandler(param1:Event) : void
      {
         var widget:WidgetBase;
         var widgetName:String;
         var layerProps:LayerProps;
         var widgetLoader:WidgetLoader = null;
         var event:Event = param1;
         widgetLoader = event.target.loader as WidgetLoader;
         widgetLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.LoadWidgetCompleteHandler);
         widgetLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.LoadWidgetErrorHandler);
         widget = widgetLoader.GetWidget();
         widgetName = widgetLoader.mName;
         layerProps = widgetLoader.mLayerProps;
         if(widgetLoader.mbUseScreenMarginBackground)
         {
            this.ShowScreenMarginBackground(true);
         }
         widget.WidgetName = widgetName;
         widget.TelemetryName = widgetLoader.mTelemetryName;
         this.GetLayer(layerProps.Layer).addChild(widgetLoader);
         if(layerProps.IsModal)
         {
            widget.SetShouldAddToControllerSimulatedStack(true);
            this.uiMgr.communicationMgr.AddMessageListener("Show" + widgetName,function(param1:Object):void
            {
               if(!mbModalShown)
               {
                  ResortAllWidgets();
               }
               if(!SystemUtils.UsingController)
               {
                  PopUpManager.Unload();
               }
               SetWidgetModality(widgetLoader,true);
            },widgetName);
            this.uiMgr.communicationMgr.AddMessageListener("HideComplete" + widgetName,function(param1:Object):void
            {
               SetWidgetModality(widgetLoader,false);
            },widgetName);
         }
         this.PositionWidget(widgetLoader);
         widget.visible = widgetLoader.visible;
         widgetLoader.visible = this.mbGameStateCompleteSent || widgetLoader.mName == "TransitionScreenMolecule";
         widget.Initialize();
         this.mLoadedWidgets[widgetLoader.mName] = widgetLoader;
         this.mLoadingWidget = null;
         this.uiMgr.communicationMgr.SendUIMessage("Loaded" + widgetName,{
            "loaded":true,
            "widget":widgetName
         });
         if(this.mQueuedWidgets.length > 0)
         {
            this.BeginWidgetLoad(this.mQueuedWidgets.shift());
         }
         else if(!this.mbGameStateCompleteSent)
         {
            this.GameStateLoadComplete();
         }
      }
      
      protected function LoadWidgetErrorHandler(param1:Event) : void
      {
         var _loc2_:WidgetLoader = param1.target.loader as WidgetLoader;
         var _loc3_:String = _loc2_.mName;
         this.uiMgr.communicationMgr.SendUIMessage("Loaded" + _loc3_,{
            "loaded":false,
            "widget":_loc3_
         });
         _loc2_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.LoadWidgetCompleteHandler);
         _loc2_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.LoadWidgetErrorHandler);
         this.mLoadingWidget = null;
      }
      
      protected function GameStateLoadComplete() : void
      {
         var _loc1_:WidgetLoader = null;
         this.mbGameStateCompleteSent = true;
         this.uiMgr.GameStateLoadComplete();
         for each(_loc1_ in this.mLoadedWidgets)
         {
            _loc1_.visible = true;
         }
      }
      
      protected function SetupOnDemandWidgetLoad(param1:WidgetLoader) : void
      {
         var widgetLoader:WidgetLoader = param1;
         var onDemandFunction:Function = function(param1:Object):void
         {
            OnDemandWidgetLoad(widgetLoader);
         };
         this.uiMgr.communicationMgr.AddMessageListener("Show" + widgetLoader.mName,onDemandFunction,"OnDemandLoad");
         this.uiMgr.communicationMgr.AddMessageListener("Toggle" + widgetLoader.mName,onDemandFunction,"OnDemandLoad");
      }
      
      protected function OnDemandWidgetLoad(param1:WidgetLoader) : void
      {
         var _loc2_:WidgetLoader = null;
         if(Boolean(this.mLoadedWidgets[param1.mName]) || this.mLoadingWidget == param1)
         {
            return;
         }
         for each(_loc2_ in this.mQueuedWidgets)
         {
            if(_loc2_ == param1)
            {
               return;
            }
         }
         if(this.mOnDemandLoads.length >= ON_DEMAND_RETENTION_COUNT)
         {
            Ticker.Add(this,1,this.CleanOnDemandWidgets);
         }
         else
         {
            Ticker.Add(this,ON_DEMAND_UNLOAD_WIDGETS_TIME,this.CleanOnDemandWidgets);
         }
         this.uiMgr.communicationMgr.StoreOnDemandMessagesForWidget(param1.mName);
         this.LoadWidget(param1,false);
      }
      
      protected function RemoveOnDemandWidget(param1:WidgetLoader) : void
      {
         var _loc2_:int = this.mOnDemandLoads.indexOf(param1);
         if(_loc2_ > -1)
         {
            this.mOnDemandLoads.splice(_loc2_,1);
         }
      }
      
      protected function CleanOnDemandWidgets() : void
      {
         var _loc4_:WidgetLoader = null;
         var _loc5_:WidgetBase = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc1_:int = int(this.mOnDemandLoads.length);
         var _loc2_:int = ON_DEMAND_UNLOAD_WIDGETS_TIME;
         var _loc3_:* = int(_loc1_ - 1);
         for(; _loc3_ >= 0; _loc3_--)
         {
            _loc4_ = this.mOnDemandLoads[_loc3_];
            _loc5_ = _loc4_.GetWidget();
            if(_loc5_.CanOnDemandAutoUnload)
            {
               if(_loc4_.mOnDemandMinTimeBeforeUnload != 0)
               {
                  _loc6_ = getTimer() - _loc5_.LastHideTime;
                  _loc7_ = _loc4_.mOnDemandMinTimeBeforeUnload * 1000;
                  if(_loc6_ < _loc7_)
                  {
                     _loc8_ = _loc7_ - _loc6_;
                     if(_loc8_ < _loc2_)
                     {
                        _loc2_ = _loc8_;
                     }
                     continue;
                  }
               }
               this.UnloadWidget(_loc4_);
               this.mOnDemandLoads.splice(_loc3_,1);
            }
         }
         if(this.mOnDemandLoads.length < _loc1_)
         {
            CommunicationManager.CallGameService("ScheduleGCCollect",0,true);
         }
         if(this.mOnDemandLoads.length > 0)
         {
            Ticker.Add(this,_loc2_,this.CleanOnDemandWidgets);
         }
         else
         {
            Ticker.Remove(this);
         }
      }
      
      protected function OnDemandWidgetLoadComplete(param1:Event) : void
      {
         var _loc2_:WidgetLoader = param1.target.loader as WidgetLoader;
         this.mOnDemandLoads.push(_loc2_);
         _loc2_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.OnDemandWidgetLoadComplete);
         _loc2_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.OnDemandWidgetLoadFail);
         this.uiMgr.communicationMgr.DispatchStoredOnDemandMessages(_loc2_.mName);
      }
      
      protected function OnDemandWidgetLoadFail(param1:Event) : void
      {
         var _loc2_:WidgetLoader = param1.target.loader as WidgetLoader;
         _loc2_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.OnDemandWidgetLoadComplete);
         _loc2_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.OnDemandWidgetLoadFail);
      }
      
      public function GetStage() : Stage
      {
         return this.mStage;
      }
      
      public function GetStageSize(param1:Boolean = false) : Point
      {
         if(param1 || !SystemUtils.UsingController)
         {
            return this.mStageSize.clone();
         }
         return new Point(this.StageWidth,this.StageHeight);
      }
      
      public function get StageWidth() : int
      {
         return this.mbScreenMarginsEnabled ? int(this.mStageSize.x - 2 * this.mScreenMarginPcts.x * this.uiMgr.stage.stageWidth) : int(this.mStageSize.x);
      }
      
      public function get StageHeight() : int
      {
         return this.mbScreenMarginsEnabled ? int(this.mStageSize.y - 2 * this.mScreenMarginPcts.y * this.uiMgr.stage.stageHeight) : int(this.mStageSize.y);
      }
      
      public function GetScreenMarginPcts() : Point
      {
         return this.mbScreenMarginsEnabled ? this.mScreenMarginPcts : new Point();
      }
      
      public function SetScreenMarginPcts(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = new Point(Math.max(0,param1),Math.max(0,param2));
         if(_loc3_ != this.mScreenMarginPcts)
         {
            this.mScreenMarginPcts = _loc3_;
            this.RepositionAllWidgets();
            this.UpdateMaskSize();
            if(SystemUtils.UsingController)
            {
               CommunicationManager.SendUIMessage("UpdateVirtualCursorRestraints");
            }
         }
      }
      
      public function GetScreenMarginsEnabled() : Boolean
      {
         return this.mbScreenMarginsEnabled;
      }
      
      public function SetScreenMarginsEnabled(param1:Boolean) : void
      {
         if(this.mbScreenMarginsEnabled != param1)
         {
            this.mbScreenMarginsEnabled = param1;
            this.RepositionAllWidgets();
            this.UpdateMaskSize();
         }
      }
      
      protected function UpdateMaskSize() : void
      {
         if(this.mbScreenMarginsEnabled)
         {
            this.mWidgetLayerMask.width = this.StageWidth;
            this.mWidgetLayerMask.height = this.StageHeight;
            this.mWidgetLayerMask.x = this.mScreenMarginPcts.x * this.uiMgr.stage.stageWidth;
            this.mWidgetLayerMask.y = this.mScreenMarginPcts.y * this.uiMgr.stage.stageHeight;
         }
         else
         {
            this.mWidgetLayerMask.width = this.uiMgr.stage.stageWidth;
            this.mWidgetLayerMask.height = this.uiMgr.stage.stageHeight;
            this.mWidgetLayerMask.x = 0;
            this.mWidgetLayerMask.y = 0;
         }
      }
      
      protected function ShowScreenMarginBackground(param1:Boolean) : *
      {
         var _loc2_:Layer = null;
         if(SystemUtils.UsingConsoleInputMode)
         {
            _loc2_ = this.GetLayer(Layers.SCREEN_MARGINS_BACKGROUND);
            if(param1)
            {
               if(this.mScreenMarginBGSprite.parent != _loc2_)
               {
                  _loc2_.addChild(this.mScreenMarginBGSprite);
               }
            }
            else if(this.mScreenMarginBGSprite.parent == _loc2_)
            {
               _loc2_.removeChild(this.mScreenMarginBGSprite);
            }
         }
      }
      
      public function IsLockCursorVisible() : Boolean
      {
         return this.uiMgr.IsLockCursorVisible();
      }
   }
}

