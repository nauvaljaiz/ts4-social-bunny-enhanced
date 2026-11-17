package gamedata.Gameplay.shared
{
   import gamedata.shared.SimAgeTypes;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.KeysGP;
   import olympus.localization.LocKey;
   
   public class AgeUpdate extends OlympusObject
   {
      
      public static const MIN_AGE:uint = 0;
      
      public static const MAX_AGE:uint = 100;
      
      public static const ageGroups:Object = {};
      
      public static const ageIconLabels:Object = {};
      
      ageGroups[SimAgeTypes.BABY.toString()] = KeysGP.SIM_INFO_AGE_BABY;
      ageGroups[SimAgeTypes.INFANT.toString()] = KeysGP.SIM_INFO_AGE_INFANT;
      ageGroups[SimAgeTypes.TODDLER.toString()] = KeysGP.SIM_INFO_AGE_TODDLER;
      ageGroups[SimAgeTypes.CHILD.toString()] = KeysGP.SIM_INFO_AGE_CHILD;
      ageGroups[SimAgeTypes.TEEN.toString()] = KeysGP.SIM_INFO_AGE_TEEN;
      ageGroups[SimAgeTypes.YOUNGADULT.toString()] = KeysGP.SIM_INFO_AGE_YOUNGADULT;
      ageGroups[SimAgeTypes.ADULT.toString()] = KeysGP.SIM_INFO_AGE_ADULT;
      ageGroups[SimAgeTypes.ELDER.toString()] = KeysGP.SIM_INFO_AGE_ELDER;
      ageIconLabels[SimAgeTypes.BABY.toString()] = "BabyIcon";
      ageIconLabels[SimAgeTypes.INFANT.toString()] = "InfantIcon";
      ageIconLabels[SimAgeTypes.TODDLER.toString()] = "ToddlerIcon";
      ageIconLabels[SimAgeTypes.CHILD.toString()] = "ChildIcon";
      ageIconLabels[SimAgeTypes.TEEN.toString()] = "TeenIcon";
      ageIconLabels[SimAgeTypes.YOUNGADULT.toString()] = "YoungAdultIcon";
      ageIconLabels[SimAgeTypes.ADULT.toString()] = "AdultIcon";
      ageIconLabels[SimAgeTypes.ELDER.toString()] = "ElderIcon";
      ageIconLabels[SimAgeTypes.MAX.toString()] = "DeathIcon";
      
      public var simId:String;
      
      public var age:uint;
      
      public var ageString:LocKey;
      
      public var nextAge:uint;
      
      public var nextAgeString:LocKey = new LocKey();
      
      public function AgeUpdate(param1:Object = null)
      {
         super(param1);
      }
      
      public static function ConvertAgeToString(param1:uint) : LocKey
      {
         return ageGroups[param1.toString()];
      }
      
      public static function GetNextAge(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         return CommunicationManager.CallGameService("GetSimNextAge",param1,false) as uint;
      }
      
      public static function GetIconName(param1:uint) : String
      {
         return ageIconLabels[param1.toString()];
      }
      
      override public function ParseObject(param1:Object) : void
      {
         super.ParseObject(param1);
         this.ageString = AgeUpdate.ConvertAgeToString(this.age);
         this.nextAge = AgeUpdate.GetNextAge(this.age);
         this.nextAgeString = AgeUpdate.ConvertAgeToString(this.nextAge);
      }
   }
}

