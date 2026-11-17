package olympus.extensions
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import olympus.gamepad.HighlightRequestEvent;
   import olympus.gui.sliders.Slider;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   
   public class HighlightExtension implements IExtension
   {
      
      public static var sGenericHighlightClip:Class;
      
      public static const HIGHLIGHT_MC_NAME:String = "mcControllerHighlight";
      
      protected var mbHighlighted:Boolean;
      
      protected var mExtendedTarget:IExtendable;
      
      protected var mHighlightFrameLabels:Object;
      
      protected var mcControllerHighlight:MovieClip;
      
      protected var mLinkedHighlightObjects:Vector.<DisplayObject>;
      
      protected var mbCreateControllerHighlight:Boolean;
      
      protected var mbCreatedGenericHighlight:Boolean;
      
      protected var mControllerHighlightContainer:MovieClip;
      
      protected var mControllerHighlightTarget:MovieClip;
      
      public function HighlightExtension()
      {
         super();
      }
      
      public static function Get(param1:IExtendable, param2:Boolean = true) : HighlightExtension
      {
         return param1.GetExtension(HighlightExtension,param2) as HighlightExtension;
      }
      
      protected static function GetGenericHighlightStates(param1:Boolean) : Vector.<String>
      {
         var _loc3_:String = null;
         var _loc2_:Vector.<String> = new Vector.<String>();
         var _loc4_:Vector.<String> = Vector.<String>(["controller_",""]);
         if(param1)
         {
            _loc3_ = "over";
         }
         else
         {
            _loc3_ = "out";
         }
         var _loc5_:uint = _loc4_.length;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_.push(_loc4_[_loc6_] + _loc3_);
            _loc6_++;
         }
         return _loc2_;
      }
      
      protected static function FindControllerHighlight(param1:DisplayObject) : MovieClip
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:uint = 0;
         var _loc6_:DisplayObjectContainer = null;
         if(param1 == null || !(param1 is DisplayObjectContainer))
         {
            return null;
         }
         var _loc2_:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
         _loc2_.push(param1 as DisplayObjectContainer);
         while(_loc2_.length > 0)
         {
            _loc3_ = _loc2_.shift();
            if(_loc3_.name == HIGHLIGHT_MC_NAME && _loc3_ is MovieClip)
            {
               return _loc3_ as MovieClip;
            }
            _loc4_ = _loc3_[HIGHLIGHT_MC_NAME];
            if(_loc4_)
            {
               return _loc4_ as MovieClip;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc3_.numChildren)
            {
               _loc6_ = _loc3_.getChildAt(_loc5_) as DisplayObjectContainer;
               if(_loc6_)
               {
                  _loc2_.push(_loc6_);
               }
               _loc5_++;
            }
         }
         return null;
      }
      
      protected static function HighlightControllerHighlightWithCache(param1:MovieClip, param2:Boolean, param3:Object) : void
      {
         var _loc4_:Vector.<String> = null;
         var _loc7_:String = null;
         _loc4_ = GetGenericHighlightStates(param2);
         var _loc5_:uint = _loc4_.length;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc4_[_loc6_];
            if(param3[_loc7_])
            {
               param1.gotoAndPlay(_loc7_);
               break;
            }
            _loc6_++;
         }
      }
      
      protected static function HighlightControllerHighlight(param1:MovieClip, param2:Boolean) : void
      {
         HighlightControllerHighlightWithCache(param1,param2,GenerateFrameLabelsCache(param1));
      }
      
      protected static function GenerateFrameLabelsCache(param1:MovieClip) : Object
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Object = null;
         if(param1)
         {
            _loc3_ = param1.currentLabels;
            _loc4_ = int(_loc3_.length);
            _loc2_ = new Object();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc2_[_loc3_[_loc5_].name] = true;
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function Extend(param1:IExtendable) : void
      {
         this.mExtendedTarget = param1;
         var _loc2_:MovieClip = this.mExtendedTarget as MovieClip;
         if(_loc2_)
         {
            _loc2_.addEventListener(HighlightRequestEvent.HIGHLIGHT_REQUEST,this.OnHighlightChange,false,0,true);
         }
         this.mcControllerHighlight = FindControllerHighlight(this.mExtendedTarget as DisplayObjectContainer);
         if(this.mcControllerHighlight)
         {
            this.mHighlightFrameLabels = GenerateFrameLabelsCache(this.mcControllerHighlight);
         }
      }
      
      public function get Highlighted() : Boolean
      {
         return this.mbHighlighted;
      }
      
      public function SetHighlighted(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         if(this.mbHighlighted == param1 && !param2)
         {
            return;
         }
         this.mbHighlighted = param1;
         if(this.mbHighlighted)
         {
            if(this.mbCreateControllerHighlight && !this.mbCreatedGenericHighlight)
            {
               _loc3_ = this.mExtendedTarget as MovieClip;
               if(this.mControllerHighlightTarget)
               {
                  _loc3_ = this.mControllerHighlightTarget;
               }
               _loc4_ = new sGenericHighlightClip();
               _loc4_.name = HIGHLIGHT_MC_NAME;
               _loc4_.width = _loc3_.width / _loc3_.scaleX;
               _loc4_.height = _loc3_.height / _loc3_.scaleY;
               if(this.mControllerHighlightContainer)
               {
                  this.mControllerHighlightContainer.addChildAt(_loc4_,0);
               }
               else
               {
                  _loc5_ = _loc3_.parent as MovieClip;
                  _loc4_.x = _loc3_.x;
                  _loc4_.y = _loc3_.y;
                  _loc5_.addChildAt(_loc4_,_loc5_.getChildIndex(_loc3_));
               }
               this.AddLinkedHighlight(_loc4_);
               this.mbCreatedGenericHighlight = true;
            }
            else
            {
               _loc6_ = FindControllerHighlight(this.mExtendedTarget as DisplayObjectContainer);
               if(_loc6_ != this.mcControllerHighlight)
               {
                  this.mcControllerHighlight = _loc6_;
                  this.mHighlightFrameLabels = GenerateFrameLabelsCache(this.mcControllerHighlight);
               }
            }
         }
         this.SetObjectHighlightedState(this.mExtendedTarget as DisplayObject,param1,this.mcControllerHighlight,this.mHighlightFrameLabels);
         if(this.mLinkedHighlightObjects)
         {
            _loc7_ = this.mLinkedHighlightObjects.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               this.SetObjectHighlightedState(this.mLinkedHighlightObjects[_loc8_],param1,FindControllerHighlight(this.mLinkedHighlightObjects[_loc8_]));
               _loc8_++;
            }
         }
      }
      
      protected function SetObjectHighlightedState(param1:DisplayObject, param2:Boolean, param3:MovieClip = null, param4:Object = null) : void
      {
         var _loc5_:Slider = null;
         if(this.mbHighlighted)
         {
            param1.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER,false));
         }
         else
         {
            param1.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT,false));
         }
         if(param1 is Slider)
         {
            _loc5_ = param1 as Slider;
            if((Boolean(_loc5_)) && Boolean(_loc5_.mcTrack))
            {
               _loc5_.SetControllerHighlight(param2);
            }
         }
         if(param3)
         {
            if(param4)
            {
               HighlightControllerHighlightWithCache(param3,param2,param4);
            }
            else
            {
               HighlightControllerHighlight(param3,param2);
            }
         }
      }
      
      public function AddLinkedHighlights(param1:Array) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_)
            {
               this.AddLinkedHighlight(_loc2_);
            }
         }
      }
      
      public function AddLinkedHighlight(param1:DisplayObject) : void
      {
         if(!this.mLinkedHighlightObjects)
         {
            this.mLinkedHighlightObjects = new Vector.<DisplayObject>();
         }
         if(this.mLinkedHighlightObjects.indexOf(param1) == -1)
         {
            this.mLinkedHighlightObjects.push(param1);
            if(this.mbHighlighted)
            {
               this.SetObjectHighlightedState(param1,true);
            }
         }
      }
      
      protected function OnHighlightChange(param1:HighlightRequestEvent) : void
      {
         this.SetHighlighted(param1.shouldHighlight);
      }
      
      public function IsLinked(param1:DisplayObject) : Boolean
      {
         return Boolean(this.mLinkedHighlightObjects) && this.mLinkedHighlightObjects.indexOf(param1) != -1;
      }
      
      public function AddGenericHighlight(param1:MovieClip = null, param2:MovieClip = null) : void
      {
         this.mbCreateControllerHighlight = true;
         if(param1)
         {
            this.mControllerHighlightContainer = param1;
         }
         if(param2)
         {
            this.mControllerHighlightTarget = param2;
         }
         if(this.mbHighlighted)
         {
            this.SetHighlighted(this.mbHighlighted,true);
         }
      }
   }
}

