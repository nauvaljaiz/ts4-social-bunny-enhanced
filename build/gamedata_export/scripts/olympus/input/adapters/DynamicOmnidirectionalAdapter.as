package olympus.input.adapters
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import olympus.controls.EditTextField;
   import olympus.core.ExtendableComponent;
   import olympus.extensions.TooltipExtension;
   import olympus.gamepad.EnterParams;
   import olympus.gui.buttons.Button;
   import olympus.gui.sliders.Slider;
   import olympus.input.IInputFocusable;
   import scaleform.clik.controls.Button;
   import scaleform.clik.controls.TextInput;
   
   public class DynamicOmnidirectionalAdapter extends OmnidirectionalGroupAdapter
   {
      
      protected var mContainer:DisplayObjectContainer;
      
      protected var mExcludeList:Vector.<DisplayObject>;
      
      protected var mElementShouldBeAddedCheck:Function;
      
      protected var mVirtualKeyboardParams:Object;
      
      public function DynamicOmnidirectionalAdapter(param1:DisplayObjectContainer = null)
      {
         super();
         this.mContainer = param1;
         mElements = new Vector.<DisplayObject>();
         this.mExcludeList = new Vector.<DisplayObject>();
         this.mElementShouldBeAddedCheck = DefaultElementShouldBeAdded;
         this.UpdateElements();
      }
      
      public static function DefaultElementShouldBeAdded(param1:DisplayObject) : Boolean
      {
         return param1 is olympus.gui.buttons.Button || param1 is scaleform.clik.controls.Button || param1 is Slider || param1["mcControllerHighlight"] != null;
      }
      
      public function SetContainer(param1:DisplayObjectContainer) : DynamicOmnidirectionalAdapter
      {
         this.mContainer = param1;
         this.UpdateElements();
         return this;
      }
      
      public function GetContainer() : DisplayObjectContainer
      {
         return this.mContainer;
      }
      
      override public function Enter(param1:EnterParams = null) : IInputFocusable
      {
         this.UpdateElements();
         return super.Enter(param1);
      }
      
      override public function UpdateSliderScroll() : void
      {
         this.UpdateElements();
         super.UpdateSliderScroll();
      }
      
      override protected function Confirm() : DisplayObject
      {
         this.UpdateElements();
         return super.Confirm();
      }
      
      override public function AutoscrollSlider(param1:Slider, param2:Number = 0, param3:Boolean = false) : InputAdapter
      {
         this.ExcludeDisplayObject(param1,true);
         return super.AutoscrollSlider(param1,param2,param3);
      }
      
      public function ExcludeDisplayObject(param1:DisplayObject, param2:Boolean = false) : void
      {
         if(param2 && this.mExcludeList.indexOf(param1) != -1)
         {
            return;
         }
         this.mExcludeList.push(param1);
      }
      
      public function ExcludeDisplayObjects(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:DisplayObject = null;
         for each(_loc3_ in param1)
         {
            if(!(!_loc3_ || param2 && this.mExcludeList.indexOf(_loc3_) != -1))
            {
               this.mExcludeList.push(_loc3_);
            }
         }
      }
      
      public function set ElementShouldBeAddedCheck(param1:Function) : void
      {
         this.mElementShouldBeAddedCheck = param1;
      }
      
      public function get ElementShouldBeAddedCheck() : Function
      {
         return this.mElementShouldBeAddedCheck;
      }
      
      public function IncludeObjectsWithTooltips() : void
      {
         var oldCheck:Function = this.ElementShouldBeAddedCheck;
         this.ElementShouldBeAddedCheck = function(param1:DisplayObject):Boolean
         {
            var _loc3_:TooltipExtension = null;
            var _loc2_:ExtendableComponent = param1 as ExtendableComponent;
            if(_loc2_)
            {
               _loc3_ = _loc2_.GetExtension(TooltipExtension,false) as TooltipExtension;
               if(Boolean(_loc3_) && Boolean(_loc3_.Text))
               {
                  return true;
               }
            }
            return oldCheck(param1);
         };
      }
      
      protected function AddElementsIteratively(param1:DisplayObjectContainer) : void
      {
         var _loc6_:int = 0;
         var _loc7_:DisplayObjectContainer = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:DisplayObject = null;
         var _loc11_:DisplayObjectContainer = null;
         if(!param1)
         {
            return;
         }
         if(param1.numChildren == 0)
         {
            return;
         }
         var _loc2_:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
         var _loc3_:Vector.<int> = new Vector.<int>();
         var _loc4_:Vector.<int> = new Vector.<int>();
         var _loc5_:Dictionary = new Dictionary(true);
         _loc2_.push(param1);
         _loc3_.push(0);
         _loc4_.push(param1.numChildren);
         _loc5_[param1] = true;
         while(_loc2_.length > 0)
         {
            _loc6_ = _loc2_.length - 1;
            _loc7_ = _loc2_[_loc6_];
            _loc8_ = _loc3_[_loc6_];
            _loc9_ = _loc4_[_loc6_];
            if(_loc8_ >= _loc9_)
            {
               _loc2_.pop();
               _loc3_.pop();
               _loc4_.pop();
            }
            else
            {
               _loc3_[_loc6_] = _loc8_ + 1;
               _loc10_ = _loc7_.getChildAt(_loc8_);
               if(Boolean(_loc10_.visible) && Boolean(_loc10_.stage) && this.mExcludeList.indexOf(_loc10_) == -1)
               {
                  if(this.mElementShouldBeAddedCheck(_loc10_))
                  {
                     mElements.push(_loc10_);
                     this.ApplyDefaultVirtualKeyboardParams(_loc10_);
                  }
                  else if(_loc10_ is DisplayObjectContainer)
                  {
                     _loc11_ = _loc10_ as DisplayObjectContainer;
                     if((Boolean(_loc11_)) && Boolean(_loc11_.numChildren > 0) && !_loc5_[_loc11_])
                     {
                        _loc5_[_loc11_] = true;
                        _loc2_.push(_loc11_);
                        _loc3_.push(0);
                        _loc4_.push(_loc11_.numChildren);
                     }
                  }
               }
            }
         }
      }
      
      protected function ApplyDefaultVirtualKeyboardParams(param1:DisplayObject) : void
      {
         if(!this.mVirtualKeyboardParams)
         {
            return;
         }
         var _loc2_:EditTextField = param1 as EditTextField;
         if(_loc2_)
         {
            if(!_loc2_.HasVirtualKeyboardParams())
            {
               _loc2_.SetVirtualKeyboardParamsObject(this.mVirtualKeyboardParams);
            }
            return;
         }
         var _loc3_:TextInput = param1 as TextInput;
         if(Boolean(_loc3_) && !_loc3_.HasVirtualKeyboardParams())
         {
            _loc3_.SetVirtualKeyboardParamsObject(this.mVirtualKeyboardParams);
         }
      }
      
      public function UpdateElements(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         if(param2)
         {
            mHighlightedIndex = -1;
         }
         var _loc3_:DisplayObject = GetHighlightedObject();
         mElements.length = 0;
         this.AddElementsIteratively(this.mContainer);
         var _loc4_:int = mElements.indexOf(_loc3_);
         if(_loc4_ == -1)
         {
            if(mHighlightedIndex >= mElements.length)
            {
               mHighlightedIndex = mElements.length - 1;
            }
            SetHighlightedIndex(mHighlightedIndex,true);
         }
         else if(mHighlightedIndex != _loc4_)
         {
            _loc5_ = GetHighlightedObject();
            _loc6_ = mHighlightedIndex;
            mHighlightedIndex = _loc4_;
            _loc7_ = GetHighlightedObject();
            if(_loc6_ != _loc4_ || _loc5_ != _loc7_)
            {
               SetHighlightedIndex(_loc4_,true);
            }
         }
      }
      
      override public function HighlightDirectionAnalog(param1:Number, param2:Number) : void
      {
         this.UpdateElements();
         super.HighlightDirectionAnalog(param1,param2);
      }
      
      override public function SetHighlightedObject(param1:DisplayObject, param2:Boolean = false) : void
      {
         this.UpdateElements();
         super.SetHighlightedObject(param1,param2);
      }
      
      override public function HighlightClosestToPoint(param1:Point, param2:Boolean = false) : Boolean
      {
         this.UpdateElements();
         return super.HighlightClosestToPoint(param1,param2);
      }
      
      public function Count() : int
      {
         this.UpdateElements();
         return GetLength();
      }
      
      public function SetupDefaultVirtualKeyboardParams(param1:Function = null, param2:String = "Default") : void
      {
         this.mVirtualKeyboardParams = {
            "callback":param1,
            "keyboardType":param2
         };
      }
   }
}

