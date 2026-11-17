package gamedata.Gameplay.shared
{
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class SkillInfo extends OlympusObject
   {
      
      public var skillTitle:LocKey = new LocKey();
      
      public var skillIconResId:String;
      
      public var currSkillLevel:int;
      
      public var currSkillValue:uint;
      
      public var currSkillLevelMin:uint;
      
      public var currSkillLevelMax:uint;
      
      public var maxSkillLevel:uint;
      
      public var skillId:String;
      
      public var skillDescription:LocKey = new LocKey();
      
      public var lockedDescription:LocKey = new LocKey();
      
      public var simId:String;
      
      public function SkillInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public function get skillProgressSort() : Number
      {
         if(this.currSkillLevel == 0)
         {
            return -1;
         }
         return this.skillProgressDisplay;
      }
      
      public function get skillProgressDisplay() : Number
      {
         return (this.currSkillValue - this.currSkillLevelMin) / (this.currSkillLevelMax - this.currSkillLevelMin);
      }
   }
}

