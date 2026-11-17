package widgets.shared.data.Scenarios
{
   public class ScenarioDisplayFilterData
   {
      
      public var mCategory:int;
      
      public var mTheme:int;
      
      public var mDifficulty:int;
      
      public var mbIsLimitedTime:Boolean;
      
      public function ScenarioDisplayFilterData(param1:int, param2:int, param3:int, param4:Boolean)
      {
         super();
         this.mCategory = param1;
         this.mTheme = param2;
         this.mDifficulty = param3;
         this.mbIsLimitedTime = param4;
      }
   }
}

