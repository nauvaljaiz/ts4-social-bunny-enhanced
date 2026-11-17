package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.ObjectiveStaticData;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ObjectiveInfo extends OlympusObject
   {
      
      public static const SHOW_OVERLAY:String = "undiscovered";
      
      public static const ANIMATE_OVERLAY_AWAY:String = "undiscovered_anim";
      
      public static const ANIMATE_OVERLAY_AWAY_COMPLETE:String = "undiscovered_anim_complete";
      
      public static const HIDE_OVERLAY:String = "revealed";
      
      public static const DEFAULT_OVERLAY_STATE:String = HIDE_OVERLAY;
      
      public var uid:String;
      
      public var numCompleted:int;
      
      public var numTotal:int;
      
      public var bIsMoney:Boolean;
      
      public var bShowProgress:Boolean;
      
      public var bShowTooltipUpdateOnSpecialCases:Boolean;
      
      public var animationState:String = null;
      
      protected var mStaticData:ObjectiveStaticData;
      
      public function ObjectiveInfo(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.mStaticData = ObjectiveStaticData.GetObjectiveStaticData(this.uid);
      }
      
      public function SetCustomStaticData(param1:Object) : void
      {
         this.mStaticData = new ObjectiveStaticData(param1);
      }
      
      public function get IsComplete() : Boolean
      {
         return this.numCompleted == this.numTotal;
      }
      
      public function get DisplayText() : LocKey
      {
         return this.mStaticData.displayText;
      }
      
      public function get SatisfactionPoints() : int
      {
         return this.mStaticData.satisfactionPoints;
      }
      
      public function get ShowProgress() : Boolean
      {
         return this.mStaticData.showProgress;
      }
      
      public function get Tooltip() : LocKey
      {
         return this.mStaticData.tooltip;
      }
      
      public function IsAgeValid(param1:uint) : Boolean
      {
         return this.mStaticData.displayAgeList.length == 0 || this.mStaticData.displayAgeList.indexOf(param1) != -1;
      }
   }
}

