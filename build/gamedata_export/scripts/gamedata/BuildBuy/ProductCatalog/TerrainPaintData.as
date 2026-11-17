package gamedata.BuildBuy.ProductCatalog
{
   import olympus.core.OlympusObject;
   
   public class TerrainPaintData extends OlympusObject
   {
      
      public static const NUM_BRUSH_SIZES:int = 8;
      
      public static const NUM_BRUSH_SHAPES:int = 2;
      
      public static const BRUSH_SHAPE_CIRCLE:int = 0;
      
      public static const BRUSH_SHAPE_SQUARE:int = 1;
      
      public var brushType:int;
      
      public var brushSizeIndex:int;
      
      public var brushSoftness:Number = 0;
      
      public var brushStrength:Number = 0;
      
      public var brushHeight:Number = 0;
      
      public var pondDepthVisualization:Boolean = false;
      
      public function TerrainPaintData(param1:Object = null)
      {
         super(param1);
      }
   }
}

