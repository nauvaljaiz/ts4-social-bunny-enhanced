package gamedata.shared
{
   public final class OccultTypes
   {
      
      public static const OCCULT_NONE:int = 0;
      
      public static const OCCULT_HUMAN:int = 1 << 0;
      
      public static const OCCULT_ALIEN:int = 1 << 1;
      
      public static const OCCULT_VAMPIRE:int = 1 << 2;
      
      public static const OCCULT_MERMAID:int = 1 << 3;
      
      public static const OCCULT_WITCH:int = 1 << 4;
      
      public static const OCCULT_WEREWOLF:int = 1 << 5;
      
      public static const OCCULT_FAIRY:int = 1 << 6;
      
      public static const OCCULTS_WITH_ALTERNATVE_FORMS:int = OccultTypes.OCCULT_ALIEN | OccultTypes.OCCULT_VAMPIRE | OccultTypes.OCCULT_MERMAID | OccultTypes.OCCULT_WEREWOLF | OccultTypes.OCCULT_FAIRY;
      
      public static const MAX_OCCULT_FORMS:int = 2;
      
      public static const OCCULT_FORM_BASE:int = 0;
      
      public static const OCCULT_FORM_ALTERNATIVE:int = 1;
      
      public function OccultTypes()
      {
         super();
      }
      
      public static function GetRealOccultType(param1:int) : int
      {
         return param1 & ~OccultTypes.OCCULT_HUMAN;
      }
      
      public static function GetOccultTelemetryParam(param1:int) : String
      {
         var _loc2_:int = GetRealOccultType(param1);
         if(_loc2_ == OCCULT_NONE)
         {
            return "oct0";
         }
         var _loc3_:int = 0;
         while(_loc2_ != 1)
         {
            _loc3_++;
            _loc2_ >>= 1;
         }
         return "oct" + _loc3_;
      }
   }
}

