package olympus.core.data
{
   public class SettingsMap
   {
      
      protected var mSettingsMap:Object = new Object();
      
      protected var mActiveId:String;
      
      protected var mPendingRemovals:Array = new Array();
      
      public function SettingsMap()
      {
         super();
      }
      
      public function set ActiveId(param1:String) : void
      {
         this.mActiveId = param1;
      }
      
      public function get ActiveId() : String
      {
         return this.mActiveId;
      }
      
      public function GetKeyValueArray() : Array
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc1_:Array = new Array();
         var _loc2_:Object = this.mSettingsMap;
         for(_loc3_ in _loc2_)
         {
            _loc4_ = _loc2_[_loc3_];
            for(_loc5_ in _loc4_)
            {
               _loc6_ = _loc4_[_loc5_];
               _loc7_ = false;
               if(Boolean(_loc6_) && _loc6_.hasOwnProperty("remove"))
               {
                  _loc7_ = true;
                  _loc6_ = _loc6_.value;
               }
               if(_loc6_ is Number)
               {
                  _loc8_ = "number";
               }
               else if(_loc6_ is int)
               {
                  _loc8_ = "int";
               }
               else if(_loc6_ is uint)
               {
                  _loc8_ = "uint";
               }
               else if(_loc6_ is Boolean)
               {
                  _loc8_ = "boolean";
               }
               else
               {
                  if(!(_loc6_ is String))
                  {
                     continue;
                  }
                  _loc8_ = "string";
               }
               _loc9_ = new Array(2);
               _loc9_[0] = [_loc3_,_loc5_,_loc8_].join("#");
               if(_loc6_ != null && !_loc7_)
               {
                  _loc9_[1] = _loc6_.toString();
               }
               else
               {
                  _loc9_[1] = null;
               }
               _loc1_.push(_loc9_);
            }
         }
         return _loc1_;
      }
      
      public function ParseSettings(param1:String, param2:String) : void
      {
         var _loc7_:Class = null;
         var _loc8_:Object = null;
         var _loc3_:Array = param1.split("#");
         if(_loc3_.length != 3)
         {
            return;
         }
         var _loc4_:String = _loc3_[0];
         var _loc5_:String = _loc3_[1];
         _loc5_ = _loc5_.toLowerCase();
         var _loc6_:String = _loc3_[2];
         _loc6_ = _loc6_.toLowerCase();
         switch(_loc6_)
         {
            case "number":
               _loc7_ = Class(Number);
               break;
            case "uint":
               _loc7_ = Class(uint);
               break;
            case "int":
               _loc7_ = Class(int);
               break;
            case "string":
               _loc7_ = Class(String);
               break;
            case "boolean":
               _loc7_ = Class(Boolean);
               break;
            default:
               return;
         }
         if(_loc7_ == Boolean)
         {
            _loc8_ = param2 == "true";
         }
         else
         {
            _loc8_ = _loc7_(param2);
         }
         this.SetValue(_loc5_,_loc8_,_loc4_);
      }
      
      public function SetValue(param1:String, param2:Object, param3:String = null) : void
      {
         var _loc4_:Object = this.mSettingsMap;
         var _loc5_:String = param3 ? param3 : this.mActiveId;
         param1 = param1.toLowerCase();
         if(!_loc5_)
         {
            return;
         }
         var _loc6_:Object = _loc4_[_loc5_];
         if(!_loc6_)
         {
            _loc6_ = new Object();
            _loc4_[_loc5_] = _loc6_;
         }
         if(param2 == null)
         {
            if(_loc6_.hasOwnProperty(param1) && !_loc6_[param1].hasOwnProperty("remove"))
            {
               _loc6_[param1] = {
                  "remove":true,
                  "value":_loc6_[param1]
               };
               this.mPendingRemovals.push({
                  "id":_loc5_,
                  "key":param1
               });
            }
         }
         else
         {
            _loc6_[param1] = param2;
         }
      }
      
      public function GetValue(param1:String, param2:String = null) : Object
      {
         var _loc3_:String = param2 ? param2 : this.mActiveId;
         param1 = param1.toLowerCase();
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Object = this.mSettingsMap[_loc3_];
         if(!_loc4_)
         {
            return null;
         }
         if(Boolean(_loc4_[param1]) && Boolean(_loc4_[param1].hasOwnProperty("remove")))
         {
            return null;
         }
         return _loc4_[param1];
      }
      
      public function RemoveDefaultValues(param1:String, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc3_:Object = this.mSettingsMap;
         param1 = param1.toLowerCase();
         for(_loc4_ in _loc3_)
         {
            _loc5_ = _loc3_[_loc4_];
            if((Boolean(_loc5_)) && _loc5_[param1] == param2)
            {
               _loc5_[param1] = {
                  "remove":true,
                  "value":_loc5_[param1]
               };
               this.mPendingRemovals.push({
                  "id":_loc4_,
                  "key":param1
               });
            }
         }
      }
      
      public function RemoveID(param1:String) : void
      {
         var _loc2_:Object = this.mSettingsMap[param1];
         if(_loc2_)
         {
            delete this.mSettingsMap[param1];
         }
      }
      
      public function RemoveKey(param1:String, param2:String = null) : void
      {
         var _loc3_:String = param2 ? param2 : this.mActiveId;
         param1 = param1.toLowerCase();
         var _loc4_:Object = this.mSettingsMap[_loc3_];
         if(!_loc4_)
         {
            return;
         }
         if(Boolean(_loc4_[param1]) && !_loc4_[param1].hasOwnProperty("remove"))
         {
            _loc4_[param1] = {
               "remove":true,
               "value":_loc4_[param1]
            };
            this.mPendingRemovals.push({
               "id":this.mActiveId,
               "key":param1
            });
         }
      }
      
      public function CleanRemovedValues() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(this.mPendingRemovals.length)
         {
            _loc1_ = this.mSettingsMap;
            for each(_loc4_ in this.mPendingRemovals)
            {
               _loc2_ = _loc1_[_loc4_.id];
               if(_loc2_)
               {
                  _loc3_ = _loc2_[_loc4_.key];
                  if(Boolean(_loc3_) && _loc3_.hasOwnProperty("remove"))
                  {
                     delete _loc2_[_loc4_.key];
                  }
               }
            }
            this.mPendingRemovals.length = 0;
         }
      }
      
      public function ListStoreValue(param1:String, param2:Object, param3:String = null) : Boolean
      {
         var _loc4_:String = this.GetValue(param1,param3) as String;
         var _loc5_:Array = _loc4_ ? _loc4_.split("|") : new Array();
         var _loc6_:int = _loc5_.indexOf(param2);
         if(_loc6_ != -1)
         {
            return false;
         }
         _loc5_.push(param2);
         this.SetValue(param1,_loc5_.join("|"),param3);
         return true;
      }
      
      public function ListRemoveValue(param1:String, param2:Object, param3:String = null) : Boolean
      {
         var _loc4_:String = this.GetValue(param1,param3) as String;
         if(!_loc4_)
         {
            return false;
         }
         var _loc5_:Array = _loc4_.split("|");
         var _loc6_:int = _loc5_.indexOf(param2);
         if(_loc6_ == -1)
         {
            return false;
         }
         _loc5_.splice(_loc6_,1);
         this.SetValue(param1,_loc5_.join("|"),param3);
         return true;
      }
      
      public function ListContainsValue(param1:String, param2:Object, param3:String = null) : Boolean
      {
         var _loc4_:String = this.GetValue(param1,param3) as String;
         if(!_loc4_)
         {
            return false;
         }
         return _loc4_.split("|").indexOf(param2) != -1;
      }
      
      public function ListCullValues(param1:String, param2:Array, param3:String = null) : void
      {
         var remainingValues:Array;
         var key:String = param1;
         var keepValues:Array = param2;
         var id:String = param3;
         var arrayString:String = this.GetValue(key,id) as String;
         if(!arrayString)
         {
            return;
         }
         remainingValues = arrayString.split("|").filter(function(param1:Object):*
         {
            return keepValues.indexOf(param1) != -1;
         });
         this.SetValue(key,remainingValues.join("|"),id);
      }
   }
}

