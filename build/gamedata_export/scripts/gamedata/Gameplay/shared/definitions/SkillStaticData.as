package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class SkillStaticData extends OlympusObject
   {
      
      protected static var sStaticData:Vector.<SkillStaticData>;
      
      public static var sGetStaticDataFunc:Function;
      
      public static const SKILL_LEVEL_STRINGS:Array = [KeysGP.SIM_INFO_SKILL_PANEL_MAJOR_SKILL.toString(),KeysGP.SIM_INFO_SKILL_PANEL_MINOR_SKILL.toString(),KeysGP.SIM_INFO_SKILL_PANEL_CHILD_SKILL.toString()];
      
      protected static var sSkillMap:Object = new Object();
      
      public var skillTitle:LocKey = new LocKey();
      
      public var skillIconResId:ResourceKey = new ResourceKey();
      
      public var maxSkillLevel:uint;
      
      public var skillId:String;
      
      public var skillDescription:LocKey = new LocKey();
      
      public var lockedDescription:LocKey = new LocKey();
      
      public var skillLevelType:uint;
      
      public var skillCategory:uint;
      
      public var priority:uint;
      
      public var mood_id:String;
      
      public var tooltip_icon_list:Array = [ResourceKey];
      
      public var hidden:Boolean;
      
      public var endPoints:Array = [uint];
      
      public var endPointsAccumulated:Array = [uint];
      
      public var nextLevelTeaser:Array = [LocKey];
      
      public var simId:String;
      
      public function SkillStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetStaticData(param1:String) : SkillStaticData
      {
         var _loc2_:SkillStaticData = sSkillMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new SkillStaticData(_loc3_[0]);
            sSkillMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         var _loc2_:uint = this.endPoints.length;
         var _loc3_:uint = 0;
         this.endPointsAccumulated = new Array(_loc2_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ += this.endPoints[_loc4_];
            this.endPointsAccumulated[_loc4_] = _loc3_;
            _loc4_++;
         }
         FixupArray(this.nextLevelTeaser);
         FixupArray(this.tooltip_icon_list);
      }
      
      public function IsSkillLearned(param1:uint) : Boolean
      {
         if(Boolean(this.endPoints) && this.endPoints[0] < param1)
         {
            return true;
         }
         return false;
      }
   }
}

