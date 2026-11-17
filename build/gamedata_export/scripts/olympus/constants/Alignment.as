package olympus.constants
{
   public final class Alignment
   {
      
      public static const TOP:String = "top";
      
      public static const LEFT:String = "left";
      
      public static const CENTER:String = "center";
      
      public static const RIGHT:String = "right";
      
      public static const BOTTOM:String = "bottom";
      
      public static const NONE:String = "none";
      
      public static const TOP_LEFT:String = "topLeft";
      
      public static const TOP_RIGHT:String = "topRight";
      
      public static const BOTTOM_LEFT:String = "bottomLeft";
      
      public static const BOTTOM_RIGHT:String = "bottomRight";
      
      public static const ARROW:String = "arrow";
      
      public function Alignment()
      {
         super();
      }
      
      public static function GetXAlignment(param1:String) : String
      {
         switch(param1)
         {
            case LEFT:
            case TOP_LEFT:
            case BOTTOM_LEFT:
               return Alignment.LEFT;
            case RIGHT:
            case TOP_RIGHT:
            case BOTTOM_RIGHT:
               return Alignment.RIGHT;
            case TOP:
            case BOTTOM:
            case CENTER:
               return Alignment.CENTER;
            default:
               return Alignment.NONE;
         }
      }
      
      public static function GetYAlignment(param1:String) : String
      {
         switch(param1)
         {
            case TOP:
            case TOP_LEFT:
            case TOP_RIGHT:
               return Alignment.TOP;
            case BOTTOM:
            case BOTTOM_LEFT:
            case BOTTOM_RIGHT:
               return Alignment.BOTTOM;
            case LEFT:
            case RIGHT:
            case CENTER:
               return Alignment.CENTER;
            default:
               return Alignment.NONE;
         }
      }
      
      public static function GetOppositeAlignment(param1:String) : String
      {
         switch(param1)
         {
            case TOP:
               return Alignment.BOTTOM;
            case TOP_LEFT:
               return Alignment.BOTTOM_RIGHT;
            case TOP_RIGHT:
               return Alignment.BOTTOM_LEFT;
            case BOTTOM:
               return Alignment.TOP;
            case BOTTOM_LEFT:
               return Alignment.TOP_RIGHT;
            case BOTTOM_RIGHT:
               return Alignment.TOP_LEFT;
            case LEFT:
               return Alignment.RIGHT;
            case RIGHT:
               return Alignment.LEFT;
            case CENTER:
               return Alignment.CENTER;
            default:
               return Alignment.NONE;
         }
      }
   }
}

