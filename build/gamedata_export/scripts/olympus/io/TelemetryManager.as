package olympus.io
{
   public class TelemetryManager
   {
      
      public static var mTelemetryRequests:Array;
      
      public static var mSessionValueMap:Object;
      
      public static const GAME:String = "GAME";
      
      public static const SHOW_HIDE:String = "WGSH";
      
      public static const HUD_PANEL:String = "HUDP";
      
      public static const GOAL:String = "GOAL";
      
      public static const CAREER:String = "CARR";
      
      public static const CAMERA_PANEL:String = "CAMP";
      
      public static const FILTER:String = "FILT";
      
      public function TelemetryManager()
      {
         super();
      }
      
      public static function Init() : void
      {
         mTelemetryRequests = new Array();
         mSessionValueMap = new Object();
      }
      
      public static function SetSessionValue(param1:String, param2:Object) : void
      {
         if(param2 == null)
         {
            if(param1 in mSessionValueMap)
            {
               delete mSessionValueMap[param1];
            }
         }
         else
         {
            mSessionValueMap[param1] = param2;
         }
      }
      
      public static function GetSessionValue(param1:String) : Object
      {
         return mSessionValueMap[param1];
      }
      
      public static function GetSessionValueAsInt(param1:String) : int
      {
         return mSessionValueMap[param1] as int;
      }
      
      public static function HasSessionValue(param1:String) : Boolean
      {
         return param1 in mSessionValueMap;
      }
      
      public static function DispatchTelemetryEvent(param1:String, param2:String, param3:String, param4:Object = null) : void
      {
         param4 = AttributeObjectToArray(param4);
         var _loc5_:Object = {
            "moduleId":param1,
            "groupId":param2,
            "nameId":param3,
            "attributes":param4
         };
         mTelemetryRequests.push(_loc5_);
      }
      
      public static function DispatchTelemetryEventObject(param1:Object) : void
      {
         if(!(param1.attributes is Array))
         {
            param1.attributes = AttributeObjectToArray(param1.attributes);
         }
         mTelemetryRequests.push(param1);
      }
      
      public static function BuildTelemetryEventObject(param1:String, param2:String, param3:String, param4:Object = null) : Object
      {
         return {
            "moduleId":param1,
            "groupId":param2,
            "nameId":param3,
            "attributes":param4
         };
      }
      
      public static function DispatchTelemetryTimedRegion(param1:Boolean, param2:String, param3:String, param4:Object = null, param5:String = null, param6:* = false) : void
      {
         param4 = AttributeObjectToArray(param4);
         var _loc7_:Object = {
            "start":param1,
            "groupId":param2,
            "nameId":param3,
            "attributes":param4,
            "sendNow":param6
         };
         if(param5)
         {
            _loc7_.moduleId = param5;
         }
         mTelemetryRequests.unshift(_loc7_);
      }
      
      public static function AttributeObjectToArray(param1:Object) : Array
      {
         var _loc3_:String = null;
         if(!param1)
         {
            return null;
         }
         if(param1 is Array)
         {
            return param1 as Array;
         }
         var _loc2_:Array = new Array();
         for(_loc3_ in param1)
         {
            _loc2_.push({
               "attr":_loc3_,
               "value":param1[_loc3_]
            });
         }
         return _loc2_;
      }
   }
}

