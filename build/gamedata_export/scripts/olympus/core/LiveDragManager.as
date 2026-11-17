package olympus.core
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gamedata.BuildBuy.shared.CatalogProduct;
   import gamedata.Gameplay.LiveDrag.LiveDragCancel;
   import gamedata.Gameplay.LiveDrag.LiveDragEnd;
   import gamedata.Gameplay.LiveDrag.LiveDragStart;
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.shared.ManagerObjectId;
   import olympus.audio.Audio;
   import olympus.constants.InputActionPriorities;
   import olympus.constants.KeyCodes;
   import olympus.core.cursors.Cursors;
   import olympus.events.DragEvents.DragManagerEvent;
   import olympus.events.LiveDragEvents.LiveDragManagerEvent;
   import olympus.events.TweenEvent;
   import olympus.extensions.DroppableExtension;
   import olympus.extensions.LiveDraggableExtension;
   import olympus.extensions.LiveDroppableExtension;
   import olympus.extensions.SellDroppableExtension;
   import olympus.gamepad.NavManager;
   import olympus.input.InputAction;
   import olympus.input.InputTrigger;
   import olympus.io.CommunicationManager;
   import olympus.io.EventManager;
   import olympus.io.InputActionManager;
   import olympus.localization.KeysConsole;
   import olympus.localization.LocKey;
   import olympus.motion.Tween;
   import olympus.resources.ImageLoader;
   import olympus.utils.ImageUtils;
   import olympus.utils.InputUtils;
   import olympus.utils.SystemUtils;
   import widgets.Gameplay.constants.GameplayTunables;
   import widgets.shared.controls.ToastNotification.ToastNotification;
   
   public class LiveDragManager
   {
      
      protected static const LIVE_DRAG_MANAGER_STRING:String = "LiveDragManager";
      
      protected static const ICON_SIZE:Number = 57;
      
      protected static const INVALID_SYSTEM:int = 0;
      
      protected static const UI_SYSTEM:int = 1;
      
      protected static const BB_SYSTEM:int = 2;
      
      protected static const GP_SYSTEM:int = 3;
      
      protected var mCommMgr:CommunicationManager;
      
      protected var mLiveDragLayer:Sprite;
      
      protected var mDraggedSprite:MovieClip;
      
      protected var mbLiveDragging:Boolean;
      
      protected var mbMouseOverUI:Boolean;
      
      protected var mDraggedId:String;
      
      protected var mTween:Tween;
      
      protected var mbShouldTween:Boolean;
      
      protected var mEscInputAction:InputAction;
      
      public function LiveDragManager(param1:CommunicationManager, param2:Sprite)
      {
         super();
         this.mCommMgr = param1;
         this.mLiveDragLayer = param2;
         param1.AddMessageListener("LiveDragStarted",this.HandleLiveDragStarted,LIVE_DRAG_MANAGER_STRING,LiveDragStart);
         param1.AddMessageListener("LiveDragEnded",this.HandleLiveDragEnded,LIVE_DRAG_MANAGER_STRING,LiveDragEnd);
         param1.AddMessageListener("LiveDragCancelled",this.HandleLiveDragCancelled,LIVE_DRAG_MANAGER_STRING,LiveDragCancel);
         param1.AddMessageListener("MouseFocusChanged",this.HandleMouseFocusChanged,LIVE_DRAG_MANAGER_STRING);
         param1.AddMessageListener("GamepadRequestDragFromInventory",this.HandleGamepadRequestDragFromInventory,LIVE_DRAG_MANAGER_STRING);
         param1.AddMessageListener("GamepadRequestSellFromInventory",this.HandleGamepadRequestSellFromInventory,LIVE_DRAG_MANAGER_STRING);
         param1.AddMessageListener("PlaceDraggedItemInInventory",this.HandlePlaceDraggedItemInInventory,LIVE_DRAG_MANAGER_STRING);
         param1.AddMessageListener("SetLiveDragSpriteVisibility",this.SetLiveDragSpriteVisibility,LIVE_DRAG_MANAGER_STRING);
         var _loc3_:Stage = param2.stage;
         _loc3_.addEventListener(LiveDragManagerEvent.REQUEST_LIVE_DRAG_START,this.HandleRequestStart,false,0,true);
         _loc3_.addEventListener(LiveDragManagerEvent.REQUEST_LIVE_DRAG_END,this.HandleRequestEnd,false,0,true);
         _loc3_.addEventListener(LiveDragManagerEvent.REQUEST_LIVE_DRAG_CANCEL,this.HandleRequestCancel,false,0,true);
         this.mEscInputAction = InputAction.WhenTriggered(InputTrigger.FromKeyBinding(KeyCodes.ESC)).CallFunction(this.HandleEscapeKey).SetPriority(InputActionPriorities.ESC_LIVE_DRAG);
      }
      
      protected function HandleLiveDragStarted(param1:LiveDragStart) : void
      {
         var _loc3_:ImageLoader = null;
         var _loc4_:DragManagerEvent = null;
         var _loc5_:ManagerObjectId = null;
         var _loc6_:CatalogProduct = null;
         var _loc7_:DragManagerEvent = null;
         if(SystemUtils.UsingController && NavManager.Instance.CurrentWidgetName == "PieMenu")
         {
            CommunicationManager.CallGameService("GamepadMouseDragStart");
         }
         var _loc2_:uint = param1.drag_start_system;
         if(Boolean(this.mTween) && this.mTween.IsActive())
         {
            this.mTween.Stop();
         }
         if(!this.mbLiveDragging)
         {
            this.mLiveDragLayer.stage.addEventListener(DragManagerEvent.DRAG_ENDED,this.HandleDragEnded,false,0,true);
            this.mLiveDragLayer.stage.addEventListener(MouseEvent.MOUSE_UP,this.HandleLiveDragMouseUp,false,0,true);
            if(_loc2_ != UI_SYSTEM)
            {
               if(!this.mDraggedSprite)
               {
                  this.InitializeDraggedSprite();
               }
               this.mDraggedSprite.visible = false;
               _loc3_ = this.mDraggedSprite.imgLoader as ImageLoader;
               if(param1.icon_info)
               {
                  ImageUtils.LoadFromIconInfo(_loc3_,param1.icon_info,ImageUtils.THUMBNAIL_SIZE_MEDIUM);
               }
               else
               {
                  _loc6_ = new CatalogProduct(CommunicationManager.CallGameService("GetCatalogProduct",{"objectId":param1.live_drag_object_id}));
                  _loc6_.LoadThumbnail(_loc3_,ImageUtils.THUMBNAIL_SIZE_MEDIUM);
               }
               _loc4_ = new DragManagerEvent(DragManagerEvent.REQUEST_START);
               _loc5_ = new ManagerObjectId({
                  "manager_id":ManagerObjectId.MGR_OBJECT,
                  "object_id":param1.live_drag_object_id
               });
               _loc4_.mDraggedId = _loc5_;
               _loc4_.mDraggedSprite = this.mDraggedSprite;
               _loc4_.mSpriteOffset = new Point(0,0);
               _loc4_.mDraggedCursor = Cursors.HAND_CLOSED_INVALID;
               this.mLiveDragLayer.stage.dispatchEvent(_loc4_);
            }
            else
            {
               _loc7_ = new DragManagerEvent(DragManagerEvent.REQUEST_DATA_UPDATE);
               _loc7_.mDraggedCursor = Cursors.HAND_CLOSED_INVALID;
               this.mLiveDragLayer.stage.dispatchEvent(_loc7_);
            }
            InputActionManager.RegisterAction(this.mEscInputAction);
         }
         this.mbShouldTween = false;
         this.mDraggedId = param1.live_drag_object_id;
         this.mbLiveDragging = true;
      }
      
      protected function HandleLiveDragEnded(param1:LiveDragEnd) : void
      {
         var _loc2_:DragManagerEvent = null;
         var _loc3_:ManagerObjectId = null;
         if(!this.mbLiveDragging)
         {
            return;
         }
         if(!param1.next_drag_object_id)
         {
            this.mbShouldTween = false;
            this.mLiveDragLayer.stage.dispatchEvent(new DragManagerEvent(DragManagerEvent.REQUEST_CANCEL));
            this.mbLiveDragging = false;
            InputActionManager.UnregisterAction(this.mEscInputAction);
         }
         else if(SystemUtils.UsingController)
         {
            CommunicationManager.SendUIMessage("GamepadRequestDragFromInventory",{
               "objectId":param1.next_drag_object_id,
               "isStack":true
            });
         }
         else
         {
            _loc2_ = new DragManagerEvent(DragManagerEvent.REQUEST_DATA_UPDATE);
            _loc3_ = new ManagerObjectId();
            _loc3_.manager_id = ManagerObjectId.MGR_OBJECT;
            _loc3_.object_id = param1.next_drag_object_id;
            _loc2_.mDraggedId = _loc3_;
            this.mLiveDragLayer.stage.dispatchEvent(_loc2_);
            CommunicationManager.CallGameService("PostServerCommand",{
               "command":"live_drag.start",
               "commandArgs":[param1.next_drag_object_id,UI_SYSTEM,true]
            });
         }
         if(param1.drag_end_system == UI_SYSTEM)
         {
            EventManager.DispatchInteractionEvent(Audio.CUSTOM,"LiveDragManager","LiveDragManager","Custom",Audio.DRAG_ENDED);
         }
      }
      
      protected function HandleLiveDragCancelled(param1:LiveDragCancel) : void
      {
         var _loc2_:uint = param1.drag_start_system;
         this.mbShouldTween = _loc2_ == UI_SYSTEM;
         this.mLiveDragLayer.stage.dispatchEvent(new DragManagerEvent(DragManagerEvent.REQUEST_CANCEL));
         this.mbLiveDragging = false;
         EventManager.DispatchInteractionEvent(Audio.CUSTOM,"LiveDragManager","LiveDragManager","Custom",Audio.DRAG_CANCELLED);
         InputActionManager.UnregisterAction(this.mEscInputAction);
      }
      
      protected function HandleMouseFocusChanged(param1:Object) : void
      {
         var _loc2_:Boolean = param1["isOverUI"] as Boolean;
         this.mbMouseOverUI = _loc2_;
         if(this.mbMouseOverUI)
         {
            this.mLiveDragLayer.stage.dispatchEvent(new DragManagerEvent(DragManagerEvent.SHOW_DRAGGED_ICON));
         }
         else
         {
            this.mLiveDragLayer.stage.dispatchEvent(new DragManagerEvent(DragManagerEvent.HIDE_DRAGGED_ICON));
         }
      }
      
      protected function HandleRequestStart(param1:LiveDragManagerEvent) : void
      {
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"live_drag.start",
            "commandArgs":[param1.mActorId,UI_SYSTEM,param1.mbIsStack]
         });
      }
      
      protected function HandleRequestEnd(param1:LiveDragManagerEvent) : void
      {
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"live_drag.end",
            "commandArgs":[param1.mActorId,param1.mTargetId,UI_SYSTEM]
         });
      }
      
      protected function HandleRequestCancel(param1:LiveDragManagerEvent) : void
      {
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"live_drag.canceled",
            "commandArgs":[param1.mActorId,UI_SYSTEM]
         });
      }
      
      protected function HandleDragEnded(param1:DragManagerEvent) : void
      {
         var _loc2_:DragManagerEvent = null;
         this.mLiveDragLayer.stage.removeEventListener(MouseEvent.MOUSE_UP,this.HandleLiveDragMouseUp,false);
         this.mLiveDragLayer.stage.removeEventListener(DragManagerEvent.DRAG_ENDED,this.HandleDragEnded,false);
         if(this.mbShouldTween)
         {
            param1.mDraggedSprite.visible = true;
            this.TweenClip(param1);
         }
         else
         {
            param1.mDraggedSprite.visible = false;
            _loc2_ = new DragManagerEvent(DragManagerEvent.DRAG_END_COMPLETE);
            _loc2_.mDraggedSprite = param1.mDraggedSprite;
            this.mLiveDragLayer.stage.dispatchEvent(_loc2_);
         }
      }
      
      protected function HandleLiveDragMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Stage = null;
         var _loc3_:Point = null;
         var _loc4_:DroppableExtension = null;
         if(!InputUtils.IsLeftMouseButton(param1) || Boolean(CommunicationManager.CallUIService("IsModalVisible")))
         {
            return;
         }
         _loc2_ = this.mLiveDragLayer.stage;
         _loc3_ = new Point(_loc2_.mouseX,_loc2_.mouseY);
         _loc4_ = DragManager.GetTopMostValidDroppable(_loc3_,_loc2_);
         var _loc5_:LiveDroppableExtension = _loc4_ as LiveDroppableExtension;
         var _loc6_:SellDroppableExtension = _loc4_ as SellDroppableExtension;
         if(_loc5_)
         {
            CommunicationManager.CallGameService("PostServerCommand",{
               "command":"live_drag.end",
               "commandArgs":[this.mDraggedId,_loc5_.GetControlId(),UI_SYSTEM]
            });
         }
         else if(Boolean(_loc6_) && _loc6_.IsActiveDroppable())
         {
            CommunicationManager.CallGameService("PostServerCommand",{
               "command":"live_drag.sell",
               "commandArgs":[this.mDraggedId,GameplayStateData.CurrentRegionCurrencyBucksType]
            });
            this.mLiveDragLayer.stage.dispatchEvent(new DragManagerEvent(DragManagerEvent.HIDE_DRAGGED_ICON));
         }
         else if(this.mbMouseOverUI)
         {
            CommunicationManager.CallGameService("PostServerCommand",{
               "command":"live_drag.canceled",
               "commandArgs":[this.mDraggedId,UI_SYSTEM]
            });
         }
      }
      
      public function HandleGameStateUnload() : void
      {
         if(!this.mbLiveDragging)
         {
            return;
         }
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"live_drag.canceled",
            "commandArgs":[this.mDraggedId,UI_SYSTEM]
         });
         InputActionManager.UnregisterAction(this.mEscInputAction);
      }
      
      protected function TweenClip(param1:DragManagerEvent) : void
      {
         var _loc2_:Sprite = param1.mDraggedSprite;
         var _loc3_:Point = param1.mEndPoint;
         var _loc4_:Point = param1.mStartPoint;
         if(Boolean(this.mTween) && this.mTween.IsActive())
         {
            this.mTween.Stop();
         }
         this.mTween = new Tween(GameplayTunables.LIVE_DRAG_CANCEL_TWEEN_DURATION,_loc2_,{
            "x":_loc4_.x,
            "y":_loc4_.y
         });
         this.mTween.addEventListener(TweenEvent.TWEEN_COMPLETE,this.OnTweenClipComplete,false,0,true);
         this.mTween.Start({
            "x":_loc3_.x,
            "y":_loc3_.y
         });
      }
      
      protected function OnTweenClipComplete(param1:TweenEvent) : void
      {
         this.mTween.Target.visible = false;
         var _loc2_:DragManagerEvent = new DragManagerEvent(DragManagerEvent.DRAG_END_COMPLETE);
         _loc2_.mDraggedSprite = this.mTween.Target as Sprite;
         this.mLiveDragLayer.stage.dispatchEvent(_loc2_);
      }
      
      protected function InitializeDraggedSprite() : void
      {
         this.mDraggedSprite = new MovieClip();
         var _loc1_:Graphics = this.mDraggedSprite.graphics;
         _loc1_.drawRect(0,0,ICON_SIZE,ICON_SIZE);
         var _loc2_:ImageLoader = new ImageLoader(this.mDraggedSprite);
         _loc2_.Initialize(new Rectangle(0,0,ICON_SIZE,ICON_SIZE));
         this.mDraggedSprite["imgLoader"] = _loc2_;
      }
      
      protected function HandleEscapeKey() : Boolean
      {
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"live_drag.canceled",
            "commandArgs":[this.mDraggedId,UI_SYSTEM]
         });
         return false;
      }
      
      protected function HandlePlaceDraggedItemInInventory(param1:Object = null) : void
      {
         var _loc2_:String = GameplayStateData.ActiveSimId;
         if(param1)
         {
            _loc2_ = param1.ControlId;
         }
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"live_drag.end",
            "commandArgs":[this.mDraggedId,_loc2_,UI_SYSTEM]
         });
         CommunicationManager.CallGameService("GamepadMouseDragCancel");
         CommunicationManager.SendUIMessage("ToastNotify",{
            "type":ToastNotification.TYPE_CLOBBER,
            "label":LocKey(KeysConsole.LIVE_PLACED_IN_INVENTORY).toString(),
            "isControllerFeedback":true
         });
      }
      
      protected function SetLiveDragSpriteVisibility(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc2_ = Boolean(param1.visible);
            this.mLiveDragLayer.stage.dispatchEvent(new DragManagerEvent(_loc2_ ? DragManagerEvent.SHOW_DRAGGED_ICON : DragManagerEvent.HIDE_DRAGGED_ICON));
         }
      }
      
      protected function HandleGamepadRequestDragFromInventory(param1:Object) : void
      {
         var _loc2_:LiveDraggableExtension = null;
         if(param1.draggableExt)
         {
            _loc2_ = param1.draggableExt as LiveDraggableExtension;
            if(_loc2_)
            {
               _loc2_.SendRequestStartDragEvent();
            }
         }
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"live_drag.start",
            "commandArgs":[param1.objectId,UI_SYSTEM,param1.isStack]
         });
      }
      
      protected function HandleGamepadRequestSellFromInventory(param1:Object) : void
      {
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"live_drag.start",
            "commandArgs":[param1.objectId,UI_SYSTEM,param1.isStack,false]
         });
         CommunicationManager.CallGameService("PostServerCommand",{
            "command":"live_drag.sell",
            "commandArgs":[param1.objectId,GameplayStateData.CurrentRegionCurrencyBucksType]
         });
      }
   }
}

