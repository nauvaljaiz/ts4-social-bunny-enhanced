package olympus.extensions
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import gamedata.TutorialTip.TutorialTipStaticData;
   import olympus.audio.Audio;
   import olympus.constants.DialogTypes;
   import olympus.controls.GUIComponent;
   import olympus.dialog.DialogManager;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.io.CommunicationManager;
   import olympus.io.EventManager;
   import olympus.localization.Keys;
   import olympus.localization.LocKey;
   import olympus.utils.SystemUtils;
   import olympus.utils.WidgetUtils;
   import widgets.shared.constants.TutorialTipUIElement;
   
   public class TutorialTipExtension implements IExtension
   {
      
      public static const TUTORIAL_TIP_HIDE_COMPLETE:String = "TutorialTipHideComplete";
      
      public static const TUTORIAL_TIP_CLOSED:String = "TutorialTipClosedMessage";
      
      public static const TUTORIAL_TIP_GROUP_SKIPPED:String = "TutorialTipGroupSkippedMessage";
      
      protected static var sTipsPerWidgetMap:Object = {};
      
      protected var mControl:MovieClip;
      
      protected var mControlEnum:String;
      
      protected var mActiveTutorial:TutorialTipStaticData;
      
      protected var mPinnedToControl:Boolean = true;
      
      protected var mbHideImmediatelyOnSatisfy:Boolean;
      
      protected var mSatisfactionEvents:Vector.<String> = new Vector.<String>();
      
      protected var mSatisfactionMessages:Vector.<String> = new Vector.<String>();
      
      protected var mSatisfactionWidgetsVisible:Vector.<String> = new Vector.<String>();
      
      protected var mTimer:Timer;
      
      protected var mHideArgs:Object;
      
      protected var mbHideServiceRegistered:Boolean;
      
      protected var mbVisibilityOverride:Boolean;
      
      protected var mbAnimatingSatisfiedTip:Boolean;
      
      protected var mOverrideTooltipHorizontalAlign:String;
      
      protected var mOverrideTooltipVerticalAlign:String;
      
      protected var mOriginalTooltipHorizontalAlign:String;
      
      protected var mOriginalTooltipVerticalAlign:String;
      
      protected var mbConstantlyUpdatePosition:Boolean = false;
      
      protected var mbInTutorialTipEnded:Boolean = false;
      
      protected var mbIsDismissingActiveTutorialTip:Boolean = false;
      
      public function TutorialTipExtension()
      {
         super();
      }
      
      public static function Get(param1:IExtendable, param2:Boolean = true) : TutorialTipExtension
      {
         return param1.GetExtension(TutorialTipExtension,param2) as TutorialTipExtension;
      }
      
      public static function InitializeOrUpdateStatic(param1:IExtendable, param2:String, param3:Object = 2, param4:Boolean = false) : TutorialTipExtension
      {
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc5_:TutorialTipExtension = Get(param1);
         if(_loc5_.mControlEnum != param2)
         {
            _loc5_.ControlEnum = param2;
         }
         if(param3 is Boolean)
         {
            _loc6_ = param3 as Boolean;
            if(_loc5_.mbVisibilityOverride != _loc6_)
            {
               _loc5_.MarkVisibility(_loc6_);
            }
         }
         if(param4)
         {
            _loc7_ = WidgetUtils.GetBaseName(param1 as MovieClip);
            if(sTipsPerWidgetMap[_loc7_] == null)
            {
               sTipsPerWidgetMap[_loc7_] = new Vector.<TutorialTipExtension>();
               sTipsPerWidgetMap[_loc7_].push(_loc5_);
            }
            else if(sTipsPerWidgetMap[_loc7_].indexOf(_loc5_) < 0)
            {
               sTipsPerWidgetMap[_loc7_].push(_loc5_);
            }
         }
         return _loc5_;
      }
      
      public static function InitializeOrUpdateInteractable(param1:IExtendable, param2:String, param3:Object = 2, param4:String = null, param5:String = null, param6:Boolean = false) : TutorialTipExtension
      {
         var _loc7_:TutorialTipExtension = InitializeOrUpdateStatic(param1,param2,param3,param6);
         if(param4 != null)
         {
            _loc7_.AddSatisfactionEvent(param4);
         }
         if(param5 != null)
         {
            _loc7_.AddSatisfactionMessage(param5);
         }
         return _loc7_;
      }
      
      public static function CreateTutorialTipHelper(param1:MovieClip, param2:String) : GUIComponent
      {
         var _loc3_:GUIComponent = null;
         _loc3_ = new GUIComponent();
         _loc3_.mouseEnabled = false;
         _loc3_.mouseChildren = false;
         var _loc4_:Graphics = _loc3_.graphics;
         _loc4_.clear();
         _loc4_.beginFill(0,0);
         _loc4_.drawRect(0,0,1,1);
         _loc4_.endFill();
         param1.addChild(_loc3_);
         _loc3_.visible = false;
         var _loc5_:TutorialTipExtension = _loc3_.GetExtension(TutorialTipExtension) as TutorialTipExtension;
         _loc5_.ControlEnum = param2;
         _loc5_.ShouldConstantlyUpdatePosition = true;
         return _loc3_;
      }
      
      public static function ShowWidgetVisibleTips(param1:String) : void
      {
         var _loc3_:TutorialTipExtension = null;
         var _loc2_:Vector.<TutorialTipExtension> = sTipsPerWidgetMap[param1];
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc3_.MarkVisibility(_loc3_.mControl.visible);
            }
         }
      }
      
      public static function HideWidgetTips(param1:String) : void
      {
         var _loc3_:TutorialTipExtension = null;
         var _loc2_:Vector.<TutorialTipExtension> = sTipsPerWidgetMap[param1];
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc3_.MarkVisibility(false);
               if(_loc3_.mActiveTutorial)
               {
                  CommunicationManager.CallGameService("GuidanceItemAbort",{
                     "itemId":_loc3_.mActiveTutorial.id,
                     "satisfy":false
                  });
               }
            }
         }
      }
      
      public static function ClearWidgetTips(param1:String) : void
      {
         delete sTipsPerWidgetMap[param1];
      }
      
      public function set ControlEnum(param1:String) : void
      {
         if(this.mControlEnum == param1)
         {
            return;
         }
         if(this.mControlEnum)
         {
            this.MarkVisibility(false);
         }
         this.mControlEnum = param1;
         if(this.mControl.stage)
         {
            this.MarkVisibility(this.mControl.visible);
         }
         this.HandleUpdateDisabledTutorialElements(CommunicationManager.CallGameService("GetDisabledTutorialElements"));
      }
      
      public function set IsPinnedToControl(param1:Boolean) : void
      {
         this.mPinnedToControl = param1;
      }
      
      public function set ShouldHideImmediatelyOnSatisfy(param1:Boolean) : void
      {
         this.mbHideImmediatelyOnSatisfy = param1;
      }
      
      public function get IsActiveTutorial() : Boolean
      {
         return this.mActiveTutorial != null;
      }
      
      public function set OverrideTooltipHorizontalAlignment(param1:String) : void
      {
         this.mOverrideTooltipHorizontalAlign = param1;
      }
      
      public function set OverrideTooltipVerticalAlignment(param1:String) : void
      {
         this.mOverrideTooltipVerticalAlign = param1;
      }
      
      public function set ShouldConstantlyUpdatePosition(param1:Boolean) : void
      {
         this.mbConstantlyUpdatePosition = param1;
      }
      
      public function AddSatisfactionEvent(param1:String) : void
      {
         if(this.mSatisfactionEvents.indexOf(param1) < 0)
         {
            this.mSatisfactionEvents.push(param1);
         }
      }
      
      public function AddSatisfactionMessage(param1:String) : void
      {
         if(this.mSatisfactionMessages.indexOf(param1) < 0)
         {
            this.mSatisfactionMessages.push(param1);
         }
      }
      
      public function AddSatisfactionWidgetVisible(param1:String) : void
      {
         if(this.mSatisfactionWidgetsVisible.indexOf(param1) < 0)
         {
            this.mSatisfactionWidgetsVisible.push(param1);
         }
      }
      
      public function MarkVisibility(param1:Boolean) : void
      {
         this.mbVisibilityOverride = param1;
         if(this.mControlEnum)
         {
            CommunicationManager.CallGameService("MarkElementVisibility",{
               "element_id":this.mControlEnum,
               "visibility":param1
            });
         }
      }
      
      public function Extend(param1:IExtendable) : void
      {
         if(!(param1 is MovieClip))
         {
            throw new Error("Cannot apply TutorialTipExtension to an object which is not a MovieClip!");
         }
         this.mControl = param1 as MovieClip;
         this.mControl.addEventListener(Event.ADDED_TO_STAGE,this.OnControlAddedToStage,false,0,true);
         this.mControl.addEventListener(Event.REMOVED_FROM_STAGE,this.OnControlRemovedFromStage,false,0,true);
         if(this.mControl.stage)
         {
            this.OnControlAddedToStage();
         }
      }
      
      protected function OnControlAddedToStage(param1:Event = null) : void
      {
         CommunicationManager.AddMessageListener("ActivateTutorialTip",this.HandleActivateTutorialTip,this.mControl,TutorialTipStaticData);
         CommunicationManager.AddMessageListener("StageResized",this.HandleStageResized,this.mControl);
         CommunicationManager.AddMessageListener("SetModalVisible",this.HandleSetModalVisible,this.mControl);
         CommunicationManager.AddMessageListener("UpdateDisabledTutorialElements",this.HandleUpdateDisabledTutorialElements,this.mControl);
         this.MarkVisibility(this.mControl.visible);
      }
      
      public function OnControlRemovedFromStage(param1:Event = null) : void
      {
         CommunicationManager.RemoveMessageListener("ActivateTutorialTip",this.HandleActivateTutorialTip,this.mControl);
         CommunicationManager.RemoveMessageListener("DeactivateTutorialTip",this.HandleDeactivateTutorialTip,this.mControl);
         CommunicationManager.RemoveMessageListener("StageResized",this.HandleStageResized,this.mControl);
         CommunicationManager.RemoveMessageListener("SetModalVisible",this.HandleSetModalVisible,this.mControl);
         CommunicationManager.RemoveMessageListener("UpdateDisabledTutorialElements",this.HandleUpdateDisabledTutorialElements,this.mControl);
         if(this.mActiveTutorial)
         {
            this.HandleDeactivateTutorialTip(this.mActiveTutorial.id);
         }
         this.RemoveAllSatisfactionListeners();
         this.MarkVisibility(false);
      }
      
      protected function OnSatisfactionCriteriaMet(param1:Object) : void
      {
         if(this.mbInTutorialTipEnded)
         {
            return;
         }
         var _loc2_:Boolean = param1 ? Boolean(param1.bSkipGroup) : false;
         var _loc3_:Boolean = param1 ? Boolean(param1.bClosed) : false;
         if(Boolean(this.mActiveTutorial) && this.mActiveTutorial.is_modal)
         {
            this.OnTutorialTipHideComplete({
               "satisfied":true,
               "reportToClient":true,
               "bSkipGroup":_loc2_,
               "bClosed":_loc3_
            });
            return;
         }
         this.mbAnimatingSatisfiedTip = true;
         this.DismissActiveTutorialTip(true,true,this.mbHideImmediatelyOnSatisfy,_loc2_,_loc3_);
      }
      
      protected function OnSkipTutorialGroup(param1:Object) : void
      {
         this.OnSatisfactionCriteriaMet({"bSkipGroup":true});
      }
      
      protected function OnTimeout(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = this.mActiveTutorial.timeout_satisfies;
         this.DismissActiveTutorialTip(_loc2_,true,false,false,false,true);
      }
      
      protected function OnTutorialTipClosed(param1:Object) : void
      {
         var _loc2_:String = param1.id as String;
         if(this.mActiveTutorial == null || this.mActiveTutorial.id != _loc2_)
         {
            return;
         }
         var _loc3_:Boolean = param1.bSkipGroup as Boolean;
         this.OnSatisfactionCriteriaMet({
            "bSkipGroup":_loc3_,
            "bClosed":true
         });
      }
      
      protected function OnTutorialTipGroupSkipped(param1:Boolean) : void
      {
         if(this.mActiveTutorial == null)
         {
            return;
         }
         this.OnSatisfactionCriteriaMet({
            "bSkipGroup":true,
            "bClosed":param1
         });
      }
      
      protected function HandleActivateTutorialTip(param1:TutorialTipStaticData) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:TooltipExtension = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         if(param1.ui_element != this.mControlEnum)
         {
            return;
         }
         this.mActiveTutorial = param1;
         this.mbAnimatingSatisfiedTip = false;
         var _loc2_:Object = new Object();
         _loc2_["ui_element"] = param1.ui_element;
         _loc2_["skip"] = false;
         CommunicationManager.SendUIMessage("ValidateTutorialTip",_loc2_);
         if(_loc2_["skip"])
         {
            this.OnSatisfactionCriteriaMet(null);
            return;
         }
         if(this.AreAllSatisfactionWidgetsVisible())
         {
            this.OnSatisfactionCriteriaMet(null);
            return;
         }
         EventManager.DispatchInteractionEvent(Audio.SHOW,"TutorialTip","TutorialTip","NewTutorial");
         CommunicationManager.AddMessageListener("DeactivateTutorialTip",this.HandleDeactivateTutorialTip,this.mControl);
         if(param1.is_modal)
         {
            _loc6_ = param1.text ? param1.text.toString() : "";
            _loc7_ = param1.action_text ? param1.action_text.toString() : "";
            _loc8_ = param1.title ? param1.title.toString() : "";
            CommunicationManager.SendUIMessage("ShowTutorialDialog",{
               "type":DialogTypes.YES_NO,
               "title":_loc8_,
               "description":_loc6_,
               "actionText":_loc7_,
               "options":2,
               "optionOneText":Keys.GENERIC_YES.toString(),
               "optionOneCallback":this.OnSatisfactionCriteriaMet,
               "optionTwoText":Keys.GENERIC_NO.toString(),
               "optionTwoCallback":this.OnSkipTutorialGroup,
               "icon":(param1.icon ? param1.icon.instance : null),
               "dialogId":TutorialTipUIElement.TUTORIAL_DIALOG_ID_PREFIX + param1.display_type_option
            });
            return;
         }
         if(Boolean(this.mOverrideTooltipHorizontalAlign) || Boolean(this.mOverrideTooltipVerticalAlign))
         {
            _loc9_ = TooltipExtension.Get(this.mControl as IExtendable,false);
            if(_loc9_)
            {
               if(this.mOverrideTooltipHorizontalAlign)
               {
                  this.mOriginalTooltipHorizontalAlign = _loc9_.HorizontalAlignment;
                  _loc9_.HorizontalAlignment = this.mOverrideTooltipHorizontalAlign;
               }
               if(this.mOverrideTooltipVerticalAlign)
               {
                  this.mOriginalTooltipVerticalAlign = _loc9_.VerticalAlignment;
                  _loc9_.VerticalAlignment = this.mOverrideTooltipVerticalAlign;
               }
            }
         }
         for each(_loc3_ in this.mSatisfactionEvents)
         {
            this.mControl.addEventListener(_loc3_,this.OnSatisfactionCriteriaMet,false,0,true);
         }
         for each(_loc4_ in this.mSatisfactionMessages)
         {
            CommunicationManager.AddMessageListener(_loc4_,this.HandleSatisfactionMessageReceived,this.mControl);
         }
         CommunicationManager.AddMessageListener(TUTORIAL_TIP_CLOSED,this.OnTutorialTipClosed,this.mControl);
         CommunicationManager.AddMessageListener(TUTORIAL_TIP_GROUP_SKIPPED,this.OnTutorialTipGroupSkipped,this.mControl);
         this.mbIsDismissingActiveTutorialTip = false;
         if(param1.timeout != 0)
         {
            if(this.mTimer)
            {
               this.mTimer.removeEventListener(TimerEvent.TIMER,this.OnTimeout);
               this.mTimer = null;
            }
            this.mTimer = new Timer(param1.timeout * 1000);
            this.mTimer.addEventListener(TimerEvent.TIMER,this.OnTimeout,false,0,true);
            this.mTimer.start();
         }
         if(SystemUtils.UsingController && !param1.cancelable)
         {
            _loc10_ = this.mSatisfactionEvents.length > 0 || this.mSatisfactionMessages.length > 0;
            _loc11_ = Boolean(param1["has_gameplay_immediate_test"]) || Boolean(param1["has_gameplay_test"]);
            param1["cancelable"] = !_loc10_ && !_loc11_;
         }
         var _loc5_:Object = {};
         _loc5_["control"] = this.mPinnedToControl ? this.mControl : null;
         _loc5_["data"] = param1;
         _loc5_["update_position"] = this.mbConstantlyUpdatePosition;
         CommunicationManager.SendUIMessage("ShowTutorialTip",_loc5_);
      }
      
      protected function HandleSatisfactionMessageReceived(param1:Object) : void
      {
         if(this.mbHideServiceRegistered)
         {
            return;
         }
         this.OnSatisfactionCriteriaMet(null);
      }
      
      protected function HandleDeactivateTutorialTip(param1:Object) : void
      {
         var _loc2_:String = param1 as String;
         if(!this.mActiveTutorial || _loc2_ != this.mActiveTutorial.id)
         {
            return;
         }
         if(this.mActiveTutorial.is_modal)
         {
            DialogManager.CancelRequest(TutorialTipUIElement.TUTORIAL_DIALOG_ID_PREFIX + this.mActiveTutorial.display_type_option,false);
            return;
         }
         if(this.mbHideServiceRegistered)
         {
            if(Boolean(this.mHideArgs) && Boolean(this.mHideArgs.reportToClient))
            {
               this.OnTutorialTipHideComplete(this.mHideArgs);
               CommunicationManager.SendUIMessage("HideTutorialTip",{
                  "satisfied":true,
                  "reportToClient":false,
                  "hideImmediately":true,
                  "bSkipGroup":false,
                  "bClosed":true,
                  "bTimeout":false
               });
            }
            else
            {
               CommunicationManager.UnregisterServiceHandler(TUTORIAL_TIP_HIDE_COMPLETE,this.OnTutorialTipHideComplete,this.mControl);
               this.mbHideServiceRegistered = false;
               this.mHideArgs = null;
            }
         }
         this.DismissActiveTutorialTip(false,false,true);
      }
      
      protected function DismissActiveTutorialTip(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false) : void
      {
         var _loc8_:TooltipExtension = null;
         var _loc9_:Boolean = false;
         if(this.mbIsDismissingActiveTutorialTip)
         {
            return;
         }
         this.mbIsDismissingActiveTutorialTip = true;
         if(this.mTimer)
         {
            this.mTimer.removeEventListener(TimerEvent.TIMER,this.OnTimeout,false);
         }
         this.mTimer = null;
         this.RemoveAllSatisfactionListeners();
         CommunicationManager.RemoveMessageListener("DeactivateTutorialTip",this.HandleDeactivateTutorialTip,this.mControl);
         if(!this.mActiveTutorial)
         {
            return;
         }
         if(Boolean(this.mOverrideTooltipHorizontalAlign) || Boolean(this.mOverrideTooltipVerticalAlign))
         {
            _loc8_ = TooltipExtension.Get(this.mControl as IExtendable,false);
            if(_loc8_)
            {
               if(this.mOverrideTooltipHorizontalAlign)
               {
                  _loc8_.HorizontalAlignment = this.mOriginalTooltipHorizontalAlign;
               }
               if(this.mOverrideTooltipVerticalAlign)
               {
                  _loc8_.VerticalAlignment = this.mOriginalTooltipVerticalAlign;
               }
            }
         }
         var _loc7_:Object = {
            "satisfied":param1,
            "reportToClient":param2,
            "hideImmediately":param3,
            "bSkipGroup":param4,
            "bClosed":param5,
            "bTimeout":param6
         };
         if(!param3)
         {
            _loc9_ = CommunicationManager.RegisterServiceHandler(TUTORIAL_TIP_HIDE_COMPLETE,this.OnTutorialTipHideComplete,this.mControl);
            if(_loc9_)
            {
               this.mbHideServiceRegistered = true;
               this.mHideArgs = _loc7_;
               if(!CommunicationManager.SendUIMessage("HideTutorialTip",_loc7_))
               {
                  this.OnTutorialTipHideComplete(this.mHideArgs);
               }
            }
            else
            {
               this.HideImmediately(param1,false,param4,param5,param6);
            }
            return;
         }
         this.HideImmediately(param1,param2,param4,param5,param6);
         CommunicationManager.SendUIMessage("HideTutorialTip",_loc7_);
      }
      
      protected function HideImmediately(param1:Boolean, param2:Boolean, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         this.mbAnimatingSatisfiedTip = false;
         if(param2)
         {
            this.mbInTutorialTipEnded = true;
            CommunicationManager.CallGameService("TutorialTipEnded",{
               "id":this.mActiveTutorial.id,
               "isComplete":param1,
               "isSkipGroup":param3,
               "isClosed":param4,
               "isTimeOut":param5
            });
            this.mbInTutorialTipEnded = false;
         }
         this.mActiveTutorial = null;
      }
      
      protected function OnTutorialTipHideComplete(param1:Object = null) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         CommunicationManager.UnregisterServiceHandler(TUTORIAL_TIP_HIDE_COMPLETE,this.OnTutorialTipHideComplete,this.mControl);
         this.mbHideServiceRegistered = false;
         this.mHideArgs = null;
         if(!this.mActiveTutorial)
         {
            return;
         }
         if(param1.reportToClient)
         {
            _loc2_ = param1.bSkipGroup as Boolean;
            _loc3_ = param1.bClosed as Boolean;
            _loc4_ = param1.bTimeout as Boolean;
            this.mbInTutorialTipEnded = true;
            CommunicationManager.CallGameService("TutorialTipEnded",{
               "id":this.mActiveTutorial.id,
               "isComplete":param1.satisfied,
               "isSkipGroup":_loc2_,
               "isClosed":_loc3_,
               "isTimeOut":_loc4_
            });
            this.mbInTutorialTipEnded = false;
         }
         this.mbAnimatingSatisfiedTip = false;
         this.mActiveTutorial = null;
      }
      
      protected function RemoveAllSatisfactionListeners() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         for each(_loc1_ in this.mSatisfactionEvents)
         {
            this.mControl.removeEventListener(_loc1_,this.OnSatisfactionCriteriaMet);
         }
         for each(_loc2_ in this.mSatisfactionMessages)
         {
            CommunicationManager.RemoveMessageListener(_loc2_,this.OnSatisfactionCriteriaMet,this.mControl);
         }
         CommunicationManager.RemoveMessageListener(TUTORIAL_TIP_CLOSED,this.OnTutorialTipClosed,this.mControl);
         CommunicationManager.RemoveMessageListener(TUTORIAL_TIP_GROUP_SKIPPED,this.OnTutorialTipClosed,this.mControl);
      }
      
      protected function HandleSetModalVisible(param1:Object) : void
      {
         if(SystemUtils.UsingController)
         {
            return;
         }
         if(Boolean(this.mActiveTutorial) && this.mActiveTutorial.is_modal)
         {
            return;
         }
         var _loc2_:String = WidgetUtils.GetBaseName(this.mControl);
         var _loc3_:Boolean = Boolean(CommunicationManager.CallUIService("IsWidgetTopModal",_loc2_));
         if(_loc3_ && Boolean(this.mControlEnum))
         {
            CommunicationManager.CallGameService("MarkElementVisibility",{
               "element_id":this.mControlEnum,
               "visibility":this.mbVisibilityOverride
            });
         }
         else if(this.mbAnimatingSatisfiedTip && Boolean(this.mActiveTutorial))
         {
            this.DismissActiveTutorialTip(true,true,true);
         }
         else if(this.mControlEnum)
         {
            CommunicationManager.CallGameService("MarkElementVisibility",{
               "element_id":this.mControlEnum,
               "visibility":false
            });
         }
      }
      
      protected function HandleStageResized(param1:Object) : void
      {
         if(!this.mActiveTutorial)
         {
            return;
         }
         this.mbInTutorialTipEnded = true;
         CommunicationManager.CallGameService("TutorialTipEnded",{
            "id":this.mActiveTutorial.id,
            "isComplete":false,
            "isSkipGroup":false
         });
         this.mbInTutorialTipEnded = false;
         this.mActiveTutorial = null;
      }
      
      protected function HandleUpdateDisabledTutorialElements(param1:Object) : void
      {
         var _loc3_:DisabledTooltipExtension = null;
         if(!param1 || !this.mControlEnum)
         {
            return;
         }
         var _loc2_:Object = param1[this.mControlEnum];
         if(_loc2_)
         {
            DisabledTooltipExtension.Get(this.mControl as IExtendable).Disable(new LocKey(_loc2_));
         }
         else if(!this.mControl.enabled)
         {
            _loc3_ = DisabledTooltipExtension.Get(this.mControl as IExtendable,false);
            if(_loc3_)
            {
               _loc3_.Enable();
            }
         }
      }
      
      protected function AreAllSatisfactionWidgetsVisible() : Boolean
      {
         var _loc1_:String = null;
         if(this.mSatisfactionWidgetsVisible == null || this.mSatisfactionWidgetsVisible.length == 0)
         {
            return false;
         }
         for each(_loc1_ in this.mSatisfactionWidgetsVisible)
         {
            if(!(CommunicationManager.CallUIService("IsWidgetVisible",_loc1_) as Boolean))
            {
               return false;
            }
         }
         return true;
      }
   }
}

