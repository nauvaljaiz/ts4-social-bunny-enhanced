package gamedata.Gameplay.shared
{
   import gamedata.Gameplay.shared.definitions.AspirationStaticData;
   import olympus.localization.LocKey;
   
   public class AspirationInfo
   {
      
      public var aspirationId:String;
      
      protected var mbIsUnlocked:Boolean;
      
      protected var mStaticData:AspirationStaticData;
      
      protected var mObjectiveInfos:Vector.<ObjectiveInfo>;
      
      public function AspirationInfo(param1:AspirationStaticData)
      {
         super();
         this.aspirationId = param1.uid;
         this.mStaticData = param1;
         this.mObjectiveInfos = GameplayStateData.GetAspirationObjectiveInfos(param1.objectiveUids);
      }
      
      public function get ObjectiveInfos() : Vector.<ObjectiveInfo>
      {
         return this.mObjectiveInfos;
      }
      
      public function get NumObjectivesCompleted() : int
      {
         var _loc4_:ObjectiveInfo = null;
         var _loc1_:int = int(this.mObjectiveInfos.length);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this.mObjectiveInfos[_loc3_] as ObjectiveInfo;
            if(_loc4_.IsComplete)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get isCompleted() : Boolean
      {
         return this.NumObjectivesCompleted == this.numObjectives;
      }
      
      public function get isUnlocked() : Boolean
      {
         if(this.level == 1 || this.isCompleted)
         {
            return true;
         }
         return this.mbIsUnlocked;
      }
      
      public function set isUnlocked(param1:Boolean) : void
      {
         this.mbIsUnlocked = param1;
      }
      
      public function get staticData() : AspirationStaticData
      {
         return this.mStaticData;
      }
      
      public function get displayName() : LocKey
      {
         return this.mStaticData.displayName;
      }
      
      public function get numObjectives() : uint
      {
         return this.mStaticData.numObjectives;
      }
      
      public function get level() : int
      {
         return this.mStaticData.level;
      }
      
      public function get objectives() : Array
      {
         return this.mStaticData.objectiveUids;
      }
      
      public function get descriptiveText() : String
      {
         return this.mStaticData.descriptiveText.toString();
      }
   }
}

