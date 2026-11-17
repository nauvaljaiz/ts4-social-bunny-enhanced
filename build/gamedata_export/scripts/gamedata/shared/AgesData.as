package gamedata.shared
{
   import gamedata.Gameplay.shared.AgeUpdate;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   import olympus.utils.ArrayUtils;
   
   public class AgesData extends OlympusObject
   {
      
      protected static var sAgesMap:Object = new Object();
      
      public var ageType:uint;
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var icon_selected:ResourceKey = new ResourceKey();
      
      public var name:LocKey = new LocKey();
      
      public var name_gender_neutral:LocKey = new LocKey();
      
      public var personality_traits_count:uint;
      
      public var discoverable_personality_traits_count:uint;
      
      public function AgesData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function GetAgesData(param1:uint, param2:int = 0) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         param1 = Species.ExtendedSpeciesToSpecies(param1);
         var _loc3_:Array = sAgesMap[param1];
         if(_loc3_ == null)
         {
            _loc3_ = CommunicationManager.CallGameService("GetAgesData",{
               "species":param1,
               "age":0
            }) as Array;
            if(_loc3_)
            {
               ConstructArrayInPlace(_loc3_,AgesData);
               sAgesMap[param1] = _loc3_;
            }
         }
         if(_loc3_)
         {
            if(param2 == 0)
            {
               return _loc3_;
            }
            _loc4_ = ArrayUtils.IndexOfByFieldName(_loc3_,"ageType",param2);
            if(_loc4_ >= 0)
            {
               return [_loc3_[_loc4_]];
            }
         }
         return new Array();
      }
      
      public static function GetAgeDataForSim(param1:String) : AgesData
      {
         var _loc2_:AgeUpdate = new AgeUpdate(CommunicationManager.CallGameService("GetSimAge",param1));
         var _loc3_:uint = uint(CommunicationManager.CallGameService("GetSimSpecies",param1));
         var _loc4_:Array = GetAgesData(_loc3_,_loc2_.age);
         if(_loc4_.length > 0)
         {
            return _loc4_[0];
         }
         return null;
      }
      
      public static function CompareAgesData(param1:AgesData, param2:AgesData) : int
      {
         return SimAgeTypes.CompareAges(param1.ageType,param2.ageType);
      }
   }
}

