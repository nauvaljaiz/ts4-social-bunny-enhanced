package gamedata.Dialog
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class UiSendMessageArgs extends OlympusObject
   {
      
      public static const ACTION_SEND_UI_MESSAGE:int = 0;
      
      public static const ACTION_SEND_GAME_MESSAGE:int = 1;
      
      public static const ACTION_CALL_UI_SERVICE:int = 2;
      
      public static const ACTION_CALL_GAME_SERVICE:int = 3;
      
      public var action:int;
      
      public var name:String;
      
      public var parameters:Object;
      
      public function UiSendMessageArgs(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         super.ParseObject(param1);
         var _loc2_:Array = this.parameters as Array;
         if(_loc2_)
         {
            this.parameters = new Object();
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc3_["name"];
               _loc5_ = _loc3_["value"];
               if("raw_int" in _loc5_)
               {
                  this.parameters[_loc4_] = _loc5_["raw_int"];
               }
               else if("raw_float" in _loc5_)
               {
                  this.parameters[_loc4_] = _loc5_["raw_float"];
               }
               else if("raw_string" in _loc5_)
               {
                  this.parameters[_loc4_] = _loc5_["raw_string"];
               }
               else if("raw_bool" in _loc5_)
               {
                  this.parameters[_loc4_] = _loc5_["raw_bool"];
               }
               else if("resource_key" in _loc5_)
               {
                  this.parameters[_loc4_] = new ResourceKey(_loc5_["resource_key"]);
               }
            }
         }
      }
   }
}

