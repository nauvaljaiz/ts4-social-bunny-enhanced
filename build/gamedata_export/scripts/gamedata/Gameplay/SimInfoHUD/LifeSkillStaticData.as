package gamedata.Gameplay.SimInfoHUD
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import gamedata.shared.SimAgeTypes;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class LifeSkillStaticData extends OlympusObject
   {
      
      protected static var sLifeSkillList:Vector.<LifeSkillStaticData>;
      
      public static const ID_CONFLICT_RESOLUTION:String = "161616";
      
      public static const ID_EMOTIONAL_CONTROL:String = "161618";
      
      public static const ID_EMPATHY:String = "161617";
      
      public static const ID_MANNERS:String = "161614";
      
      public static const ID_RESPONSIBILITY:String = "161615";
      
      public var life_skill_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var age_up_traits:Array = [LifeSkillTrait];
      
      public var max_value:Number = 100;
      
      public var min_value:Number = -100;
      
      public function LifeSkillStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function AreLifeSkillsAvailable(param1:int) : Boolean
      {
         return Boolean(LifeSkillList) && (SimAgeTypes.IsTeen(param1) || SimAgeTypes.IsToddler(param1) || SimAgeTypes.IsChild(param1));
      }
      
      public static function get LifeSkillList() : Vector.<LifeSkillStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<LifeSkillStaticData> = null;
         var _loc4_:int = 0;
         if(!sLifeSkillList)
         {
            _loc1_ = CommunicationManager.CallGameService("GetLifeSkills") as Array;
            _loc2_ = _loc1_ ? int(_loc1_.length) : 0;
            if(_loc2_ > 0)
            {
               _loc3_ = new Vector.<LifeSkillStaticData>(_loc2_,true);
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc3_[_loc4_] = new LifeSkillStaticData(_loc1_[_loc4_]);
                  _loc4_++;
               }
               sLifeSkillList = _loc3_;
            }
         }
         return sLifeSkillList;
      }
      
      public static function GetLifeSkillById(param1:String) : LifeSkillStaticData
      {
         var _loc3_:LifeSkillStaticData = null;
         var _loc2_:Vector.<LifeSkillStaticData> = LifeSkillList;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.life_skill_id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.age_up_traits);
         this.age_up_traits.sort(this.SortAgeUpTraits);
      }
      
      public function GetLifeSkillTraitForValue(param1:Number) : LifeSkillTrait
      {
         var _loc2_:LifeSkillTrait = null;
         for each(_loc2_ in this.age_up_traits)
         {
            if(param1 >= _loc2_.lower_bound && param1 <= _loc2_.upper_bound)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function SortAgeUpTraits(param1:LifeSkillTrait, param2:LifeSkillTrait) : Number
      {
         var _loc3_:Number = param1.lower_bound - param2.lower_bound;
         if(_loc3_ != 0)
         {
            return _loc3_;
         }
         return param1.upper_bound - param2.upper_bound;
      }
   }
}

