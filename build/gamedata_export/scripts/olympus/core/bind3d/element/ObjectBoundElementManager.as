package olympus.core.bind3d.element
{
   import flash.display.DisplayObjectContainer;
   import flash.external.ExternalInterface;
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   import olympus.constants.GameStates;
   import olympus.core.Ticker;
   import olympus.core.bind3d.io.ElementMessageAccumulator;
   import olympus.core.bind3d.io.MessageHandlerInfo;
   import olympus.core.data.Multimap;
   import olympus.core.data.StrictMultimap;
   import olympus.errors.Assert;
   import olympus.events.TickerEvent;
   import olympus.io.CommunicationManager;
   import olympus.io.DebugCommands;
   import olympus.utils.DebugUtils;
   import olympus.utils.Functional;
   import olympus.utils.LibraryUtils;
   import scaleform.gfx.DisplayObjectEx;
   
   public class ObjectBoundElementManager
   {
      
      protected static var instance:ObjectBoundElementManager;
      
      protected static const DIRTY_LIFETIME:uint = 1;
      
      protected static const DIRTY_ORDERING:uint = 2;
      
      protected var mBoundObjects:Multimap = new StrictMultimap(ObjectBoundElement);
      
      protected var mHandledMessages:Multimap = new StrictMultimap(MessageHandlerInfo);
      
      protected var mElementClasses:Object = new Object();
      
      protected var mUnusedElementClasses:Object = new Object();
      
      protected var mElementBindings:Multimap = new StrictMultimap(ElementBinding);
      
      protected var mElementLayer:DisplayObjectContainer;
      
      protected var mGameState:int = 0;
      
      protected var mDirtyFlags:uint = 0;
      
      protected var mSimBalloonViewOverrides:Object = new Object();
      
      protected var mObjectBoneAttachmentOverrides:Object = new Object();
      
      public function ObjectBoundElementManager(param1:DisplayObjectContainer, param2:CommunicationManager)
      {
         super();
         instance = this;
         this.mElementLayer = param1;
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("ObjectSendMessage",this.ObjectSendMessage);
         }
         param2.AddMessageListener("ObjectBoundElementDestroyed",this.HandleObjectBoundElementDestroyed,"ObjectBoundElementManager");
         param2.AddMessageListener("OverrideBalloonViewOffset",this.HandleOverrideBalloonViewOffset,"ObjectBoundElementManager");
         param2.AddMessageListener("BoundObjectUpdate",this.HandleSetObjectBoundElementAttachment,"ObjectBoundElementManager");
         param2.RegisterServiceHandler("HideHeadlineEffects",this.HandleHideHeadlineEffects,"ObjectBoundElementManager");
         CommunicationManager.CallGameService("SetDirtyOrderingCallback",{"callback":this.FlagOrderingDirty});
      }
      
      public static function SetElementList(param1:Vector.<ElementBinding>) : void
      {
         var _loc2_:ElementBinding = null;
         for each(_loc2_ in param1)
         {
            instance.mElementBindings.Insert(_loc2_.elementName,_loc2_);
         }
         instance.GatherInitialElementData();
      }
      
      protected static function IsElementAwaitingDestruction(param1:String, param2:ObjectBoundElement) : Boolean
      {
         return param2.AwaitingDestruction;
      }
      
      protected static function SortObjectBoundElements(param1:ObjectBoundElement, param2:ObjectBoundElement) : Number
      {
         if(param1.z > param2.z)
         {
            return -1;
         }
         if(param1.z < param2.z)
         {
            return 1;
         }
         return 0;
      }
      
      public function ObjectSendMessage(param1:String, param2:String, param3:Object) : Boolean
      {
         var _loc5_:MessageHandlerInfo = null;
         var _loc6_:ObjectBoundElement = null;
         var _loc7_:String = null;
         var _loc8_:Vector.<ElementBinding> = null;
         var _loc9_:ElementBinding = null;
         var _loc4_:Boolean = false;
         if(param2 == "ObjectHasVisibleElement")
         {
            return this.HandleObjectHasVisibleElement(param1,param3);
         }
         if(param2 == "SceneObjectUnbound")
         {
            this.HandleSceneObjectUnbound(param1);
            return true;
         }
         for each(_loc5_ in this.mHandledMessages.IterateValues(param2))
         {
            _loc7_ = _loc5_.elementName;
            if(_loc5_.instantiatesElement)
            {
               _loc8_ = this.FindMissingBindings(param1,_loc7_);
               for each(_loc9_ in _loc8_)
               {
                  this.InstantiateElementClip(_loc7_,param1,_loc9_);
               }
            }
         }
         for each(_loc6_ in this.mBoundObjects.IterateValues(param1))
         {
            if(_loc6_.SendMessage(param2,param3))
            {
               _loc4_ = true;
            }
         }
         return _loc4_;
      }
      
      public function SetGameState(param1:int) : void
      {
         this.mGameState = param1;
         if(this.mGameState != GameStates.PLAY)
         {
            this.DestroyAll();
         }
      }
      
      public function DestroyAll() : void
      {
         this.mBoundObjects.Enumerate(Functional.NaryToUnary(this.RemoveElement,1));
         this.mBoundObjects.Clear();
      }
      
      protected function FindMissingBindings(param1:String, param2:String) : Vector.<ElementBinding>
      {
         var _loc6_:ObjectBoundElement = null;
         var _loc7_:ElementBinding = null;
         var _loc3_:Vector.<ElementBinding> = new Vector.<ElementBinding>();
         var _loc4_:Vector.<ElementBinding> = new Vector.<ElementBinding>();
         var _loc5_:Class = this.mElementClasses[param2];
         for each(_loc6_ in this.mBoundObjects.IterateValues(param1))
         {
            if(_loc6_ is _loc5_)
            {
               _loc3_.push(_loc6_.Binding);
            }
         }
         for each(_loc7_ in this.mElementBindings.IterateValues(param2))
         {
            if(_loc3_.indexOf(_loc7_) < 0)
            {
               _loc4_.push(_loc7_);
            }
         }
         return _loc4_;
      }
      
      protected function Update(param1:TickerEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ObjectBoundElement = null;
         if(this.mDirtyFlags & DIRTY_LIFETIME)
         {
            this.FlagClean(DIRTY_LIFETIME);
            _loc2_ = new Array();
            this.mBoundObjects.RemoveIf(IsElementAwaitingDestruction,_loc2_);
            for each(_loc3_ in _loc2_)
            {
               this.RemoveElement(_loc3_);
            }
         }
         if(this.mDirtyFlags & DIRTY_ORDERING)
         {
            this.FlagClean(DIRTY_ORDERING);
            this.ResortElements();
         }
      }
      
      protected function ResortElements() : void
      {
         var _loc1_:Array = this.mBoundObjects.IterateValues();
         _loc1_.sort(SortObjectBoundElements);
         var _loc2_:DisplayObjectContainer = this.mElementLayer;
         var _loc3_:int = 0;
         var _loc4_:int = int(_loc1_.length);
         while(_loc3_ < _loc4_)
         {
            _loc2_.setChildIndex(_loc1_[_loc3_],_loc3_);
            _loc3_++;
         }
      }
      
      protected function FlagDirty(param1:uint) : void
      {
         Assert.NotEquals(param1,0);
         this.mDirtyFlags |= param1;
         if(Boolean(this.mDirtyFlags) && Boolean(!Ticker.Has(this)) && DebugUtils.IsGameClientDriven())
         {
            Ticker.Add(this,0,this.Update);
         }
      }
      
      protected function FlagClean(param1:uint) : void
      {
         Assert.NotEquals(param1,0);
         this.mDirtyFlags &= ~param1;
         if(this.mDirtyFlags == 0)
         {
            Ticker.Remove(this);
         }
      }
      
      protected function FlagOrderingDirty() : void
      {
         this.FlagDirty(DIRTY_ORDERING);
      }
      
      protected function AddElement(param1:ObjectBoundElement, param2:String, param3:ElementBinding) : void
      {
         this.BindElement(param1,param2,param3);
         if(param3.isOccludedByWorld)
         {
            DisplayObjectEx.setRendererFloat(param1,1);
            DisplayObjectEx.disableBatching(param1,true);
         }
         this.mBoundObjects.Insert(param2,param1);
         this.mElementLayer.addChild(param1);
         param1.Attach(param2,param3);
      }
      
      protected function BindElement(param1:ObjectBoundElement, param2:String, param3:ElementBinding) : void
      {
         var _loc4_:Vector3D = this.GetViewOffset(param1,param2,param3);
         CommunicationManager.CallGameService("BindDisplayObject",{
            "displayObject":param1,
            "objectId":param2,
            "attachPoint":param3.boneName,
            "worldOffset":{
               "x":param3.worldOffset.x,
               "y":param3.worldOffset.y,
               "z":param3.worldOffset.z
            },
            "viewOffset":{
               "x":_loc4_.x,
               "y":_loc4_.y,
               "z":_loc4_.z
            },
            "screenOffset":{
               "x":param3.screenOffset.x,
               "y":param3.screenOffset.y,
               "z":param3.screenOffset.z
            },
            "isOccludedByWorld":param3.isOccludedByWorld,
            "isScaledByCamera":param3.isScaledByCamera,
            "minScale":param3.minScale,
            "maxVisibleScale":param3.maxVisibleScale,
            "lockVisibility":param3.lockVisibility,
            "lockToScreenEdge":param3.lockToScreenEdge,
            "lockToScreenEdgeScale":param3.lockToScreenEdgeScale,
            "adjustScreenPositionForMargin":param3.adjustScreenPositionForMargin
         });
      }
      
      protected function RemoveElement(param1:ObjectBoundElement) : void
      {
         CommunicationManager.CallGameService("UnbindDisplayObject",{"displayObject":param1});
         param1.Detach();
         this.mElementLayer.removeChild(param1);
         var _loc2_:String = getQualifiedClassName(param1).replace("::",".");
         if(!this.mUnusedElementClasses[_loc2_])
         {
            this.mUnusedElementClasses[_loc2_] = new Array();
         }
         this.mUnusedElementClasses[_loc2_].push(param1);
      }
      
      protected function ObjectHasElement(param1:String, param2:String) : Boolean
      {
         var _loc4_:ObjectBoundElement = null;
         var _loc3_:Class = this.mElementClasses[param2];
         for each(_loc4_ in this.mBoundObjects.IterateValues(param1))
         {
            if(_loc4_ is _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function GatherInitialElementData() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.mElementBindings.IterateKeys())
         {
            this.InstantiateElementClip(_loc1_,null,null);
         }
      }
      
      protected function InstantiateElementClip(param1:String, param2:String, param3:ElementBinding) : void
      {
         var _loc5_:ObjectBoundElement = null;
         var _loc4_:Class = LibraryUtils.GetLibraryClass(param1);
         if(!_loc4_)
         {
            return;
         }
         if(Boolean(this.mUnusedElementClasses[param1]) && Boolean(this.mUnusedElementClasses[param1].length))
         {
            _loc5_ = this.mUnusedElementClasses[param1].pop();
         }
         else
         {
            _loc5_ = new _loc4_();
         }
         if(Boolean(param3) && Boolean(param2))
         {
            if(this.mObjectBoneAttachmentOverrides.hasOwnProperty(param2))
            {
               if(this.mObjectBoneAttachmentOverrides[param2][0])
               {
                  param3.boneName = this.mObjectBoneAttachmentOverrides[param2][0];
               }
               if(this.mObjectBoneAttachmentOverrides[param2][1])
               {
                  param3.worldOffset = this.mObjectBoneAttachmentOverrides[param2][1];
               }
            }
            this.AddElement(_loc5_,param2,param3);
         }
         else if(this.mElementClasses[param1] == null)
         {
            this.mElementClasses[param1] = (_loc5_ as Object).constructor;
            _loc5_.RegisterMessageListeners(new ElementMessageAccumulator(param1,this.mHandledMessages));
            if(!this.mUnusedElementClasses[param1])
            {
               this.mUnusedElementClasses[param1] = new Array();
            }
            if(!this.mUnusedElementClasses[param1].length)
            {
               this.mUnusedElementClasses[param1].push(_loc5_);
            }
         }
      }
      
      protected function GetViewOffset(param1:ObjectBoundElement, param2:String, param3:ElementBinding) : Vector3D
      {
         if(param1.ElementName == "widgets.ObjectBoundElements.elements.SimBalloon")
         {
            return param2 in this.mSimBalloonViewOverrides && this.mSimBalloonViewOverrides[param2] != null ? this.mSimBalloonViewOverrides[param2] : param3.viewOffset;
         }
         return param3.viewOffset;
      }
      
      protected function CheatSetObjectBoundElementAttachment(param1:Array, param2:Object, param3:String) : void
      {
         if(!param1 || param1.length < 2)
         {
            DebugCommands.Output(param3,"Command Failed: Invalid command arguments!");
            return;
         }
         var _loc4_:* = param1[0];
         var _loc5_:* = param1[1];
         var _loc6_:* = new Vector3D(0,0,0);
         if(param1.length == 5)
         {
            _loc6_ = new Vector3D(parseFloat(param1[2]),parseFloat(param1[3]),parseFloat(param1[4]));
         }
         this.mObjectBoneAttachmentOverrides[_loc4_] = [_loc5_,_loc6_];
      }
      
      protected function HandleSetObjectBoundElementAttachment(param1:Object) : void
      {
         if(!param1 || !("object_id" in param1))
         {
            return;
         }
         var _loc2_:* = param1.object_id;
         var _loc3_:* = null;
         if("bone_name" in param1)
         {
            _loc3_ = param1.bone_name;
         }
         var _loc4_:* = null;
         if("world_offset_x" in param1 && "world_offset_y" in param1 && "world_offset_z" in param1)
         {
            _loc4_ = new Vector3D(parseFloat(param1.world_offset_x),parseFloat(param1.world_offset_y),parseFloat(param1.world_offset_z));
         }
         this.mObjectBoneAttachmentOverrides[_loc2_] = [_loc3_,_loc4_];
      }
      
      protected function HandleObjectHasVisibleElement(param1:String, param2:Object) : Boolean
      {
         var _loc4_:ObjectBoundElement = null;
         var _loc3_:Array = param2 as Array;
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return false;
         }
         for each(_loc4_ in this.mBoundObjects.IterateValues(param1))
         {
            if(_loc3_.indexOf(_loc4_.Binding.elementName) >= 0 && _loc4_.Shown)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function HandleSceneObjectUnbound(param1:String) : void
      {
         var _loc2_:ObjectBoundElement = null;
         for each(_loc2_ in this.mBoundObjects.IterateValues(param1))
         {
            _loc2_.Hide();
         }
      }
      
      protected function HandleObjectBoundElementDestroyed(param1:Object) : void
      {
         this.FlagDirty(DIRTY_LIFETIME);
      }
      
      protected function HandleHideHeadlineEffects(param1:Object) : void
      {
         this.mHandledMessages.Clear();
         var _loc2_:Boolean = param1 as Boolean;
         if(_loc2_)
         {
            this.DestroyAll();
         }
         else
         {
            this.mElementClasses = new Object();
            this.GatherInitialElementData();
         }
      }
      
      protected function HandleOverrideBalloonViewOffset(param1:Object) : void
      {
         var _loc3_:ElementBinding = null;
         var _loc4_:ElementBinding = null;
         var _loc7_:* = undefined;
         var _loc9_:ObjectBoundElement = null;
         var _loc10_:Vector3D = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:String = "widgets.ObjectBoundElements.elements.SimBalloon";
         for each(_loc4_ in this.mElementBindings.IterateValues(_loc2_))
         {
            if(_loc4_.elementName == _loc2_)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         if(!_loc3_)
         {
            return;
         }
         var _loc5_:Boolean = false;
         var _loc6_:String = param1.sim_id;
         if("x" in param1 && "y" in param1 && "z" in param1)
         {
            _loc10_ = new Vector3D(param1.x,param1.y,param1.z);
            if(!(_loc6_ in this.mSimBalloonViewOverrides) || this.mSimBalloonViewOverrides[_loc6_] == null || !_loc10_.equals(this.mSimBalloonViewOverrides[_loc6_]))
            {
               this.mSimBalloonViewOverrides[_loc6_] = _loc10_;
               _loc5_ = true;
            }
         }
         else if(this.mSimBalloonViewOverrides[_loc6_])
         {
            this.mSimBalloonViewOverrides[_loc6_] = null;
            _loc5_ = true;
         }
         if(!_loc5_)
         {
            return;
         }
         var _loc8_:Class = this.mElementClasses[_loc2_] as Class;
         for each(_loc9_ in this.mBoundObjects.IterateValues(_loc6_))
         {
            if(_loc9_ is _loc8_)
            {
               _loc7_ = _loc9_;
               break;
            }
         }
         if(_loc7_)
         {
            this.BindElement(_loc7_,_loc6_,_loc3_);
         }
      }
   }
}

