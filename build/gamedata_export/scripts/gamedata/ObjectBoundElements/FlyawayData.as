package gamedata.ObjectBoundElements
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class FlyawayData extends OlympusObject
   {
      
      public static var sGetStaticDataFunc:Function;
      
      public static const FX_ENUM_NO_EFFECT:int = 0;
      
      public static const FX_ENUM_INCREASE:int = 1;
      
      public static const FX_ENUM_DECREASE:int = 2;
      
      protected static var sLevelsMap:Object = new Object();
      
      public var text:LocKey = new LocKey();
      
      public var priority:int;
      
      public var levels:Array = [FlyawayLevelData];
      
      public function FlyawayData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetDataByTypeId(param1:String) : FlyawayData
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:FlyawayData = sLevelsMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Object = sGetStaticDataFunc({"headlineTypeId":param1});
         if(_loc3_)
         {
            _loc2_ = new FlyawayData(_loc3_);
            sLevelsMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      public static function GetLevel(param1:FlyawayData, param2:Number) : FlyawayLevelData
      {
         var _loc3_:FlyawayLevelData = null;
         for each(_loc3_ in param1.levels)
         {
            if(_loc3_.minimum_value <= param2 && _loc3_.maximum_value > param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

