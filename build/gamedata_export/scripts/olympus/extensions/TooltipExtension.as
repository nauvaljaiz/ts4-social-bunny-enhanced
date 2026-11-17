package olympus.extensions
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import olympus.core.tooltip.TooltipObject;
   import olympus.core.widget.Margin;
   import olympus.gamepad.NavManager;
   import olympus.input.adapters.VirtualCursorInputAdapter;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.io.InputActionManager;
   import olympus.localization.LocKey;
   import olympus.utils.SystemUtils;
   
   public class TooltipExtension implements IExtension
   {
      
      protected var mTooltipObj:TooltipObject;
      
      protected var mControl:DisplayObject;
      
      protected var mbShowControllerHints:Boolean = true;
      
      protected var mbOverrideHiddenControllerHints:Boolean = false;
      
      public function TooltipExtension()
      {
         super();
      }
      
      public static function Get(param1:IExtendable, param2:Boolean = true) : TooltipExtension
      {
         return param1.GetExtension(TooltipExtension,param2) as TooltipExtension;
      }
      
      public static function AddControllerHintsToData(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:String = InputActionManager.GetControllerHints(param2);
         if(Boolean(param1) && Boolean(_loc3_))
         {
            param1["controllerHints"] = _loc3_;
         }
      }
      
      public function Extend(param1:IExtendable) : void
      {
         if(param1 is DisplayObject)
         {
            this.mControl = param1 as DisplayObject;
            this.mTooltipObj = new TooltipObject(param1 as DisplayObject);
            return;
         }
         throw new Error("Cannot apply TooltipExtension to non-Display Objects!");
      }
      
      public function get Text() : Object
      {
         return this.mTooltipObj ? this.mTooltipObj.GetText() : "";
      }
      
      public function set Text(param1:Object) : void
      {
         if(param1)
         {
            if(this.mTooltipObj == null)
            {
               this.mTooltipObj = new TooltipObject(this.mControl);
            }
            if(this.mTooltipObj.mbInitialized)
            {
               this.mTooltipObj.SetText(param1);
            }
            else
            {
               this.mTooltipObj.Initialize({"text":param1});
            }
         }
         else if(this.mTooltipObj)
         {
            this.mTooltipObj.Shutdown();
            this.mTooltipObj = null;
         }
      }
      
      public function SetText(param1:LocKey, ... rest) : void
      {
         var _loc3_:LocKey = null;
         if(Boolean(param1) && param1.IsValid())
         {
            if(this.mTooltipObj == null)
            {
               this.mTooltipObj = new TooltipObject(this.mControl);
            }
            _loc3_ = param1;
            if(rest.length > 0)
            {
               _loc3_ = param1.Clone(rest);
            }
            else if(Boolean(param1.tokens) && param1.tokens.length > 0)
            {
               _loc3_ = param1.Clone();
            }
            if(this.mTooltipObj.mbInitialized)
            {
               this.mTooltipObj.SetText(_loc3_);
            }
            else
            {
               this.mTooltipObj.Initialize({"text":_loc3_});
            }
         }
         else if(this.mTooltipObj)
         {
            this.mTooltipObj.Shutdown();
            this.mTooltipObj = null;
         }
      }
      
      public function SetOneTimeText(param1:LocKey, ... rest) : void
      {
         this.SetText.apply(this,[param1].concat(rest));
         this.Show();
         this.mControl.addEventListener(MouseEvent.MOUSE_OUT,this.CleanUpTooltip,false,0,true);
      }
      
      protected function CleanUpTooltip(param1:MouseEvent) : void
      {
         this.mControl.removeEventListener(MouseEvent.MOUSE_OUT,this.CleanUpTooltip);
         this.SetText(null);
      }
      
      public function get CustomTooltip() : Class
      {
         return this.mTooltipObj ? this.mTooltipObj.TooltipClass : null;
      }
      
      public function set CustomTooltip(param1:Class) : void
      {
         if(param1 != null)
         {
            if(this.mTooltipObj == null)
            {
               this.mTooltipObj = new TooltipObject(this.mControl);
            }
            if(this.mTooltipObj.TooltipClass != param1)
            {
               this.mTooltipObj.Shutdown();
               this.mTooltipObj.TooltipClass = param1;
            }
         }
         else if(this.mTooltipObj)
         {
            this.mTooltipObj.Shutdown();
            this.mTooltipObj = null;
         }
      }
      
      public function set Data(param1:Object) : void
      {
         if(param1 != null)
         {
            if(this.mTooltipObj == null)
            {
               this.mTooltipObj = new TooltipObject(this.mControl);
            }
            this.mTooltipObj.Initialize(param1,this.mTooltipObj.mDelay);
         }
         else if(this.mTooltipObj)
         {
            this.mTooltipObj.Shutdown();
            this.mTooltipObj = null;
         }
      }
      
      public function get Data() : Object
      {
         return this.mTooltipObj ? this.mTooltipObj.Data : null;
      }
      
      public function get Delay() : int
      {
         return this.mTooltipObj ? this.mTooltipObj.mDelay : -1;
      }
      
      public function set Delay(param1:int) : void
      {
         if(param1 >= 0 && Boolean(this.mTooltipObj))
         {
            this.mTooltipObj.mDelay = param1;
         }
      }
      
      public function get MaxWidth() : Number
      {
         return this.mTooltipObj ? this.mTooltipObj.GetMaxWidth() : 0;
      }
      
      public function set MaxWidth(param1:Number) : void
      {
         if(param1 > 0 && Boolean(this.mTooltipObj))
         {
            this.mTooltipObj.SetMaxWidth(param1);
         }
      }
      
      public function get HorizontalAlignment() : String
      {
         return this.mTooltipObj ? this.mTooltipObj.HorizontalAlignment : "";
      }
      
      public function set HorizontalAlignment(param1:String) : void
      {
         if(Boolean(param1) && Boolean(this.mTooltipObj))
         {
            this.mTooltipObj.HorizontalAlignment = param1;
         }
      }
      
      public function get VerticalAlignment() : String
      {
         return this.mTooltipObj ? this.mTooltipObj.VerticalAlignment : "";
      }
      
      public function set VerticalAlignment(param1:String) : void
      {
         if(Boolean(param1) && Boolean(this.mTooltipObj))
         {
            this.mTooltipObj.VerticalAlignment = param1;
         }
      }
      
      public function get Margins() : Margin
      {
         return this.mTooltipObj ? this.mTooltipObj.Margins : new Margin(0);
      }
      
      public function set Margins(param1:Margin) : void
      {
         if(Boolean(param1) && Boolean(this.mTooltipObj))
         {
            this.mTooltipObj.Margins = param1;
         }
      }
      
      public function set UseHitAreaBounds(param1:Boolean) : void
      {
         if(this.mTooltipObj)
         {
            this.mTooltipObj.UseHitAreaBounds = param1;
         }
      }
      
      public function set FallbackDirection(param1:String) : void
      {
         if(Boolean(param1) && Boolean(this.mTooltipObj))
         {
            this.mTooltipObj.FallbackDirection = param1;
         }
      }
      
      public function set HitTestPosition(param1:String) : void
      {
         if(Boolean(param1) && Boolean(this.mTooltipObj))
         {
            this.mTooltipObj.HitTestPosition = param1;
         }
      }
      
      public function Clear(param1:Boolean = false) : void
      {
         if(this.mTooltipObj)
         {
            this.mTooltipObj.HideTooltip(param1);
         }
      }
      
      public function Show(param1:Boolean = false) : void
      {
         if(this.mTooltipObj)
         {
            this.mTooltipObj.ShowTooltip(param1);
         }
      }
      
      public function SendTooltipEvent(param1:Event) : void
      {
         var _loc2_:String = null;
         if(Boolean(this.mTooltipObj) && this.mTooltipObj.mbInitialized)
         {
            if(SystemUtils.UsingController && this.mbShowControllerHints)
            {
               _loc2_ = param1.type;
               if(_loc2_ == MouseEvent.ROLL_OVER)
               {
                  this.UpdateControllerHints();
               }
            }
            this.mTooltipObj.HandleEvent(param1);
         }
      }
      
      public function SetToConstantlyUpdatePosition(param1:Boolean) : void
      {
         this.mTooltipObj.ConstantlyUpdatePosition = param1;
      }
      
      public function UpdateControllerHints() : void
      {
         if(!this.mTooltipObj)
         {
            return;
         }
         if(NavManager.Instance.TryAddFocusChangeCompleteCallback(this.UpdateControllerHints))
         {
            return;
         }
         if(NavManager.Instance.CurrentFocusable is VirtualCursorInputAdapter && !NavManager.Instance.IsWidgetPending())
         {
            this.mTooltipObj.ClearControllerHints();
            return;
         }
         var _loc1_:String = InputActionManager.GetControllerHints(this.mbOverrideHiddenControllerHints);
         this.mTooltipObj.SetControllerHints(_loc1_);
      }
      
      public function SetShowControllerHints(param1:Boolean) : void
      {
         this.mbShowControllerHints = param1;
      }
      
      public function OverrideHiddenControllerHints(param1:Boolean) : void
      {
         this.mbOverrideHiddenControllerHints = param1;
      }
      
      public function SetTooltipEnabled(param1:Boolean) : void
      {
         this.mTooltipObj.Enabled = param1;
      }
   }
}

