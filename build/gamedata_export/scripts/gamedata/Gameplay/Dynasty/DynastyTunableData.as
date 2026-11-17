package gamedata.Gameplay.Dynasty
{
   import flash.geom.Point;
   import olympus.core.widget.Margin;
   
   public class DynastyTunableData
   {
      
      public static const STEP_DOWN:int = 0;
      
      public static const SET_HEIR:int = 1;
      
      public static const SET_BLACK_SHEEP:int = 2;
      
      public static const REMOVE_MEMBER:int = 3;
      
      public static const REMOVE_BLACK_SHEEP_STATUS:int = 4;
      
      public static const REMOVE_HEIR_STATUS:int = 5;
      
      public static const STATE_REGULAR_MEMBER:String = "member";
      
      public static const STATE_HEIR_MEMBER:String = "heir";
      
      public static const STATE_HEAD_MEMBER:String = "head";
      
      public static const STATE_BLACK_SHEEP_MEMBER:String = "sheep";
      
      public static const STATE_NEUTRAL:String = "neutral";
      
      public static const STATE_CRISIS:String = "crisis";
      
      public static const STATE_BOOST:String = "boost";
      
      public static const FRAME_SET_BLACK_SHEEP:String = "black_sheep";
      
      public static const FRAME_REMOVE_BLACK_SHEEP:String = "remove_black_sheep";
      
      public static const FRAME_SET_HEIR:String = "heir";
      
      public static const FRAME_REMOVE_HEIR:String = "remove_heir";
      
      public static const MEMBER_LIST_CELL_PADDING:Margin = Margin.TopRightBottomLeft(1,1,1,1);
      
      public static const MEMBER_LIST_SCROLLBAR_PADDING:Margin = Margin.TopRightBottomLeft(0,0,0,0);
      
      public static const MEMBER_FILTER_BUTTON_MARGIN:Margin = Margin.TopRightBottomLeft(4,-3,4,-3);
      
      public static const CREST_LIST_CELL_PADDING:Margin = Margin.TopRightBottomLeft(1,1,1,1);
      
      public static const CREST_LIST_SCROLLBAR_PADDING:Margin = Margin.TopRightBottomLeft(0,0,0,0);
      
      public static const PRESTIGE_PROGRESS_BAR_END_FRAME:int = 220;
      
      public static const CONSOLE_LEGENDS_OFFSET:int = 8;
      
      public static const TOOLS_LEGEND_LEFT_OFFSET:Point = new Point(-40,0);
      
      public static const TOOLS_LEGEND_RIGHT_OFFSET:Point = new Point(0,0);
      
      public static const TOOLS_LEGEND_SCALE:Number = 0.55;
      
      public function DynastyTunableData()
      {
         super();
      }
   }
}

