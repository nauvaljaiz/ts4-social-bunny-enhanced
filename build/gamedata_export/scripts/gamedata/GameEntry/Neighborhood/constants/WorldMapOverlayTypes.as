package gamedata.GameEntry.Neighborhood.constants
{
   public class WorldMapOverlayTypes
   {
      
      public static const NONE:uint = 0;
      
      public static const FLOWERS:uint = 1;
      
      public static const TREES:uint = 2;
      
      public static const GREEN:uint = 3;
      
      public static const INDUSTRIAL:uint = 4;
      
      public static const Quarry_Base:uint = 5;
      
      public static const Quarry_Modern:uint = 6;
      
      public static const Quarry_Green:uint = 7;
      
      public static const HousingBlock_Base:uint = 8;
      
      public static const HousingBlock_Modern:uint = 9;
      
      public static const HousingBlock_Green:uint = 10;
      
      public static const StreetTransform_Base:uint = 11;
      
      public static const StreetTransform_Modern:uint = 12;
      
      public static const StreetTransform_Green:uint = 13;
      
      public static const ApartmentBlock_Base:uint = 14;
      
      public static const ApartmentBlock_Modern:uint = 15;
      
      public static const ApartmentBlock_Green:uint = 16;
      
      public static const Refinery_Base:uint = 17;
      
      public static const Refinery_Modern:uint = 18;
      
      public static const Refinery_Green:uint = 19;
      
      public static const ShippingContainers_Base:uint = 20;
      
      public static const ShippingContainers_Modern:uint = 21;
      
      public static const ShippingContainers_Green:uint = 22;
      
      public static const Docks_Base:uint = 23;
      
      public static const Docks_Modern:uint = 24;
      
      public static const Docks_Green:uint = 25;
      
      public static const GasTowers_Base:uint = 26;
      
      public static const GasTowers_Painted:uint = 27;
      
      public static const RailwayStation_Base:uint = 28;
      
      public static const RailwayStation_Modern:uint = 29;
      
      public static const RailwayStation_Green:uint = 30;
      
      public static const NeighborhoodBlocks_Base:uint = 31;
      
      public static const NeighborhoodBlocks_Modern:uint = 32;
      
      public static const NeighborhoodBlocks_Green:uint = 33;
      
      public function WorldMapOverlayTypes()
      {
         super();
      }
      
      public static function GetOverlayTypeByName(param1:String) : uint
      {
         if(WorldMapOverlayTypes[param1] == undefined)
         {
            return NONE;
         }
         return WorldMapOverlayTypes[param1];
      }
   }
}

