package gamedata.CAS.shared
{
   import gamedata.shared.OccultTypes;
   import gamedata.shared.SimAgeTypes;
   import gamedata.shared.SimGenderTypes;
   import olympus.core.OlympusObject;
   
   public class SimInfo extends OlympusObject
   {
      
      public static const RANDOMIZE_ALL_BITS:int = 127;
      
      public static const UPDATE_TYPE_GENERIC:int = 0;
      
      public static const UPDATE_TYPE_RANDOMIZE:int = 1;
      
      public var updateType:int;
      
      public var firstName:String = "";
      
      public var lastName:String = "";
      
      public var pronouns:String = "";
      
      public var simId:String = "";
      
      public var bodyShapePreset:uint = 4;
      
      public var physiqueValues:Array;
      
      public var voicePitch:Number = 0;
      
      public var voiceActor:uint = 0;
      
      public var randomizeFlags:int = 127;
      
      public var gender:int = 0;
      
      public var age:int = 0;
      
      public var maxTraits:int;
      
      public var isNew:Boolean = true;
      
      public var geneticSourceType:uint = 0;
      
      public var geneticSource1:String;
      
      public var geneticSource2:String;
      
      public var geneticSourceIsPreset1:Boolean = false;
      
      public var geneticSourceIsPreset2:Boolean = false;
      
      public var isPregnant:Boolean = false;
      
      public var isGhost:Boolean = false;
      
      public var isRobot:Boolean = false;
      
      public var isUnicorn:Boolean = false;
      
      public var occultType:int = 0;
      
      public var allOccultTypes:int = 0;
      
      public var occultLayer:int = 0;
      
      public var speciesType:int = 0;
      
      public var breedName:String;
      
      public var relationships:Array = new Array();
      
      public var aspiration:String;
      
      public var hasBrokenRelationships:Boolean;
      
      public var householdId:String;
      
      public var creatorRemoteId:String;
      
      public var creatorId:String;
      
      public var creatorName:String;
      
      public var originalFirstName:String;
      
      public var originalLastName:String;
      
      public var isCASStories:Boolean;
      
      public var isCASReincarnating:Boolean;
      
      public function SimInfo(param1:Object = null)
      {
         super(param1);
      }
      
      public function get FacialHairAllowed() : Boolean
      {
         var _loc1_:Boolean = SimGenderTypes.IsFemale(this.gender);
         var _loc2_:Boolean = SimAgeTypes.IsTeenOrOlder(this.age);
         return !_loc1_ && _loc2_;
      }
      
      public function get MakeupAllowed() : Boolean
      {
         var _loc1_:Boolean = SimGenderTypes.IsFemale(this.gender);
         var _loc2_:Boolean = SimAgeTypes.IsTeenOrOlder(this.age);
         return _loc1_ && _loc2_;
      }
      
      public function get ChildrenAllowed() : Boolean
      {
         return SimAgeTypes.IsYoungAdultOrOlder(this.age);
      }
      
      public function get ParentAllowed() : Boolean
      {
         var _loc1_:Boolean = SimAgeTypes.IsElder(this.age);
         return !_loc1_;
      }
      
      public function GetGeneticsArgs() : Object
      {
         return {
            "relType":this.geneticSourceType,
            "source1":this.geneticSource1,
            "source2":this.geneticSource2,
            "isPreset1":this.geneticSourceIsPreset1,
            "isPreset2":this.geneticSourceIsPreset2
         };
      }
      
      public function IsOccultAlternateForm() : Boolean
      {
         return this.occultLayer > OccultTypes.OCCULT_FORM_BASE;
      }
      
      public function ArePronounsSet() : Boolean
      {
         var _loc2_:String = null;
         if(this.pronouns == null || this.pronouns == "")
         {
            return false;
         }
         var _loc1_:Array = this.pronouns.split("|");
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ != "")
            {
               return true;
            }
         }
         return false;
      }
      
      public function get SimIsNew() : Boolean
      {
         return CASStateData.SimIdIsReincarnating(this.simId) || this.isNew;
      }
   }
}

