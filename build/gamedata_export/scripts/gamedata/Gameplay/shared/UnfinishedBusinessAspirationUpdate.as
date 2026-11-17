package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   
   public class UnfinishedBusinessAspirationUpdate extends OlympusObject
   {
      
      public var objectives:Array;
      
      public var sim_id:String;
      
      protected var mObjectiveInfos:Vector.<ObjectiveInfo>;
      
      public var unfinishedBusinessObjectivesCompleted:Array;
      
      public function UnfinishedBusinessAspirationUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.sim_id = param1.sim_id;
         this.objectives = new Array();
         if("objectives" in param1)
         {
            ConstructArrayFromArray(this.objectives,param1.objectives,String);
         }
         this.mObjectiveInfos = GameplayStateData.GetAspirationObjectiveInfos(this.objectives);
         this.unfinishedBusinessObjectivesCompleted = new Array();
         if("objectives_completed" in param1)
         {
            ConstructArrayFromArray(this.unfinishedBusinessObjectivesCompleted,param1.objectives_completed,String);
         }
      }
      
      public function MergeAspirationUpdates(param1:UnfinishedBusinessAspirationUpdate) : void
      {
         this.objectives = param1.objectives;
         this.mObjectiveInfos = GameplayStateData.GetAspirationObjectiveInfos(this.objectives);
      }
      
      public function get ObjectiveInfos() : Vector.<ObjectiveInfo>
      {
         return this.mObjectiveInfos;
      }
   }
}

