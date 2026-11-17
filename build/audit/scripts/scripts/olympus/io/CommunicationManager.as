package olympus.io
{
   import flash.display.DisplayObject;
   import flash.external.ExternalInterface;
   import olympus.core.OlympusObject;
   import olympus.io.interfaces.ICommunicationMapping;
   import olympus.utils.WidgetUtils;
   
   public class CommunicationManager
   {
      
      protected static var instance:CommunicationManager;
      
      public static const VALUE_TYPE_STRING:uint = 6;
      
      protected var mMessageListeners:Object;
      
      protected var mServiceHandlers:Object;
      
      protected var mCommunicationMapping:ICommunicationMapping;
      
      protected var mStoredOnDemandMessages:Object;
      
      public function CommunicationManager(param1:ICommunicationMapping = null)
      {
         super();
         if(instance == null)
         {
            instance = this;
            this.mStoredOnDemandMessages = new Object();
            this.mMessageListeners = new Object();
            this.mServiceHandlers = new Object();
            if(param1)
            {
               this.mCommunicationMapping = param1;
            }
            else
            {
               this.mCommunicationMapping = new CommunicationMapping();
            }
            this.ExternalCallbacks = true;
            return;
         }
      }
      
      public static function SendMessage(param1:String, param2:Object = null) : Boolean
      {
         if(!ExternalInterface.available)
         {
            return false;
         }
         var _loc3_:Boolean = ExternalInterface.call("SendGameMessage",param1,param2);
         var _loc4_:Boolean = instance.SendUIMessage(param1,param2);
         return _loc3_ || _loc4_;
      }
      
      public static function SendUIMessage(param1:String, param2:Object = null) : Boolean
      {
         return instance.SendUIMessage(param1,param2);
      }
      
      public static function CallUIService(param1:String, param2:Object = null) : Object
      {
         return instance.CallUIService(param1,param2);
      }
      
      public static function CallGameService(param1:String, param2:Object = null, param3:Boolean = false) : Object
      {
         return ExternalInterface.call("CallGameService",param1,param2,param3);
      }
      
      public static function ObjectSendMessage(param1:String, param2:String, param3:Object) : Boolean
      {
         if(!ExternalInterface.available)
         {
            return false;
         }
         return ExternalInterface.call("ObjectSendMessage",param1,param2,param3);
      }
      
      public static function PostServerCommand(param1:String, ... rest) : Object
      {
         return CallGameService("PostServerCommand",{
            "command":param1,
            "commandArgs":rest
         });
      }
      
      public static function AddMessageListener(param1:String, param2:Function, param3:DisplayObject, param4:Class = null) : Boolean
      {
         var _loc5_:String = WidgetUtils.GetBaseName(param3);
         if(_loc5_ == "UNKNOWN")
         {
            return false;
         }
         return instance.AddMessageListener(param1,param2,_loc5_,param4);
      }
      
      public static function AddMessageListenerByName(param1:String, param2:Function, param3:String, param4:Class = null) : Boolean
      {
         return instance.AddMessageListener(param1,param2,param3,param4);
      }
      
      public static function RemoveMessageListener(param1:String, param2:Function, param3:DisplayObject) : Boolean
      {
         var _loc4_:String = WidgetUtils.GetBaseName(param3);
         if(_loc4_ == "UNKNOWN")
         {
            return false;
         }
         return instance.RemoveMessageListener(param1,param2,_loc4_);
      }
      
      public static function RemoveMessageListenerByName(param1:String, param2:Function, param3:String) : Boolean
      {
         return instance.RemoveMessageListener(param1,param2,param3);
      }
      
      public static function RemoveMessageListenerByMessageName(param1:String, param2:DisplayObject) : Boolean
      {
         var _loc3_:String = WidgetUtils.GetBaseName(param2);
         if(_loc3_ == "UNKNOWN")
         {
            return false;
         }
         return instance.RemoveMessageListenerByMessageName(param1,_loc3_);
      }
      
      public static function RegisterServiceHandler(param1:String, param2:Function, param3:DisplayObject) : Boolean
      {
         var _loc4_:String = WidgetUtils.GetBaseName(param3);
         if(_loc4_ == "UNKNOWN")
         {
            return false;
         }
         return instance.RegisterServiceHandler(param1,param2,_loc4_);
      }
      
      public static function UnregisterServiceHandler(param1:String, param2:Function, param3:DisplayObject) : Boolean
      {
         var _loc4_:String = WidgetUtils.GetBaseName(param3);
         if(_loc4_ == "UNKNOWN")
         {
            return false;
         }
         return instance.UnregisterServiceHandler(param1,param2,_loc4_);
      }
      
      public static function RemoveWidgetFunctions(param1:String) : void
      {
         instance.RemoveWidgetFunctions(param1);
      }
      
      public static function TraceAutomation(param1:String) : Boolean
      {
         return instance.TraceAutomation(param1);
      }
      
      public function set ExternalCallbacks(param1:Boolean) : void
      {
         var value:Boolean = param1;
         if(ExternalInterface.available)
         {
            if(value)
            {
               ExternalInterface.addCallback("SendMessage",this.SendUIMessage);
               ExternalInterface.addCallback("CallService",this.CallUIService);
            }
            else
            {
               ExternalInterface.addCallback("SendMessage",function():void
               {
               });
               ExternalInterface.addCallback("CallService",function():void
               {
               });
            }
         }
      }
      
      public function StoreOnDemandMessagesForWidget(param1:String) : void
      {
         this.mStoredOnDemandMessages[param1] = new Array();
      }
      
      public function ClearOnDemandMessagesForWidget(param1:String) : void
      {
         if(this.mStoredOnDemandMessages[param1])
         {
            delete this.mStoredOnDemandMessages[param1];
         }
      }
      
      public function DispatchStoredOnDemandMessages(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:CommunicationObject = null;
         var _loc2_:Array = this.mStoredOnDemandMessages[param1];
         if(_loc2_)
         {
            delete this.mStoredOnDemandMessages[param1];
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc3_.messageName;
               _loc5_ = this.mMessageListeners[_loc3_.messageName];
               if(_loc5_)
               {
                  if(Boolean(this.mCommunicationMapping[_loc4_]) && !(_loc3_.args is OlympusObject))
                  {
                     _loc5_.DispatchToWidget(param1,new this.mCommunicationMapping[_loc4_](_loc3_.args));
                  }
                  else
                  {
                     _loc5_.DispatchToWidget(param1,_loc3_.args);
                  }
               }
            }
         }
      }
      
      public function SendUIMessage(param1:String, param2:Object = null) : Boolean
      {
         var _loc5_:Array = null;
         var _loc3_:CommunicationObject = this.mMessageListeners[param1];
         var _loc4_:Boolean = false;
         if(_loc3_)
         {
            if(Boolean(this.mCommunicationMapping[param1]) && !(param2 is OlympusObject))
            {
               _loc3_.Dispatch(new this.mCommunicationMapping[param1](param2));
            }
            else
            {
               _loc3_.Dispatch(param2);
            }
            _loc4_ = true;
         }
         for each(_loc5_ in this.mStoredOnDemandMessages)
         {
            _loc5_.push({
               "messageName":param1,
               "args":param2
            });
         }
         return _loc4_;
      }
      
      public function CallUIService(param1:String, param2:Object) : Object
      {
         var _loc3_:CommunicationObject = this.mServiceHandlers[param1];
         if(!_loc3_)
         {
            return null;
         }
         return _loc3_.Dispatch(param2);
      }
      
      public function AddMessageListener(param1:String, param2:Function, param3:String, param4:Class = null) : Boolean
      {
         if(param4)
         {
            if(!this.mCommunicationMapping.AddMapping(param1,param4))
            {
               return false;
            }
         }
         var _loc5_:CommunicationObject = this.mMessageListeners[param1];
         if(!_loc5_)
         {
            _loc5_ = new CommunicationObject(param3,param2);
            this.mMessageListeners[param1] = _loc5_;
         }
         else
         {
            _loc5_.AddFunction(param3,param2);
         }
         return true;
      }
      
      public function RemoveMessageListenerByMessageName(param1:String, param2:String) : Boolean
      {
         var _loc3_:CommunicationObject = this.mMessageListeners[param1];
         if(!_loc3_)
         {
            return false;
         }
         _loc3_.RemoveWidgetsFunctions(param2);
         if(_loc3_.IsEmpty())
         {
            this.mCommunicationMapping.RemoveMapping(param1);
            delete this.mMessageListeners[param1];
         }
         return true;
      }
      
      public function RemoveMessageListener(param1:String, param2:Function, param3:String) : Boolean
      {
         var _loc4_:CommunicationObject = this.mMessageListeners[param1];
         if(!_loc4_)
         {
            return false;
         }
         if(!_loc4_.RemoveFunction(param3,param2))
         {
            return false;
         }
         if(_loc4_.IsEmpty())
         {
            this.mCommunicationMapping.RemoveMapping(param1);
            delete this.mMessageListeners[param1];
         }
         return true;
      }
      
      public function RegisterServiceHandler(param1:String, param2:Function, param3:String) : Boolean
      {
         var _loc4_:CommunicationObject = this.mServiceHandlers[param1];
         if(_loc4_)
         {
            return false;
         }
         _loc4_ = new CommunicationObject(param3,param2);
         this.mServiceHandlers[param1] = _loc4_;
         return true;
      }
      
      public function UnregisterServiceHandler(param1:String, param2:Function, param3:String) : Boolean
      {
         var _loc4_:CommunicationObject = this.mServiceHandlers[param1];
         if(!_loc4_)
         {
            return false;
         }
         if(!_loc4_.HasFunction(param2) || !_loc4_.HasWidget(param3))
         {
            return false;
         }
         delete this.mServiceHandlers[param1];
         return true;
      }
      
      public function RemoveWidgetFunctions(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:CommunicationObject = null;
         var _loc4_:Array = new Array();
         for(_loc2_ in this.mMessageListeners)
         {
            _loc3_ = this.mMessageListeners[_loc2_];
            _loc3_.RemoveWidgetsFunctions(param1);
            if(_loc3_.IsEmpty())
            {
               this.mCommunicationMapping.RemoveMapping(_loc2_);
               _loc4_.push(_loc2_);
            }
         }
         for each(_loc2_ in _loc4_)
         {
            delete this.mMessageListeners[_loc2_];
         }
         _loc4_ = new Array();
         for(_loc2_ in this.mServiceHandlers)
         {
            _loc3_ = this.mServiceHandlers[_loc2_];
            if(_loc3_.HasWidget(param1))
            {
               _loc4_.push(_loc2_);
            }
         }
         for each(_loc2_ in _loc4_)
         {
            delete this.mServiceHandlers[_loc2_];
         }
         _loc4_ = new Array();
      }
      
      public function TraceAutomation(param1:String) : Boolean
      {
         if(!param1 || param1 == "")
         {
            return false;
         }
         ExternalInterface.call("TraceAutomation",param1);
         return true;
      }
   }
}

