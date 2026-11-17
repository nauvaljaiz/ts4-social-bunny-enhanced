package widgets.Gameplay.controls.RelationshipComponents
{
   import flash.events.Event;
   import gamedata.Gameplay.shared.definitions.RelationshipTrackStaticData;
   import olympus.gui.progressbars.DoubleProgressBar;
   import olympus.objects.RelationshipTrackInfo;
   
   public class RelationshipProgressBar extends DoubleProgressBar
   {
      
      protected var mRelationshipTrackInfo:RelationshipTrackInfo;
      
      public function RelationshipProgressBar()
      {
         super();
      }
      
      public function Draw(param1:RelationshipTrackInfo, param2:Boolean = false) : void
      {
         var _loc6_:String = null;
         if(!param1)
         {
            this.mRelationshipTrackInfo.removeEventListener(RelationshipTrackInfo.RELATIONSHIP_TRACK_TICK,this.OnTrackUpdate);
            this.mRelationshipTrackInfo = param1;
            return;
         }
         this.mRelationshipTrackInfo = param1;
         if(!mbInitialized || !mcFill || !mcFillFront)
         {
            return;
         }
         var _loc3_:String = this.mRelationshipTrackInfo.track_id;
         var _loc4_:Number = Number(this.mRelationshipTrackInfo.CurrentTrackScore);
         var _loc5_:Boolean = _loc3_ == RelationshipTrackStaticData.RomanceTrackId;
         if(_loc5_ && _loc4_ >= 0)
         {
            _loc6_ = RelationshipComponentsTunables.ROMANCE_POSITIVE_TRACK_LABEL;
         }
         else if(_loc5_ && _loc4_ < 0)
         {
            _loc6_ = RelationshipComponentsTunables.ROMANCE_NEGATIVE_TRACK_LABEL;
         }
         else if(_loc4_ >= 0)
         {
            _loc6_ = RelationshipComponentsTunables.FRIENDSHIP_POSITIVE_TRACK_LABEL;
         }
         else
         {
            _loc6_ = RelationshipComponentsTunables.FRIENDSHIP_NEGATIVE_TRACK_LABEL;
         }
         mcFill.gotoAndStop(_loc6_);
         mcFillFront.gotoAndStop(_loc6_);
         var _loc7_:Number = Math.abs(_loc4_) * 0.01;
         SetValue(_loc7_,param2);
         this.mRelationshipTrackInfo.removeEventListener(RelationshipTrackInfo.RELATIONSHIP_TRACK_TICK,this.OnTrackUpdate);
         if(Boolean(this.mRelationshipTrackInfo.change_rate) && this.mRelationshipTrackInfo.change_rate != 0)
         {
            this.mRelationshipTrackInfo.addEventListener(RelationshipTrackInfo.RELATIONSHIP_TRACK_TICK,this.OnTrackUpdate,false,0,true);
         }
      }
      
      override protected function OnRemovedFromStage(param1:Event) : void
      {
         super.OnRemovedFromStage(param1);
         if(this.mRelationshipTrackInfo)
         {
            this.mRelationshipTrackInfo.removeEventListener(RelationshipTrackInfo.RELATIONSHIP_TRACK_TICK,this.OnTrackUpdate);
         }
      }
      
      protected function OnTrackUpdate(param1:Event) : void
      {
         this.Draw(this.mRelationshipTrackInfo,false);
      }
   }
}

