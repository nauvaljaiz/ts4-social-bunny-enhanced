package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.TimedAspirationStaticData;
   import olympus.core.OlympusObject;
   
   public class TimedAspirationUpdate extends OlympusObject
   {
      
      public static const UPDATE_TYPE_ADD:uint = 0;
      
      public static const UPDATE_TYPE_REMOVE:uint = 1;
      
      public static const UPDATE_TYPE_OBJECTIVE_UPDATE:uint = 2;
      
      public static const TIMED_ASPIRATION_RESOLUTION:uint = 0;
      
      public static const TIMED_ASPIRATION_MIDLIFE_CRISIS:uint = 1;
      
      public static const TIMED_ASPIRATION_CHILDHOOD_INSPIRATION:uint = 2;
      
      public var update_type:uint;
      
      public var sim_id:String;
      
      public var timed_aspiration_id:String;
      
      public var timed_aspiration_end_time:String;
      
      public var timed_aspiration_type:uint;
      
      public var objectives:Array = [String];
      
      public var reward_trait_id:String;
      
      protected var mObjectiveInfos:Vector.<ObjectiveInfo>;
      
      protected var mActiveObjectiveInfos:Vector.<ObjectiveInfo>;
      
      public var mStaticData:TimedAspirationStaticData;
      
      public function TimedAspirationUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      public function get StaticData() : TimedAspirationStaticData
      {
         if(!this.mStaticData && Boolean(this.timed_aspiration_id))
         {
            this.mStaticData = TimedAspirationStaticData.GetStaticData(this.timed_aspiration_id);
         }
         return this.mStaticData;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.objectives);
         this.mObjectiveInfos = GameplayStateData.GetAspirationObjectiveInfos(this.objectives);
         this.mActiveObjectiveInfos = this.GetActiveObjectiveInfos();
      }
      
      public function get ObjectiveInfos() : Vector.<ObjectiveInfo>
      {
         return this.mObjectiveInfos;
      }
      
      public function get ActiveObjectiveInfos() : Vector.<ObjectiveInfo>
      {
         return this.mActiveObjectiveInfos;
      }
      
      private function GetActiveObjectiveInfos() : Vector.<ObjectiveInfo>
      {
         var _loc1_:Vector.<ObjectiveInfo> = new Vector.<ObjectiveInfo>();
         var _loc2_:int = 0;
         while(_loc2_ < this.mObjectiveInfos.length)
         {
            if(!this.mObjectiveInfos[_loc2_].IsComplete)
            {
               _loc1_.push(this.mObjectiveInfos[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

