package olympus.core
{
   import flash.geom.Vector3D;
   import flash.utils.getDefinitionByName;
   import olympus.localization.LocKey;
   
   public class OlympusObject
   {
      
      public function OlympusObject(param1:Object = null)
      {
         super();
         if(!param1)
         {
            return;
         }
         this.ParseObject(param1);
      }
      
      public static function FixupArray(param1:Array) : void
      {
         if(param1)
         {
            if(param1.length == 1 && param1[0] is Class)
            {
               param1.length = 0;
            }
         }
      }
      
      public static function FixupLocKey(param1:LocKey) : LocKey
      {
         if(Boolean(param1) && !param1.IsValid())
         {
            return null;
         }
         return param1;
      }
      
      public static function ConstructArrayInPlace(param1:Array, param2:Class) : void
      {
         if(!param2)
         {
            param1.length = 0;
            return;
         }
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            param1[_loc3_] = new param2(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      public static function ArrayToObject(param1:Array) : Array
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:Array = new Array(_loc2_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_[_loc4_] = param1[_loc4_].ToObject();
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function ConstructArrayFromArray(param1:Array, param2:Array, param3:Class = null) : void
      {
         if(!param2)
         {
            FixupArray(param1);
            return;
         }
         if(Boolean(!param3 && param1) && Boolean(param1.length == 1) && param1[0] is Class)
         {
            param3 = param1[0];
         }
         param1.length = param2.length;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            param1[_loc4_] = new param3(param2[_loc4_]);
            _loc4_++;
         }
      }
      
      public function ParseObject(param1:Object) : void
      {
         var fieldName:String = null;
         var prop:Object = null;
         var objArray:Array = null;
         var arrayClass:Class = null;
         var len:int = 0;
         var i:int = 0;
         var objField:Object = null;
         var propDate:Date = null;
         var obj:Object = param1;
         for(fieldName in obj)
         {
            prop = this[fieldName];
            if(prop)
            {
               if(prop is OlympusObject)
               {
                  prop.ParseObject(obj[fieldName]);
                  continue;
               }
               if(prop is Array)
               {
                  objArray = obj[fieldName] as Array;
                  if(objArray)
                  {
                     arrayClass = prop[0] as Class;
                     len = int(objArray.length);
                     if(arrayClass)
                     {
                        prop.length = len;
                        i = 0;
                        while(i < len)
                        {
                           prop[i] = new arrayClass(objArray[i]);
                           i++;
                        }
                     }
                     else
                     {
                        prop.length = 0;
                     }
                     continue;
                  }
               }
               if(prop is Vector3D)
               {
                  prop.x = obj[fieldName].x;
                  prop.y = obj[fieldName].y;
                  prop.z = obj[fieldName].z;
                  continue;
               }
               if(prop is Date)
               {
                  objField = obj[fieldName];
                  propDate = prop as Date;
                  if(objField["utc"])
                  {
                     propDate.setUTCFullYear(objField.fullYear,objField.month,objField.date);
                     propDate.setUTCHours(objField.hours,objField.minutes,objField.seconds,objField.milliseconds);
                  }
                  else
                  {
                     propDate.setFullYear(objField.fullYear,objField.month,objField.date);
                     propDate.setHours(objField.hours,objField.minutes,objField.seconds,objField.milliseconds);
                  }
                  continue;
               }
            }
            try
            {
               this[fieldName] = obj[fieldName];
            }
            catch(err:Error)
            {
            }
         }
      }
   }
}

