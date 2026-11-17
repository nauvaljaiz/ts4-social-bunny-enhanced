package olympus.extensions
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import olympus.interfaces.IExtendable;
   import olympus.interfaces.IExtension;
   import olympus.io.CommunicationManager;
   
   public class CommunicationExtension implements IExtension
   {
      
      protected var mControl:DisplayObject;
      
      protected var mMessageListeners:Object = new Object();
      
      public function CommunicationExtension()
      {
         super();
      }
      
      public static function Get(param1:IExtendable) : CommunicationExtension
      {
         return param1.GetExtension(CommunicationExtension) as CommunicationExtension;
      }
      
      public function Extend(param1:IExtendable) : void
      {
         this.mControl = param1 as DisplayObject;
         if(!this.mControl)
         {
            throw new Error("Cannot apply CommunicationExtension to non-DisplayObject!");
         }
         this.mControl.addEventListener(Event.ADDED_TO_STAGE,this.OnAddedToStage,false,0,true);
         this.mControl.addEventListener(Event.REMOVED_FROM_STAGE,this.OnRemovedFromStage,false,0,true);
      }
      
      public function SetMessageListener(param1:String, param2:Function, param3:Class = null) : CommunicationExtension
      {
         var _loc4_:Object = this.mMessageListeners[param1];
         if((Boolean(_loc4_)) && Boolean(this.mControl.stage))
         {
            CommunicationManager.RemoveMessageListener(param1,_loc4_.handler,this.mControl);
         }
         if(!param2)
         {
            delete this.mMessageListeners[param1];
         }
         else
         {
            this.mMessageListeners[param1] = {
               "handler":param2,
               "messageClass":param3
            };
            if(this.mControl.stage)
            {
               CommunicationManager.AddMessageListener(param1,param2,this.mControl,param3);
            }
         }
         return this;
      }
      
      public function ClearMessageListener(param1:String) : CommunicationExtension
      {
         this.SetMessageListener(param1,null);
         return this;
      }
      
      protected function OnAddedToStage(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         for(_loc2_ in this.mMessageListeners)
         {
            _loc3_ = this.mMessageListeners[_loc2_];
            CommunicationManager.AddMessageListener(_loc2_,_loc3_.handler,this.mControl,_loc3_.messageClass);
         }
      }
      
      protected function OnRemovedFromStage(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         for(_loc2_ in this.mMessageListeners)
         {
            _loc3_ = this.mMessageListeners[_loc2_];
            CommunicationManager.RemoveMessageListener(_loc2_,_loc3_.handler,this.mControl);
         }
      }
   }
}

