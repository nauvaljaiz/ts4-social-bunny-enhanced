package olympus.core
{
   import flash.events.Event;
   import olympus.constants.Alignment;
   import olympus.core.tooltip.TooltipObject;
   import olympus.core.widget.Margin;
   import olympus.localization.LocKey;
   
   public class EAUIComponent extends ExtendableComponent
   {
      
      protected var _tooltipObj:TooltipObject;
      
      public function EAUIComponent()
      {
         super();
      }
      
      protected function get tooltipObj() : TooltipObject
      {
         if(this._tooltipObj == null)
         {
            this._tooltipObj = new TooltipObject(this as EAUIComponent);
         }
         return this._tooltipObj;
      }
      
      public function get tooltipText() : Object
      {
         if(this._tooltipObj)
         {
            return this.tooltipObj.GetText();
         }
         return "";
      }
      
      public function set tooltipText(param1:Object) : void
      {
         if(param1)
         {
            if(this.tooltipObj.mbInitialized)
            {
               this.tooltipObj.SetText(param1);
            }
            else
            {
               this.tooltipObj.Initialize({"text":param1});
            }
         }
         else if(this._tooltipObj)
         {
            this.tooltipObj.Shutdown();
            this._tooltipObj = null;
         }
      }
      
      public function SetText(param1:LocKey, ... rest) : void
      {
         var _loc3_:LocKey = null;
         if(param1)
         {
            _loc3_ = param1;
            if(rest.length > 0)
            {
               _loc3_ = param1.Clone(rest);
            }
            if(this.tooltipObj.mbInitialized)
            {
               this.tooltipObj.SetText(_loc3_);
            }
            else
            {
               this.tooltipObj.Initialize({"text":_loc3_});
            }
         }
         else if(this._tooltipObj)
         {
            this.tooltipObj.Shutdown();
            this._tooltipObj = null;
         }
      }
      
      public function set tooltipClass(param1:Class) : void
      {
         if(param1 != null)
         {
            this.tooltipObj.TooltipClass = param1;
         }
         else if(this._tooltipObj)
         {
            this.tooltipObj.Shutdown();
            this._tooltipObj = null;
         }
      }
      
      public function set tooltipData(param1:Object) : void
      {
         if(param1 != null)
         {
            this.tooltipObj.Initialize(param1);
         }
         else if(this._tooltipObj)
         {
            this.tooltipObj.Shutdown();
            this._tooltipObj = null;
         }
      }
      
      public function get tooltipDelay() : int
      {
         if(this._tooltipObj)
         {
            return this.tooltipObj.mDelay;
         }
         return -1;
      }
      
      public function set tooltipDelay(param1:int) : void
      {
         if(param1 >= 0)
         {
            this.tooltipObj.mDelay = param1;
         }
      }
      
      public function get tooltipMaxWidth() : Number
      {
         if(this._tooltipObj)
         {
            return this.tooltipObj.GetMaxWidth();
         }
         return 0;
      }
      
      public function set tooltipMaxWidth(param1:Number) : void
      {
         if(param1 > 0)
         {
            this.tooltipObj.SetMaxWidth(param1);
         }
      }
      
      public function get tooltipHorizontalAlignment() : String
      {
         if(this._tooltipObj)
         {
            return this.tooltipObj.HorizontalAlignment;
         }
         return Alignment.CENTER;
      }
      
      public function set tooltipHorizontalAlignment(param1:String) : void
      {
         if(param1)
         {
            this.tooltipObj.HorizontalAlignment = param1;
         }
      }
      
      public function get tooltipVerticalAlignment() : String
      {
         if(this._tooltipObj)
         {
            return this.tooltipObj.VerticalAlignment;
         }
         return Alignment.CENTER;
      }
      
      public function set tooltipVerticalAlignment(param1:String) : void
      {
         if(param1)
         {
            this.tooltipObj.VerticalAlignment = param1;
         }
      }
      
      public function get tooltipMargins() : Margin
      {
         if(this._tooltipObj)
         {
            return this.tooltipObj.Margins;
         }
         return new Margin(0);
      }
      
      public function set tooltipMargins(param1:Margin) : void
      {
         if(param1)
         {
            this.tooltipObj.Margins = param1;
         }
      }
      
      public function ClearTooltip() : void
      {
         if(this._tooltipObj)
         {
            this._tooltipObj.HideTooltip();
         }
      }
      
      public function ShowTooltip() : void
      {
         if(this._tooltipObj)
         {
            this._tooltipObj.ShowTooltip();
         }
      }
      
      protected function SendTooltipEvent(param1:Event) : void
      {
         if(Boolean(this._tooltipObj) && this._tooltipObj.mbInitialized)
         {
            this.tooltipObj.HandleEvent(param1);
         }
      }
   }
}

