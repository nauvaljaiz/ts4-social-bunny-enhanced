package gamedata.Gameplay.shared.definitions
{
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   
   public class CareerPartTimeShiftIconsStaticData extends OlympusObject
   {
      
      protected static var sCareerPartTimeShiftIconsStaticData:Vector.<CareerPartTimeShiftIconsStaticData>;
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sShiftMap:Object = new Object();
      
      public var shift_type:int;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public function CareerPartTimeShiftIconsStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:int) : CareerPartTimeShiftIconsStaticData
      {
         var _loc4_:Object = null;
         var _loc2_:CareerPartTimeShiftIconsStaticData = sShiftMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc();
         for each(_loc4_ in _loc3_)
         {
            _loc2_ = new CareerPartTimeShiftIconsStaticData(_loc4_);
            sShiftMap[_loc2_.shift_type] = _loc2_;
         }
         return sShiftMap[param1];
      }
   }
}

