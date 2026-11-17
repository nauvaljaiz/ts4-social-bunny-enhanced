package olympus.extensions
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   import olympus.audio.Audio;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.io.CommunicationManager;
   import olympus.io.EventManager;
   import olympus.utils.WidgetUtils;
   
   public class AudioExtension implements IExtension
   {
      
      protected var mExtendable:DisplayObject;
      
      protected var mElementName:String;
      
      protected var mCategoryName:String = "Custom";
      
      protected var mWidgetName:String;
      
      protected var mDefaultContext:String;
      
      protected var mRedispatchMap:Object;
      
      protected var mbIgnoreWhenLoading:Boolean;
      
      public function AudioExtension()
      {
         super();
      }
      
      public static function Get(param1:IExtendable, param2:Boolean = true) : AudioExtension
      {
         return param1.GetExtension(AudioExtension,param2) as AudioExtension;
      }
      
      public function Extend(param1:IExtendable) : void
      {
         if(param1 is DisplayObject)
         {
            this.mExtendable = param1 as DisplayObject;
            return;
         }
         throw new Error("Cannot apply AudioExtension to non-Display Objects!");
      }
      
      public function set ElementName(param1:String) : void
      {
         this.mElementName = param1;
      }
      
      public function get ElementName() : String
      {
         var _loc1_:String = null;
         if(!this.mElementName)
         {
            _loc1_ = getQualifiedClassName(this.mExtendable).split("::",2).pop();
            this.mElementName = _loc1_;
         }
         return this.mElementName;
      }
      
      public function set CategoryName(param1:String) : void
      {
         this.mCategoryName = param1;
      }
      
      public function get CategoryName() : String
      {
         return this.mCategoryName;
      }
      
      public function set Context(param1:String) : void
      {
         this.mDefaultContext = param1;
      }
      
      public function get Context() : String
      {
         return this.mDefaultContext;
      }
      
      public function set IgnoreWhenLoading(param1:Boolean) : void
      {
         this.mbIgnoreWhenLoading = param1;
      }
      
      public function get IgnoreWhenLoading() : Boolean
      {
         return this.mbIgnoreWhenLoading;
      }
      
      public function Dispatch(param1:String, param2:String = null) : void
      {
         if(this.mbIgnoreWhenLoading && Boolean(CommunicationManager.CallUIService("IsUILoading")))
         {
            return;
         }
         if(!param2)
         {
            param2 = this.mDefaultContext;
         }
         EventManager.DispatchInteractionEvent(param1,this.ElementName,this.GetWidgetName(),this.CategoryName,param2);
      }
      
      public function DispatchShow(param1:String = null) : void
      {
         this.Dispatch(Audio.SHOW,param1);
      }
      
      public function DispatchHide(param1:String = null) : void
      {
         this.Dispatch(Audio.HIDE,param1);
      }
      
      public function Hookup(param1:String, param2:String = null) : void
      {
         this.mExtendable.addEventListener(param1,this.OnEvent,false,0,true);
         if(param2)
         {
            if(!this.mRedispatchMap)
            {
               this.mRedispatchMap = new Object();
            }
            this.mRedispatchMap[param1] = param2;
         }
      }
      
      public function Unhook(param1:String) : void
      {
         this.mExtendable.removeEventListener(param1,this.OnEvent);
         if(Boolean(this.mRedispatchMap) && Boolean(this.mRedispatchMap[param1]))
         {
            delete this.mRedispatchMap[param1];
         }
      }
      
      protected function OnEvent(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this.mRedispatchMap)
         {
            _loc2_ = this.mRedispatchMap[param1.type];
         }
         this.Dispatch(_loc2_ ? _loc2_ : param1.type);
      }
      
      protected function GetWidgetName() : String
      {
         if(!this.mWidgetName)
         {
            this.mWidgetName = WidgetUtils.GetBaseName(this.mExtendable);
         }
         return this.mWidgetName;
      }
   }
}

