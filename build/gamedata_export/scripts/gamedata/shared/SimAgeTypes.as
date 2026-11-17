package gamedata.shared
{
   import gamedata.Gameplay.shared.GameplayStateData;
   import gamedata.Gameplay.shared.OccultUpdate;
   import gamedata.Gameplay.shared.SimTraitsInfo;
   import olympus.io.CommunicationManager;
   
   public final class SimAgeTypes
   {
      
      public static const BABY:int = 1 << 0;
      
      public static const TODDLER:int = 1 << 1;
      
      public static const CHILD:int = 1 << 2;
      
      public static const TEEN:int = 1 << 3;
      
      public static const YOUNGADULT:int = 1 << 4;
      
      public static const ADULT:int = 1 << 5;
      
      public static const ELDER:int = 1 << 6;
      
      public static const INFANT:int = 1 << 7;
      
      public static const MAX:int = 1 << 8;
      
      public function SimAgeTypes()
      {
         super();
      }
      
      public static function IsBaby(param1:int) : Boolean
      {
         return param1 == BABY;
      }
      
      public static function IsInfant(param1:int) : Boolean
      {
         return param1 == INFANT;
      }
      
      public static function IsToddler(param1:int) : Boolean
      {
         return param1 == TODDLER;
      }
      
      public static function IsToddlerOrYounger(param1:int) : Boolean
      {
         return param1 == BABY || param1 == INFANT || param1 == TODDLER;
      }
      
      public static function IsChild(param1:int) : Boolean
      {
         return param1 == CHILD;
      }
      
      public static function IsChildOrYounger(param1:int) : Boolean
      {
         return param1 == BABY || param1 == INFANT || param1 == TODDLER || param1 == CHILD;
      }
      
      public static function IsTeenOrOlder(param1:int) : Boolean
      {
         return param1 == TEEN || param1 == YOUNGADULT || param1 == ADULT || param1 == ELDER;
      }
      
      public static function IsTeen(param1:int) : Boolean
      {
         return param1 == TEEN;
      }
      
      public static function IsYoungAdult(param1:int) : Boolean
      {
         return param1 == YOUNGADULT;
      }
      
      public static function IsYoungAdultOrOlder(param1:int) : Boolean
      {
         return param1 == YOUNGADULT || param1 == ADULT || param1 == ELDER;
      }
      
      public static function IsAdultOrOlder(param1:int) : Boolean
      {
         return param1 == ADULT || param1 == ELDER;
      }
      
      public static function IsElder(param1:int) : Boolean
      {
         return param1 == ELDER;
      }
      
      public static function IsPuppyOrKitten(param1:int) : Boolean
      {
         return param1 == CHILD;
      }
      
      public static function IsValidAge(param1:int) : Boolean
      {
         return IsTeenOrOlder(param1) || IsChildOrYounger(param1);
      }
      
      public static function CompareAges(param1:int, param2:int) : int
      {
         var _loc3_:int = -1;
         switch(param1)
         {
            case BABY:
               _loc3_ = param2 == BABY ? 0 : (param2 == INFANT || param2 == TODDLER || param2 == CHILD || param2 == TEEN || param2 == YOUNGADULT || param2 == ADULT || param2 == ELDER || param2 == MAX ? -1 : 1);
               break;
            case INFANT:
               _loc3_ = param2 == INFANT ? 0 : (param2 == TODDLER || param2 == CHILD || param2 == TEEN || param2 == YOUNGADULT || param2 == ADULT || param2 == ELDER || param2 == MAX ? -1 : 1);
               break;
            case TODDLER:
               _loc3_ = param2 == TODDLER ? 0 : (param2 == CHILD || param2 == TEEN || param2 == YOUNGADULT || param2 == ADULT || param2 == ELDER || param2 == MAX ? -1 : 1);
               break;
            case CHILD:
               _loc3_ = param2 == CHILD ? 0 : (param2 == TEEN || param2 == YOUNGADULT || param2 == ADULT || param2 == ELDER || param2 == MAX ? -1 : 1);
               break;
            case TEEN:
               _loc3_ = param2 == TEEN ? 0 : (param2 == YOUNGADULT || param2 == ADULT || param2 == ELDER || param2 == MAX ? -1 : 1);
               break;
            case YOUNGADULT:
               _loc3_ = param2 == YOUNGADULT ? 0 : (param2 == ADULT || param2 == ELDER || param2 == MAX ? -1 : 1);
               break;
            case ADULT:
               _loc3_ = param2 == ADULT ? 0 : (param2 == ELDER || param2 == MAX ? -1 : 1);
               break;
            case ELDER:
               _loc3_ = param2 == ELDER ? 0 : (param2 == MAX ? -1 : 1);
               break;
            case MAX:
               _loc3_ = param2 == MAX ? 0 : 1;
         }
         return _loc3_;
      }
      
      public static function CanSimAge(param1:uint, param2:String = null) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:OccultUpdate = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:SimTraitsInfo = null;
         if(IsElder(param1))
         {
            return false;
         }
         if(param2 == null)
         {
            param2 = GameplayStateData.ActiveSimId;
         }
         if(param2 == GameplayStateData.ActiveSimId)
         {
            if(GameplayStateData.SimIsGhost)
            {
               return false;
            }
            if(GameplayStateData.SimOccultType.Type == OccultTypes.OCCULT_VAMPIRE && IsYoungAdultOrOlder(param1))
            {
               return false;
            }
            _loc3_ = GameplayStateData.GetTraitInfoByType(SimTraitsInfo.TRAIT_ROBOT).length > 0;
            if(_loc3_)
            {
               return false;
            }
         }
         else
         {
            if(CommunicationManager.CallGameService("GetSimIsGhost",{"simId":param2}))
            {
               return false;
            }
            _loc4_ = new OccultUpdate(CommunicationManager.CallGameService("GetSimOccultType",param2));
            if(_loc4_.Type == OccultTypes.OCCULT_VAMPIRE && IsYoungAdultOrOlder(param1))
            {
               return false;
            }
            _loc5_ = CommunicationManager.CallGameService("GetAllSimTraitsInfo",{"simId":param2}) as Array;
            for each(_loc6_ in _loc5_)
            {
               _loc7_ = new SimTraitsInfo(_loc6_);
               if(_loc7_.TraitType == SimTraitsInfo.TRAIT_ROBOT)
               {
                  return false;
               }
            }
         }
         return true;
      }
   }
}

