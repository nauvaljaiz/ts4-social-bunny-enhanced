package widgets.shared.controls.FamilyTree
{
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import olympus.core.widget.Margin;
   import olympus.localization.KeysCAS;
   
   public final class FamilyTreeTunables
   {
      
      public static const MAX_CHILDREN_BEFORE_COLLAPSE:int = 180;
      
      public static const SIM_ICON_HEIGHT:Number = 40;
      
      public static const SIM_ICON_WIDTH:Number = 40;
      
      public static const HORIZONTAL_MARGIN:Number = 10;
      
      public static const HORIZONTAL_DISTANCE_BETWEEN_NODE_CENTERS:Number = SIM_ICON_WIDTH + HORIZONTAL_MARGIN;
      
      public static const VERTICAL_MARGIN:Number = 13;
      
      public static const VERTICAL_DISTANCE_BETWEEN_NODE_CENTERS:Number = SIM_ICON_HEIGHT * 2 + VERTICAL_MARGIN;
      
      public static const EDGE_ICON_SIZE:Number = 24;
      
      public static const EDGE_CHILD_TARGET_X_OFFSET:Number = -4;
      
      public static const EDGE_CURVE_CONTROL_POINT_DISTANCE:Number = 3;
      
      public static const EDGE_Y_MIDPOINT_BANDWIDTH:Number = FamilyTreeTunables.SIM_ICON_HEIGHT * 0.5;
      
      public static const EDGE_Y_MIDPOINT_OFFSET:Number = 5;
      
      public static const MIN_TREE_SCALE:Number = 0.15;
      
      public static const MAX_TREE_SCALE:Number = 2;
      
      public static const ZOOM_MOUSEWHEEL_DELTA_MULTIPLIER:Number = 0.07;
      
      public static const CONTROLLER_PAN_SPEED:Number = 10;
      
      public static const ANTECEDENT_STRING_LIST:Array = [null,KeysCAS.PERSONALITY_RELATIONSHIP_PARENT,KeysCAS.PERSONALITY_RELATIONSHIP_GRANDPARENT,KeysCAS.PERSONALITY_RELATIONSHIP_GREATGRANDPARENT,KeysCAS.PERSONALITY_RELATIONSHIP_ANCESTOR];
      
      public static const DESCENDANT_STRING_LIST:Array = [null,KeysCAS.PERSONALITY_RELATIONSHIP_DESCENDANT,KeysCAS.PERSONALITY_RELATIONSHIP_GRANDCHILD,KeysCAS.PERSONALITY_RELATIONSHIP_GREATGRANDCHILD,KeysCAS.PERSONALITY_RELATIONSHIP_LONG_DESCENDANT];
      
      public static const SIM_GROUP_MARGIN:Margin = new Margin(10,20,10,20);
      
      public static const SIM_CHILDREN_MARGIN:Margin = new Margin(0,20,0,0);
      
      public static const SIM_SPOUSE_MARGIN:Margin = new Margin(0,0,0,0);
      
      public static const SIM_PARENT_MARGIN:Margin = new Margin(0,20,0,20);
      
      public static const PARENT_CONNECTION_THICKNESS:uint = 2;
      
      public static const PARENT_CONNECTION_COLOR:uint = 16777215;
      
      public static const GENERIC_CONNECTION_THICKNESS:uint = 2;
      
      public static const GENERIC_CONNECTION_COLOR:uint = 16777215;
      
      public static const DYNASTY_CONNECTION_THICKNESS:uint = 4;
      
      public static const DYNASTY_CONNECTION_COLOR:uint = 16777215;
      
      public static const SECRET_CONNECTION_THICKNESS:uint = 2;
      
      public static const SECRET_CONNECTION_COLOR:uint = 16777215;
      
      public static const SECRET_CONNECTION_DASH_SIZE:uint = 3;
      
      public static const FORGED_CONNECTION_THICKNESS:uint = 2;
      
      public static const FORGED_CONNECTION_COLOR:uint = 16777215;
      
      public static const FORGED_CONNECTION_DASH_SIZE:uint = 6;
      
      public static const EDGE_DROP_SHADOW_EXTRA_WIDTH:uint = 2;
      
      public static const EDGE_DROP_SHADOW_ALPHA:Number = 0.2;
      
      public static const EDGE_DROP_SHADOW_COLOR:uint = 0;
      
      public static const TOOLTIP_BORDER_PADDING:Number = 10;
      
      public static const TOOLTIP_VERTICAL_TEXT_PADDING:Number = 6;
      
      public static const TOOLTIP_DYNASTY_MEMBERSHIP_PADDING:Number = 3;
      
      public static const TOOLTIP_DIVIDER_ALPHA:Number = 0.4;
      
      public static const GRAYSCALE_COLOR_MATRIX:Array = [0.2225,0.7169,0.0606,0,0,0.2225,0.7169,0.0606,0,0,0.2225,0.7169,0.0606,0,0,0,0,0,0.8,0];
      
      public static const PSEUDO_GHOST_GRAYSCALE_IMAGE_FILTER:ColorMatrixFilter = new ColorMatrixFilter(GRAYSCALE_COLOR_MATRIX);
      
      public static const PSEUDO_GHOST_GLOW_IMAGE_FILTER:GlowFilter = new GlowFilter(15790320,0.45,8,8,1,1,true);
      
      public static const PSEUDO_GHOST_FILTERS:Array = [PSEUDO_GHOST_GRAYSCALE_IMAGE_FILTER,PSEUDO_GHOST_GLOW_IMAGE_FILTER];
      
      public static const ROOT_SPOUSE_CONNECTION_COLOR:uint = 16723826;
      
      public static const SPOUSE_CONNECTION_COLOR:uint = 16560329;
      
      public static const PARENT_CONNECTION_CURVE_LENGTH:uint = 5;
      
      public static const PARENT_CONNECTION_OFFSET:Number = PARENT_CONNECTION_CURVE_LENGTH + PARENT_CONNECTION_THICKNESS * 0.5;
      
      public static const GENERATION_CONNECTION_MULTILINE_OFFSET:uint = 20;
      
      public static const TREE_OUT_OF_BOUNDS_REPOSITION_MARGIN:Margin = Margin.TopRightBottomLeft(60,15,15,20);
      
      public static const MODE_NONE:int = 0;
      
      public static const MODE_STEP_FAMILY:int = 1;
      
      public static const MODE_EXTENDED_FAMILY:int = 2;
      
      public static const MODE_IN_LAW_FAMILY:int = 3;
      
      public static const NUM_SIMS_REQUIRED_INCREMENTAL_LOAD:uint = 8;
      
      public function FamilyTreeTunables()
      {
         super();
      }
   }
}

