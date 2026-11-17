package gamedata.BuildBuy.constants
{
   public class ProductObjectFlags
   {
      
      public static const kIsMannequin:* = 1 << 0;
      
      public static const kRequiresOceanLot:* = 1 << 1;
      
      public static const kBuildObjHasAdditionalGameplay:* = 1 << 2;
      
      public static const kModularPlaygroundLowPlatform:* = 1 << 3;
      
      public static const kModularPlaygroundHighPlatform:* = 1 << 4;
      
      public function ProductObjectFlags()
      {
         super();
      }
   }
}

