package gamedata.shared
{
   import gamedata.Gameplay.shared.definitions.AspirationTrackStaticData;
   import gamedata.Gameplay.shared.definitions.TraitsStaticData;
   import olympus.core.OlympusObject;
   import olympus.localization.KeysGP;
   
   public class HouseholdSimData extends OlympusObject
   {
      
      public static const HIDDEN_REASON_MISSING:int = 0;
      
      public var id:String;
      
      public var currentLotId:String;
      
      public var name:String;
      
      public var lastName:String;
      
      public var age:int;
      
      public var isPregnant:Boolean;
      
      public var gender:int;
      
      public var householdId:String;
      
      public var allOccultTypes:int;
      
      public var species:uint;
      
      public var breedName:String;
      
      public var isUnicorn:Boolean;
      
      public var hiddenReason:int;
      
      public var fame:RankedStatisticSimData;
      
      public var aspiration:AspirationTrackStaticData;
      
      public var traits:Vector.<TraitsStaticData>;
      
      public var bonusTrait:TraitsStaticData;
      
      public var ghostTrait:TraitsStaticData;
      
      public var simPreferencesData:SimPreferencesData;
      
      public var bCanTravel:Boolean = true;
      
      public var bAtHome:Boolean = true;
      
      public var isGhost:Boolean;
      
      public function HouseholdSimData(param1:Object = null)
      {
         super(param1);
      }
      
      override public function ParseObject(param1:Object) : void
      {
         this.id = param1.id;
         this.currentLotId = param1.currentLotId;
         this.name = param1.name;
         this.lastName = param1.lastName;
         this.age = param1.age;
         this.isPregnant = param1.isPregnant;
         this.gender = param1.gender;
         this.householdId = param1.householdId;
         this.allOccultTypes = param1.allOccultTypes;
         this.species = param1.species;
         this.breedName = param1.breedName;
         this.hiddenReason = "hiddenReason" in param1 ? int(param1.hiddenReason) : -1;
         if("fame" in param1)
         {
            this.fame = new RankedStatisticSimData(param1.fame);
         }
         if("aspirationId" in param1)
         {
            this.aspiration = AspirationTrackStaticData.GetTrackData(param1.aspirationId);
         }
         if("isUnicorn" in param1)
         {
            this.isUnicorn = param1.isUnicorn;
         }
         var _loc2_:Array = param1.traitIds;
         var _loc3_:int = int(_loc2_.length);
         this.traits = new Vector.<TraitsStaticData>(_loc3_,true);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.traits[_loc4_] = TraitsStaticData.GetStaticData(_loc2_[_loc4_]);
            _loc4_++;
         }
         if("bonusTraitId" in param1)
         {
            this.bonusTrait = TraitsStaticData.GetStaticData(param1.bonusTraitId);
         }
         if("ghostTraitId" in param1)
         {
            this.ghostTrait = TraitsStaticData.GetStaticData(param1.ghostTraitId);
         }
         this.isGhost = this.ghostTrait != null;
         var _loc5_:Array = "preferenceLikeIds" in param1 ? param1.preferenceLikeIds : new Array();
         var _loc6_:Array = "preferenceDislikeIds" in param1 ? param1.preferenceDislikeIds : new Array();
         this.simPreferencesData = SimPreferencesData.FromLikeDislikeTraitIds(_loc5_,_loc6_);
      }
      
      public function get HiddenReasonTooltip() : String
      {
         if(this.hiddenReason == HIDDEN_REASON_MISSING)
         {
            return KeysGP.SIM_SELECTOR_PET_MISSING.toString();
         }
         return null;
      }
   }
}

