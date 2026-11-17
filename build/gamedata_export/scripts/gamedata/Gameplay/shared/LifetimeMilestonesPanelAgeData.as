package gamedata.Gameplay.shared
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class LifetimeMilestonesPanelAgeData extends OlympusObject
   {
      
      protected static var sLifetimeMilestonesPanelAgeList:Vector.<LifetimeMilestonesPanelAgeData>;
      
      public var ages:Array = [uint];
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var name:LocKey = new LocKey();
      
      public var anyMilestonesAchieved:Boolean = true;
      
      public function LifetimeMilestonesPanelAgeData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get LifetimeMilestonesPanelAgeList() : Vector.<LifetimeMilestonesPanelAgeData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!sLifetimeMilestonesPanelAgeList)
         {
            _loc1_ = CommunicationManager.CallGameService("GetLifetimeMilestoneAgeFilters") as Array;
            _loc2_ = int(_loc1_.length);
            sLifetimeMilestonesPanelAgeList = new Vector.<LifetimeMilestonesPanelAgeData>(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               sLifetimeMilestonesPanelAgeList[_loc3_] = new LifetimeMilestonesPanelAgeData(_loc1_[_loc3_]);
               _loc3_++;
            }
         }
         return sLifetimeMilestonesPanelAgeList;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.ages);
      }
   }
}

