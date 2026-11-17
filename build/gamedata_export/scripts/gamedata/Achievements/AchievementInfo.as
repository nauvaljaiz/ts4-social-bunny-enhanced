package gamedata.Achievements
{
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.Gameplay.shared.ObjectiveInfo;
   import olympus.localization.LocKey;
   
   public class AchievementInfo
   {
      
      protected var staticData:AchievementStaticData;
      
      protected var mIsComplete:Boolean = false;
      
      protected var mObjectiveInfos:Vector.<ObjectiveInfo>;
      
      public function AchievementInfo(param1:Object)
      {
         super();
         this.staticData = AchievementStaticData.GetStaticData(param1.uid);
         this.mObjectiveInfos = GameplayStateData.GetAchievementObjectiveInfos(this.staticData.objectives);
      }
      
      public function MergeWithAchievementUpdate(param1:AchievementUpdate) : void
      {
         var _loc5_:ObjectiveInfo = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:int = param1.achievements_completed.indexOf(this.uid);
         if(_loc2_ != -1)
         {
            this.mIsComplete = true;
            return;
         }
         var _loc3_:int = int(this.mObjectiveInfos.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.mObjectiveInfos[_loc4_];
            _loc2_ = param1.objectives_completed.indexOf(_loc5_.uid);
            if(_loc2_ != -1)
            {
               _loc5_.numCompleted = _loc5_.numTotal;
            }
            _loc4_++;
         }
      }
      
      public function get ObjectiveInfos() : Vector.<ObjectiveInfo>
      {
         return this.mObjectiveInfos;
      }
      
      public function get categories() : Array
      {
         return this.staticData.categories;
      }
      
      public function get description() : LocKey
      {
         return this.staticData.description;
      }
      
      public function get title() : String
      {
         return this.staticData.title.toString();
      }
      
      public function get objectives() : Array
      {
         return this.staticData.objectives;
      }
      
      public function get points() : int
      {
         return this.staticData.points;
      }
      
      public function get icon() : String
      {
         return this.staticData.icon.instance;
      }
      
      public function get uid() : String
      {
         return this.staticData.uid;
      }
      
      public function get is_hidden() : Boolean
      {
         return this.staticData.is_hidden;
      }
      
      public function get IsComplete() : Boolean
      {
         return this.mIsComplete;
      }
      
      public function get packId() : int
      {
         return this.staticData.packId;
      }
   }
}

