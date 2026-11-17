package gamedata.BuildBuy.constants
{
   public class PlacementFlags
   {
      
      public static const kPFLowCenterOnWall:uint = 1 << 0;
      
      public static const kPFLowEdgeAgainstWall:uint = 1 << 1;
      
      public static const kPFLowAdjustHeightAgainstWall:uint = 1 << 2;
      
      public static const kPFLowCeiling:uint = 1 << 3;
      
      public static const kPFLowImmovableByUser:uint = 1 << 4;
      
      public static const kPFLowDiagonal:uint = 1 << 5;
      
      public static const kPFLowRoof:uint = 1 << 6;
      
      public static const kPFLowRequiresFence:uint = 1 << 7;
      
      public static const kPFLowShowObjectIfWallDown:uint = 1 << 8;
      
      public static const kPFLowSlottedToFence:uint = 1 << 9;
      
      public static const kPFLowRequiresSlot:uint = 1 << 10;
      
      public static const kPFLowAllowedOnSlope:uint = 1 << 11;
      
      public static const kPFLowRepeatPlacement:uint = 1 << 12;
      
      public static const kPFLowNonDeleteable:uint = 1 << 13;
      
      public static const kPFLowNonInventoryable:uint = 1 << 14;
      
      public static const kPFLowNonAbandonable:uint = 1 << 15;
      
      public static const kPFLowRequiresTerrain:uint = 1 << 16;
      
      public static const kPFLowEncourageIndoor:uint = 1 << 17;
      
      public static const kPFLowEncourageOutdoor:uint = 1 << 18;
      
      public static const kPFLowNonDeletableByUser:uint = 1 << 19;
      
      public static const kPFLowNonInventoryableByUser:uint = 1 << 20;
      
      public static const kPFLowRequiresWaterSurface:uint = 1 << 21;
      
      public static const kPFLowAllowedInFountain:uint = 1 << 22;
      
      public static const kPFLowGroundedAgainstWall:uint = 1 << 23;
      
      public static const kPFLowNotBlueprintable:uint = 1 << 24;
      
      public static const kPFLowIsHuman:uint = 1 << 25;
      
      public static const kPFLowAllowedOnWaterSurface:uint = 1 << 26;
      
      public static const kPFLowAllowedInPool:uint = 1 << 27;
      
      public static const kPFLowOnWallTop:uint = 1 << 28;
      
      public static const kPFLowForceDesignable:uint = 1 << 29;
      
      public static const kPFLowAlwaysBlueprintable:uint = 1 << 30;
      
      public static const kPFLowWallOptional:uint = 1 << 31;
      
      public static const kPFWallPlacement:uint = kPFLowCenterOnWall | kPFLowEdgeAgainstWall;
      
      public static const kPFWallGraphPlacement:uint = kPFWallPlacement | kPFLowRequiresFence;
      
      public static const kPFHighRequiresTransparentFloor:* = 1 << 1;
      
      public static const kPFHighMayIntersectGround:* = 1 << 2;
      
      public static const kPFHighRequiresWater:* = 1 << 3;
      
      public static const kPFHighMayIntersectOceanFloor:* = 1 << 4;
      
      public static const kPFHighAllowedInShallowOcean:* = 1 << 5;
      
      public static const kPFHighAllowedInSwimmableOcean:* = 1 << 6;
      
      public static const kPFHighConformToSlope:* = 1 << 7;
      
      public static const kPFNonPlaceableOnBlockTop:* = 1 << 8;
      
      public static const kPFNonPlaceableOnStilts:* = 1 << 9;
      
      public static const kPFVisualGroupSlottingOnly:* = 1 << 10;
      
      public static const kPFAllowedInShallowPond:* = 1 << 11;
      
      public static const kPFAllowedInDeepPond:* = 1 << 12;
      
      public static const kPFNonDeletableDependent:* = 1 << 13;
      
      public static const kPFAllowedOnCurvedWall:* = 1 << 14;
      
      public static const kPFAllowedOnSmallCurvedWall:* = 1 << 15;
      
      public static const kPFResetRotationOnSlotRemoval:* = 1 << 16;
      
      public static const kPFAllowedOnWallFloor:* = 1 << 17;
      
      public function PlacementFlags()
      {
         super();
      }
   }
}

