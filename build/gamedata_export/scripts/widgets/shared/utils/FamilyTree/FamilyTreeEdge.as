package widgets.shared.utils.FamilyTree
{
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import widgets.shared.controls.FamilyTree.FamilyTreeEdgeIcon;
   import widgets.shared.controls.FamilyTree.FamilyTreeTunables;
   
   public class FamilyTreeEdge
   {
      
      public static const STYLE_STANDARD:uint = 0;
      
      public static const STYLE_DYNASTY:uint = 1;
      
      public static const STYLE_SECRET:uint = 2;
      
      public static const STYLE_FORGED:uint = 3;
      
      public static const REL_GENERIC:uint = 0;
      
      public static const REL_SPOUSE:uint = 1;
      
      public static const REL_EX_SPOUSE:uint = 2;
      
      public static const REL_FORGED:uint = 3;
      
      public static const REL_CHILD:uint = 4;
      
      protected static const STEP_MOVE:uint = 0;
      
      protected static const STEP_LINE:uint = 1;
      
      protected static const STEP_CURVE:uint = 2;
      
      protected var mStepsToDraw:Vector.<Object>;
      
      protected var mSourceX:Number;
      
      protected var mSourceY:Number;
      
      protected var mTargetX:Number;
      
      protected var mTargetY:Number;
      
      protected var mIconX:Number;
      
      protected var mIconY:Number;
      
      protected var mIconType:int;
      
      protected var mStyleType:uint;
      
      protected var mRelationshipType:uint;
      
      protected var mHorizontalOffsetIndex:Number;
      
      protected var mHorizontalOffsetMaxIndex:Number;
      
      public function FamilyTreeEdge(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint = 0, param6:uint = 0, param7:Number = 1, param8:Number = 1)
      {
         super();
         this.mStepsToDraw = new Vector.<Object>();
         this.mSourceX = this.XGridCoordToSpace(param1);
         this.mSourceY = this.YGridCoordToSpace(param2);
         this.mTargetX = this.XGridCoordToSpace(param3);
         this.mTargetY = this.YGridCoordToSpace(param4);
         this.mStyleType = param5;
         this.mRelationshipType = param6;
         this.mHorizontalOffsetIndex = param7;
         this.mHorizontalOffsetMaxIndex = param8;
         this.GenerateSteps();
      }
      
      public function get IconX() : Number
      {
         return this.mIconX;
      }
      
      public function get IconY() : Number
      {
         return this.mIconY;
      }
      
      public function get IconType() : int
      {
         return this.mIconType;
      }
      
      public function get UsesDashedLine() : Boolean
      {
         return this.mStyleType == STYLE_SECRET || this.mStyleType == STYLE_FORGED;
      }
      
      public function ComputeMidpointY() : Number
      {
         var _loc1_:Number = NaN;
         _loc1_ = FamilyTreeTunables.EDGE_Y_MIDPOINT_BANDWIDTH;
         var _loc2_:Number = _loc1_ / this.mHorizontalOffsetMaxIndex;
         var _loc3_:Number = (this.mSourceY + this.mTargetY) * 0.5 + FamilyTreeTunables.EDGE_Y_MIDPOINT_OFFSET;
         return _loc3_ - _loc1_ + _loc2_ * this.mHorizontalOffsetIndex;
      }
      
      public function GenerateSteps() : void
      {
         switch(this.mRelationshipType)
         {
            case REL_SPOUSE:
            case REL_EX_SPOUSE:
            case REL_GENERIC:
               this.GeneratePartnerSteps();
               break;
            case REL_CHILD:
            case REL_FORGED:
               this.GenerateChildSteps();
         }
      }
      
      public function XGridCoordToSpace(param1:Number) : Number
      {
         return FamilyTreeTunables.SIM_ICON_WIDTH / 2 + param1 * FamilyTreeTunables.HORIZONTAL_DISTANCE_BETWEEN_NODE_CENTERS;
      }
      
      public function YGridCoordToSpace(param1:Number) : Number
      {
         return FamilyTreeTunables.SIM_ICON_HEIGHT / 2 + param1 * FamilyTreeTunables.VERTICAL_DISTANCE_BETWEEN_NODE_CENTERS;
      }
      
      public function GeneratePartnerSteps() : void
      {
         this.mIconType = this.mRelationshipType == REL_EX_SPOUSE ? FamilyTreeEdgeIcon.DIVORCED : (this.mRelationshipType == REL_SPOUSE ? FamilyTreeEdgeIcon.MARRIED : int(undefined));
         this.mIconX = (this.mSourceX + this.mTargetX) / 2;
         this.mIconY = (this.mSourceY + this.mTargetY) / 2;
         this.mStepsToDraw.push({
            "op":STEP_MOVE,
            "x":this.mSourceX,
            "y":this.mSourceY
         });
         this.mStepsToDraw.push({
            "op":STEP_LINE,
            "x":this.mTargetX,
            "y":this.mTargetY
         });
      }
      
      public function GenerateChildSteps() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc1_ = 2.25;
         var _loc2_:Boolean = this.mSourceX <= this.mTargetX + _loc1_ && this.mSourceX >= this.mTargetX - _loc1_;
         this.mStepsToDraw.push({
            "op":STEP_MOVE,
            "x":this.mSourceX,
            "y":this.mSourceY
         });
         if(_loc2_)
         {
            this.mStepsToDraw.push({
               "op":STEP_LINE,
               "x":this.mSourceX,
               "y":this.mTargetY
            });
         }
         else
         {
            _loc3_ = this.mSourceX > this.mTargetX;
            _loc4_ = this.mTargetX + FamilyTreeTunables.EDGE_CHILD_TARGET_X_OFFSET;
            _loc5_ = this.ComputeMidpointY();
            _loc6_ = FamilyTreeTunables.EDGE_CURVE_CONTROL_POINT_DISTANCE;
            if(_loc3_)
            {
               this.mStepsToDraw.push({
                  "op":STEP_LINE,
                  "x":this.mSourceX,
                  "y":_loc5_ - _loc6_
               });
               this.mStepsToDraw.push({
                  "op":STEP_CURVE,
                  "controlX":this.mSourceX,
                  "controlY":_loc5_,
                  "anchorX":this.mSourceX - _loc6_,
                  "anchorY":_loc5_
               });
               this.mStepsToDraw.push({
                  "op":STEP_LINE,
                  "x":_loc4_ + _loc6_,
                  "y":_loc5_
               });
               this.mStepsToDraw.push({
                  "op":STEP_CURVE,
                  "controlX":_loc4_,
                  "controlY":_loc5_,
                  "anchorX":_loc4_,
                  "anchorY":_loc5_ + _loc6_
               });
               this.mStepsToDraw.push({
                  "op":STEP_LINE,
                  "x":_loc4_,
                  "y":this.mTargetY
               });
            }
            else
            {
               this.mStepsToDraw.push({
                  "op":STEP_LINE,
                  "x":this.mSourceX,
                  "y":_loc5_ - _loc6_
               });
               this.mStepsToDraw.push({
                  "op":STEP_CURVE,
                  "controlX":this.mSourceX,
                  "controlY":_loc5_,
                  "anchorX":this.mSourceX + _loc6_,
                  "anchorY":_loc5_
               });
               this.mStepsToDraw.push({
                  "op":STEP_LINE,
                  "x":_loc4_ - _loc6_,
                  "y":_loc5_
               });
               this.mStepsToDraw.push({
                  "op":STEP_CURVE,
                  "controlX":_loc4_,
                  "controlY":_loc5_,
                  "anchorX":_loc4_,
                  "anchorY":_loc5_ + _loc6_
               });
               this.mStepsToDraw.push({
                  "op":STEP_LINE,
                  "x":_loc4_,
                  "y":this.mTargetY
               });
            }
         }
      }
      
      public function SetPlainLineStyle(param1:Graphics) : void
      {
         switch(this.mStyleType)
         {
            case STYLE_STANDARD:
               param1.lineStyle(FamilyTreeTunables.GENERIC_CONNECTION_THICKNESS,FamilyTreeTunables.GENERIC_CONNECTION_COLOR,1,false,LineScaleMode.NONE,CapsStyle.SQUARE);
               break;
            case STYLE_DYNASTY:
               param1.lineStyle(FamilyTreeTunables.DYNASTY_CONNECTION_THICKNESS,FamilyTreeTunables.DYNASTY_CONNECTION_COLOR,1,false,LineScaleMode.NONE,CapsStyle.SQUARE);
         }
      }
      
      public function SetPlainLineBackgroundStyle(param1:Graphics) : void
      {
         var _loc2_:Number = this.mStyleType == STYLE_DYNASTY ? FamilyTreeTunables.DYNASTY_CONNECTION_THICKNESS : FamilyTreeTunables.GENERIC_CONNECTION_THICKNESS;
         _loc2_ += FamilyTreeTunables.EDGE_DROP_SHADOW_EXTRA_WIDTH;
         param1.lineStyle(_loc2_,FamilyTreeTunables.EDGE_DROP_SHADOW_COLOR,FamilyTreeTunables.EDGE_DROP_SHADOW_ALPHA,false,LineScaleMode.NONE,CapsStyle.SQUARE);
      }
      
      public function GetDashLineStyle(param1:Graphics) : FamilyTreeDashedLine
      {
         var _loc2_:FamilyTreeDashedLine = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         switch(this.mStyleType)
         {
            case STYLE_SECRET:
               _loc3_ = [FamilyTreeTunables.SECRET_CONNECTION_DASH_SIZE,FamilyTreeTunables.SECRET_CONNECTION_DASH_SIZE];
               _loc2_ = new FamilyTreeDashedLine(param1,FamilyTreeTunables.SECRET_CONNECTION_THICKNESS,FamilyTreeTunables.SECRET_CONNECTION_COLOR,1,_loc3_);
               break;
            case STYLE_FORGED:
               _loc4_ = [FamilyTreeTunables.FORGED_CONNECTION_DASH_SIZE,FamilyTreeTunables.FORGED_CONNECTION_DASH_SIZE];
               _loc2_ = new FamilyTreeDashedLine(param1,FamilyTreeTunables.FORGED_CONNECTION_THICKNESS,FamilyTreeTunables.FORGED_CONNECTION_COLOR,1,_loc4_);
         }
         return _loc2_;
      }
      
      public function GetDashLineBackgroundStyle(param1:Graphics) : FamilyTreeDashedLine
      {
         var _loc2_:FamilyTreeDashedLine = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         switch(this.mStyleType)
         {
            case STYLE_SECRET:
               _loc3_ = [FamilyTreeTunables.SECRET_CONNECTION_DASH_SIZE,FamilyTreeTunables.SECRET_CONNECTION_DASH_SIZE];
               _loc2_ = new FamilyTreeDashedLine(param1,FamilyTreeTunables.SECRET_CONNECTION_THICKNESS + FamilyTreeTunables.EDGE_DROP_SHADOW_EXTRA_WIDTH,FamilyTreeTunables.EDGE_DROP_SHADOW_COLOR,FamilyTreeTunables.EDGE_DROP_SHADOW_ALPHA,_loc3_);
               break;
            case STYLE_FORGED:
               _loc4_ = [FamilyTreeTunables.FORGED_CONNECTION_DASH_SIZE,FamilyTreeTunables.FORGED_CONNECTION_DASH_SIZE];
               _loc2_ = new FamilyTreeDashedLine(param1,FamilyTreeTunables.FORGED_CONNECTION_THICKNESS + FamilyTreeTunables.EDGE_DROP_SHADOW_EXTRA_WIDTH,FamilyTreeTunables.EDGE_DROP_SHADOW_COLOR,FamilyTreeTunables.EDGE_DROP_SHADOW_ALPHA,_loc4_);
         }
         return _loc2_;
      }
      
      public function DrawToGraphics(param1:Graphics) : void
      {
         var _loc2_:FamilyTreeDashedLine = null;
         this.SetPlainLineBackgroundStyle(param1);
         if(this.UsesDashedLine)
         {
            _loc2_ = this.GetDashLineBackgroundStyle(param1);
         }
         this.Draw(param1,_loc2_);
         this.SetPlainLineStyle(param1);
         if(this.UsesDashedLine)
         {
            _loc2_ = this.GetDashLineStyle(param1);
         }
         this.Draw(param1,_loc2_);
      }
      
      protected function Draw(param1:Graphics, param2:FamilyTreeDashedLine) : void
      {
         var _loc3_:Object = null;
         for each(_loc3_ in this.mStepsToDraw)
         {
            switch(_loc3_.op)
            {
               case STEP_MOVE:
                  if(param2)
                  {
                     param2.MoveTo(_loc3_.x,_loc3_.y);
                  }
                  else
                  {
                     param1.moveTo(_loc3_.x,_loc3_.y);
                  }
                  break;
               case STEP_LINE:
                  if(param2)
                  {
                     param2.LineTo(_loc3_.x,_loc3_.y);
                  }
                  else
                  {
                     param1.lineTo(_loc3_.x,_loc3_.y);
                  }
                  break;
               case STEP_CURVE:
                  if(param2)
                  {
                     param2.CurveTo(_loc3_.controlX,_loc3_.controlY,_loc3_.anchorX,_loc3_.anchorY);
                  }
                  else
                  {
                     param1.curveTo(_loc3_.controlX,_loc3_.controlY,_loc3_.anchorX,_loc3_.anchorY);
                  }
            }
         }
      }
   }
}

