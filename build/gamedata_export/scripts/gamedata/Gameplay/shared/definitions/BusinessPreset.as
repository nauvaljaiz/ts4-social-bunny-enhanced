package gamedata.Gameplay.shared.definitions
{
   import gamedata.Gameplay.Clubs.ClubConductRule;
   import gamedata.Gameplay.shared.GameplayStateData;
   import olympus.core.OlympusObject;
   import olympus.utils.ArrayUtils;
   
   public class BusinessPreset extends OlympusObject
   {
      
      public var id:String;
      
      public var name:String;
      
      public var rules:Array = [ClubConductRule];
      
      public function BusinessPreset(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetAllPresets() : Array
      {
         return SmallBusinessStaticData.GetStaticData().presets.concat(GameplayStateData.GetCustomBusinessPresets());
      }
      
      public static function IsPresetCustom(param1:String) : Boolean
      {
         var _loc2_:int = ArrayUtils.IndexOfByFieldName(SmallBusinessStaticData.GetStaticData().presets,"name",param1);
         return _loc2_ == -1;
      }
      
      public static function PresetExistsWithName(param1:String) : Boolean
      {
         var _loc3_:BusinessPreset = null;
         var _loc2_:Array = GetAllPresets();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.name == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         FixupArray(this.rules);
      }
      
      public function ToObject() : Object
      {
         var _loc1_:Object = {};
         _loc1_["id"] = this.id;
         _loc1_["name"] = this.name;
         _loc1_["rules"] = this.RulesArrayToObject();
         return _loc1_;
      }
      
      public function RulesArrayToObject() : Array
      {
         var _loc1_:int = int(this.rules.length);
         var _loc2_:Array = new Array(_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_[_loc3_] = (this.rules[_loc3_] as ClubConductRule).ToObject();
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

