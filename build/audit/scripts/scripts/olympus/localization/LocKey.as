package olympus.localization
{
   import olympus.core.OlympusObject;
   import olympus.utils.Reflection;
   
   public class LocKey extends OlympusObject
   {
      
      public static var sGetLocalizedStringFunc:Function;
      
      public static const TOKEN_TYPE_INVALID:int = 0;
      
      public static const TOKEN_TYPE_SIM:int = 1;
      
      public static const TOKEN_TYPE_STRING:int = 2;
      
      public static const TOKEN_TYPE_RAW_TEXT:int = 3;
      
      public static const TOKEN_TYPE_NUMBER:int = 4;
      
      public static const TOKEN_TYPE_OBJECT:int = 5;
      
      public static const TOKEN_TYPE_DATE_AND_TIME:int = 6;
      
      public static const TOKEN_TYPE_RICHDATA:int = 7;
      
      public static const TOKEN_TYPE_STRING_LIST:int = 8;
      
      public static const FILENAME_SAFE:uint = 4;
      
      public var hash:uint;
      
      public var tokens:Array;
      
      public var flags:uint = 0;
      
      protected var mString:String;
      
      public function LocKey(param1:Object = null)
      {
         super(param1);
      }
      
      public static function FromHash(param1:uint, param2:Array = null, param3:uint = 0) : LocKey
      {
         var _loc4_:LocKey = new LocKey();
         _loc4_.hash = param1;
         _loc4_.tokens = param2;
         _loc4_.flags = param3;
         return _loc4_;
      }
      
      public static function UntranslatedString(param1:String) : LocKey
      {
         var _loc2_:LocKey = new LocKey();
         _loc2_.mString = param1;
         return _loc2_;
      }
      
      public static function GetValidatedLocKey(param1:Object) : LocKey
      {
         if(Boolean(param1) && param1["hash"] != 0)
         {
            return new LocKey(param1);
         }
         return null;
      }
      
      public static function ClearCachedStrings(... rest) : void
      {
         var _loc2_:Class = null;
         var _loc3_:Array = null;
         var _loc4_:LocKey = null;
         for each(_loc2_ in rest)
         {
            _loc3_ = Reflection.GetMembersOfType(_loc2_,LocKey);
            for each(_loc4_ in _loc3_)
            {
               _loc4_.ClearCachedString();
            }
         }
      }
      
      override public function ParseObject(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         this.hash = param1["hash"];
         this.tokens = param1["tokens"];
         this.mString = null;
      }
      
      public function Clone(param1:Array = null) : LocKey
      {
         var _loc2_:LocKey = new LocKey();
         _loc2_.hash = this.hash;
         _loc2_.tokens = param1 ? param1 : (this.tokens ? this.tokens.concat() : null);
         _loc2_.flags = this.flags;
         return _loc2_;
      }
      
      public function IsValid() : Boolean
      {
         return this.hash != 0;
      }
      
      public function ClearCachedString() : void
      {
         this.mString = null;
      }
      
      public function toString(... rest) : String
      {
         if(rest.length > 0)
         {
            return sGetLocalizedStringFunc({
               "hash":this.hash,
               "tokens":rest,
               "flags":this.flags
            }) as String;
         }
         if(!this.mString)
         {
            if(!this.hash)
            {
               return "";
            }
            this.mString = sGetLocalizedStringFunc(this) as String;
         }
         return this.mString;
      }
      
      public function HasInvalidObjectNameTokens() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.tokens)
         {
            if(Boolean(_loc1_ && _loc1_["type"] == TOKEN_TYPE_OBJECT) && Boolean(_loc1_["catalog_name_key"] == 0) && (!(_loc1_["custom_name"] is String) || _loc1_["custom_name"].length == 0))
            {
               return true;
            }
         }
         return false;
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = {"hash":this.hash};
         if(Boolean(this.tokens) && Boolean(this.tokens.length))
         {
            _loc1_["tokens"] = this.tokens;
         }
         return _loc1_;
      }
   }
}

