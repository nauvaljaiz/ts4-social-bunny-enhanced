package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   
   public class LoanStaticData extends OlympusObject
   {
      
      public static var sGetStaticDataFunc:Function;
      
      public static const INVALID:int = 0;
      
      public static const UNIVERSITY:int = 1;
      
      protected static var sLoanMap:Object = new Object();
      
      public var loan_type:int;
      
      public var interest_rate:Number;
      
      public function LoanStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:int) : LoanStaticData
      {
         var _loc4_:Object = null;
         var _loc2_:LoanStaticData = sLoanMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc();
         for each(_loc4_ in _loc3_)
         {
            _loc2_ = new LoanStaticData(_loc4_);
            _loc2_.interest_rate /= 100;
            sLoanMap[_loc2_.loan_type] = _loc2_;
         }
         return sLoanMap[param1];
      }
   }
}

