package olympus.extensions
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import olympus.core.widget.WidgetBase;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.io.TelemetryAttribute;
   import olympus.io.TelemetryManager;
   
   public class TelemetryExtension implements IExtension
   {
      
      protected var mTelemeterTarget:DisplayObject;
      
      protected var mbVisibilityTelemetryEnabled:Boolean = true;
      
      protected var mModule:String = "GAME";
      
      protected var mGroup:String;
      
      protected var mAttributes:Array = null;
      
      protected var mHookedEvents:Array;
      
      public function TelemetryExtension()
      {
         super();
      }
      
      public static function Get(param1:IExtendable) : TelemetryExtension
      {
         return param1.GetExtension(TelemetryExtension) as TelemetryExtension;
      }
      
      public function Extend(param1:IExtendable) : void
      {
         if(param1 is DisplayObject)
         {
            this.mTelemeterTarget = param1 as DisplayObject;
            return;
         }
         throw new Error("Telemetry Extension cannot work with non-Display Objects!");
      }
      
      public function get Module() : String
      {
         return this.mModule;
      }
      
      public function set Module(param1:String) : void
      {
         this.mModule = param1;
      }
      
      public function get Group() : String
      {
         return this.mGroup;
      }
      
      public function set Group(param1:String) : void
      {
         this.mGroup = param1;
      }
      
      public function get Attributes() : Array
      {
         return this.mAttributes;
      }
      
      public function set Attributes(param1:Array) : void
      {
         this.mAttributes = param1;
      }
      
      public function AddAttribute(param1:TelemetryAttribute) : void
      {
         if(!this.mAttributes)
         {
            this.mAttributes = new Array();
         }
         this.mAttributes.push(param1);
      }
      
      public function BeginTimedRegion(param1:String, param2:String = null, param3:String = null, param4:Object = null) : void
      {
         this.BeginOrEndTimedRegion(true,param1,param2,param3,param4);
      }
      
      public function EndTimedRegion(param1:String, param2:String = null, param3:String = null, param4:Object = null, param5:Boolean = false) : void
      {
         this.BeginOrEndTimedRegion(false,param1,param2,param3,param4,param5);
      }
      
      public function BeginOrEndTimedRegion(param1:Boolean, param2:String, param3:String = null, param4:String = null, param5:Object = null, param6:Boolean = false) : void
      {
         param3 ||= this.mGroup;
         param4 ||= this.mModule;
         param5 ||= this.mAttributes;
         if(Boolean(param2) && Boolean(param3) && Boolean(param4))
         {
            TelemetryManager.DispatchTelemetryTimedRegion(param1,param3,param2,param5,param4,param6);
         }
      }
      
      public function DispatchEvent(param1:String, param2:String = null, param3:String = null, param4:Object = null) : void
      {
         param2 ||= this.mGroup;
         param3 ||= this.mModule;
         param4 ||= this.mAttributes;
         if(Boolean(param1) && Boolean(param2) && Boolean(param3))
         {
            TelemetryManager.DispatchTelemetryEvent(param3,param2,param1,param4);
         }
      }
      
      public function HookTriggerEvent(param1:String, param2:String, param3:String = null, param4:String = null, param5:Object = null) : void
      {
         if(!this.mHookedEvents)
         {
            this.mHookedEvents = new Array();
         }
         this.mHookedEvents.push(new HookedEvent(param1,param2,param3,param4,param5));
         this.mTelemeterTarget.addEventListener(param1,this.OnHookedEvent,false,0,true);
      }
      
      public function UnhookTriggerEvent(param1:String) : void
      {
         var triggerEvent:String = param1;
         if(this.mHookedEvents)
         {
            this.mHookedEvents = this.mHookedEvents.filter(function(param1:HookedEvent):Boolean
            {
               return param1.mTriggerEvent != triggerEvent;
            });
            if(this.mHookedEvents.length == 0)
            {
               this.mHookedEvents = null;
            }
         }
      }
      
      protected function OnHookedEvent(param1:Event) : void
      {
         var _loc2_:HookedEvent = null;
         for each(_loc2_ in this.mHookedEvents)
         {
            if(_loc2_.mTriggerEvent == param1.type)
            {
               this.DispatchEvent(_loc2_.mTelemetryName,_loc2_.mTelemetryGroup,_loc2_.mTelemetryModule,_loc2_.mTelemetryAttributes);
            }
         }
      }
      
      public function get EnableVisibilityTelemetry() : Boolean
      {
         return this.mbVisibilityTelemetryEnabled;
      }
      
      public function set EnableVisibilityTelemetry(param1:Boolean) : void
      {
         this.mbVisibilityTelemetryEnabled = param1;
      }
      
      public function DispatchShow() : void
      {
         if(!this.mbVisibilityTelemetryEnabled)
         {
            return;
         }
         var _loc1_:WidgetBase = this.mTelemeterTarget as WidgetBase;
         if(_loc1_)
         {
            this.BeginTimedRegion(_loc1_.TelemetryName,TelemetryManager.SHOW_HIDE);
         }
      }
      
      public function DispatchHide() : void
      {
         if(!this.mbVisibilityTelemetryEnabled)
         {
            return;
         }
         var _loc1_:WidgetBase = this.mTelemeterTarget as WidgetBase;
         if(_loc1_)
         {
            this.EndTimedRegion(_loc1_.TelemetryName,TelemetryManager.SHOW_HIDE);
         }
      }
   }
}

class HookedEvent
{
   
   public var mTriggerEvent:String;
   
   public var mTelemetryName:String;
   
   public var mTelemetryGroup:String;
   
   public var mTelemetryModule:String;
   
   public var mTelemetryAttributes:Object;
   
   public function HookedEvent(param1:String, param2:String, param3:String, param4:String, param5:Object)
   {
      super();
      this.mTriggerEvent = param1;
      this.mTelemetryName = param2;
      this.mTelemetryGroup = param3;
      this.mTelemetryModule = param4;
      this.mTelemetryAttributes = param5;
   }
}
