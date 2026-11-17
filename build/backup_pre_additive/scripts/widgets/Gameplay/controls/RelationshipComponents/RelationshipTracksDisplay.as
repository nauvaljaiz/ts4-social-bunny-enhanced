package widgets.Gameplay.controls.RelationshipComponents
{
   import flash.events.Event;
   import olympus.controls.GUIComponent;
   import olympus.controls.ImageResource;
   import olympus.core.tooltip.TooltipObject;
   import olympus.io.CommunicationManager;
   import olympus.objects.RelationshipByIdInfo;
   import olympus.objects.RelationshipInfo;
   import olympus.objects.RelationshipTrackInfo;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol15")]
   public class RelationshipTracksDisplay extends GUIComponent
   {
      
      public var mcRelBar0:RelationshipProgressBar;
      
      public var mcRelBar1:RelationshipProgressBar;
      
      public var mcUnifiedIcon:ImageResource;
      
      public var mUnifiedIconToolTip:TooltipObject;
      
      protected var mTargetSimId:String;
      
      protected var mActorSimId:String;
      
      protected var mTargetManagerId:int;
      
      public function RelationshipTracksDisplay()
      {
         super();
      }
      
      public function Draw(param1:RelationshipInfo, param2:int = 3) : void
      {
         var _loc3_:Array = null;
         var _loc5_:int = 0;
         this.mTargetSimId = param1.targetId;
         this.mActorSimId = param1.actorId;
         this.mTargetManagerId = param2;
         _loc3_ = param1.relTracks;
         var _loc4_:int = int(_loc3_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            this["mcRelBar" + _loc5_].Draw(_loc3_[_loc5_] as RelationshipTrackInfo);
            _loc5_++;
         }
         switch(_loc4_)
         {
            case 0:
               this.mcRelBar0.visible = false;
               this.mcRelBar1.visible = false;
               gotoAndStop("none");
               break;
            case 1:
               this.mcRelBar0.visible = true;
               this.mcRelBar1.visible = false;
               gotoAndStop("single");
               break;
            case 2:
               this.mcRelBar0.visible = true;
               this.mcRelBar1.visible = true;
               gotoAndStop("multi");
         }
         var _loc6_:int = _loc4_ - 1;
         if(_loc6_ < 0)
         {
            return;
         }
         var _loc7_:RelationshipTrackInfo = _loc3_[_loc6_] as RelationshipTrackInfo;
         if(this.mcUnifiedIcon)
         {
            this.mcUnifiedIcon.LoadImage(_loc7_.track_bit.iconId.instance);
            if(this.mUnifiedIconToolTip)
            {
               this.mUnifiedIconToolTip.SetText(_loc7_.track_bit.name.toString({"simId":this.mActorSimId},{"simId":this.mTargetSimId}));
            }
         }
      }
      
      override protected function ConfigUI() : void
      {
         super.ConfigUI();
         CommunicationManager.AddMessageListener("UpdateSimRelationshipById",this.HandleUpdateRelDataById,this,RelationshipByIdInfo);
      }
      
      override protected function OnRemovedFromStage(param1:Event) : void
      {
         CommunicationManager.RemoveMessageListener("UpdateSimRelationshipById",this.HandleUpdateRelDataById,this);
      }
      
      protected function HandleUpdateRelDataById(param1:RelationshipByIdInfo) : void
      {
         if(param1.relInfo.actorId != this.mActorSimId)
         {
            return;
         }
         if(param1.managerObjectId.manager_id != this.mTargetManagerId || param1.managerObjectId.object_id != this.mTargetSimId)
         {
            return;
         }
         this.Draw(param1.relInfo);
      }
   }
}

