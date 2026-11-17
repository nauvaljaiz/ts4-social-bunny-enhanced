package olympus.core
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import olympus.events.TickerEvent;
   import olympus.utils.WidgetUtils;
   
   public class Ticker
   {
      
      protected static var sTickerObjects:Dictionary = new Dictionary(true);
      
      protected static var sEveryFrameTickerObjects:Dictionary = new Dictionary(true);
      
      protected static var sObjectsForWidget:Object = new Object();
      
      protected static var sLastTime:int = getTimer();
      
      setInterval(Ticker.OnEnterFrame,0);
      
      public function Ticker()
      {
         super();
      }
      
      protected static function OnEnterFrame() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Object = null;
         var _loc6_:Dictionary = null;
         if(!Time.IsValid())
         {
            return;
         }
         _loc1_ = getTimer();
         var _loc2_:TickerEvent = new TickerEvent("tick",_loc1_ - sLastTime);
         sLastTime = _loc1_;
         var _loc4_:Array = new Array();
         var _loc5_:Dictionary = sTickerObjects;
         for(_loc3_ in _loc5_)
         {
            if(_loc5_[_loc3_].Update(_loc2_))
            {
               _loc4_.push(_loc3_);
            }
         }
         _loc6_ = sEveryFrameTickerObjects;
         for each(_loc3_ in _loc6_)
         {
            _loc3_.dispatchEvent(_loc2_);
         }
         for each(_loc3_ in _loc4_)
         {
            if(Has(_loc3_) && Boolean(_loc5_[_loc3_].mbToRemove))
            {
               RemoveObjFromWidgetMap(_loc3_);
               delete _loc5_[_loc3_];
            }
         }
      }
      
      public static function Add(param1:*, param2:Number, param3:Function, param4:Boolean = false, param5:Boolean = true) : Boolean
      {
         var _loc8_:String = null;
         var _loc6_:Boolean = false;
         if(sTickerObjects[param1])
         {
            if(!sTickerObjects[param1].mbToRemove)
            {
               return false;
            }
            _loc6_ = true;
         }
         if(sEveryFrameTickerObjects[param1])
         {
            return false;
         }
         var _loc7_:TickerObject = new TickerObject(param2,param3,param4,param5);
         if(param2 == 0)
         {
            sEveryFrameTickerObjects[param1] = _loc7_;
         }
         else
         {
            sTickerObjects[param1] = _loc7_;
         }
         if(param1 is DisplayObject && !_loc6_)
         {
            _loc8_ = WidgetUtils.GetBaseName(param1);
            if(!sObjectsForWidget[_loc8_])
            {
               sObjectsForWidget[_loc8_] = new Array();
            }
            sObjectsForWidget[_loc8_].push(param1);
         }
         return true;
      }
      
      public static function Remove(param1:*) : Boolean
      {
         if(sTickerObjects[param1])
         {
            RemoveObjFromWidgetMap(param1);
            delete sTickerObjects[param1];
            return true;
         }
         if(sEveryFrameTickerObjects[param1])
         {
            RemoveObjFromWidgetMap(param1);
            delete sEveryFrameTickerObjects[param1];
            return true;
         }
         return false;
      }
      
      public static function Has(param1:*) : Boolean
      {
         return Boolean(sTickerObjects[param1]) || Boolean(sEveryFrameTickerObjects[param1]);
      }
      
      public static function Reset(param1:*) : Boolean
      {
         if(sTickerObjects[param1])
         {
            sTickerObjects[param1].Reset();
            return true;
         }
         return false;
      }
      
      public static function RemoveTickersForWidget(param1:String) : void
      {
         var _loc3_:DisplayObject = null;
         if(!sObjectsForWidget[param1])
         {
            return;
         }
         var _loc2_:Array = sObjectsForWidget[param1].concat();
         for each(_loc3_ in _loc2_)
         {
            if(!Remove(_loc3_))
            {
               RemoveObjFromWidgetMap(_loc3_);
            }
         }
      }
      
      protected static function RemoveObjFromWidgetMap(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc2_:DisplayObject = param1 as DisplayObject;
         if(_loc2_)
         {
            _loc3_ = WidgetUtils.GetBaseName(_loc2_);
            if(sObjectsForWidget[_loc3_])
            {
               _loc4_ = int(sObjectsForWidget[_loc3_].indexOf(_loc2_));
               if(_loc4_ != -1)
               {
                  sObjectsForWidget[_loc3_].splice(_loc4_,1);
               }
               if(sObjectsForWidget[_loc3_].length == 0)
               {
                  delete sObjectsForWidget[_loc3_];
               }
            }
         }
      }
   }
}

