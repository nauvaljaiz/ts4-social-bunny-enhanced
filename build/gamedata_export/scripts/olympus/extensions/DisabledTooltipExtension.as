package olympus.extensions
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import olympus.controls.GUIComponent;
   import olympus.core.ExtendableComponent;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.localization.LocKey;
   
   public class DisabledTooltipExtension implements IExtension
   {
      
      protected var mComponent:MovieClip;
      
      protected var mSavedTooltip:Object;
      
      protected var mDisabledReason:LocKey;
      
      protected var mbForceDisableOnNextFrameChange:Boolean = false;
      
      public function DisabledTooltipExtension()
      {
         super();
      }
      
      public static function Get(param1:IExtendable, param2:Boolean = true) : DisabledTooltipExtension
      {
         return param1.GetExtension(DisabledTooltipExtension,param2) as DisabledTooltipExtension;
      }
      
      public static function IsComponentEnabled(param1:ExtendableComponent) : Boolean
      {
         var _loc2_:DisabledTooltipExtension = DisabledTooltipExtension.Get(param1,false);
         if(Boolean(_loc2_) && _loc2_.ShouldDisable)
         {
            return false;
         }
         return param1.enabled;
      }
      
      public static function DisableMultiple(param1:LocKey, param2:Array) : void
      {
         var _loc3_:IExtendable = null;
         for each(_loc3_ in param2)
         {
            Get(_loc3_).Disable(param1);
         }
      }
      
      public function Extend(param1:IExtendable) : void
      {
         var _loc2_:TooltipExtension = null;
         this.mComponent = param1 as MovieClip;
         if(!this.mComponent)
         {
            throw new Error("DisabledTooltipExtension must be applied to a MovieClip!");
         }
         if(!this.mComponent.enabled)
         {
            _loc2_ = TooltipExtension.Get(this.mComponent as IExtendable,false);
            if(_loc2_)
            {
               this.mSavedTooltip = _loc2_.Text;
            }
         }
         if(this.mComponent is GUIComponent)
         {
            this.mComponent.DispatchEnableChanged = true;
            this.mComponent.addEventListener(GUIComponent.ENABLE_CHANGED_EVENT,this.OnControlEnabledChanged,false,0,true);
         }
      }
      
      public function Enable() : void
      {
         this.Disable(null);
      }
      
      public function get ShouldDisable() : Boolean
      {
         return this.mDisabledReason != null;
      }
      
      public function Disable(param1:LocKey, param2:Boolean = false) : void
      {
         var _loc3_:TooltipExtension = null;
         this.mDisabledReason = param1;
         if(this.mComponent.enabled || param2)
         {
            if(param1)
            {
               this.mComponent.enabled = false;
               _loc3_ = TooltipExtension.Get(this.mComponent as IExtendable);
               this.mSavedTooltip = _loc3_.Text;
               _loc3_.Text = param1;
            }
         }
         else
         {
            _loc3_ = TooltipExtension.Get(this.mComponent as IExtendable);
            if(param1)
            {
               _loc3_.Text = param1;
            }
            else
            {
               this.mComponent.enabled = true;
               _loc3_.Text = this.mSavedTooltip;
            }
         }
      }
      
      protected function OnControlEnabledChanged(param1:Event = null) : void
      {
         this.mComponent.addEventListener(Event.ENTER_FRAME,this.OnNextFrameAfterEnableChanged,false,0,true);
         if(Boolean(this.mDisabledReason) && this.mComponent.enabled)
         {
            this.mComponent.enabled = false;
            this.mbForceDisableOnNextFrameChange = true;
         }
      }
      
      protected function OnNextFrameAfterEnableChanged(param1:Event = null) : void
      {
         this.mComponent.removeEventListener(Event.ENTER_FRAME,this.OnNextFrameAfterEnableChanged);
         if(Boolean(this.mDisabledReason) && (this.mComponent.enabled || this.mbForceDisableOnNextFrameChange))
         {
            this.Disable(this.mDisabledReason,this.mbForceDisableOnNextFrameChange);
            this.mbForceDisableOnNextFrameChange = false;
         }
      }
   }
}

