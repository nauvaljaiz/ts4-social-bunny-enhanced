package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class CareerSituationStaticData extends OlympusObject
   {
      
      protected static var sCareerSituationStaticData:Vector.<CareerSituationStaticData>;
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sCareerMap:Object = new Object();
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var uid:String;
      
      public function CareerSituationStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get STATIC_DATA() : Vector.<CareerSituationStaticData>
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!sCareerSituationStaticData)
         {
            _loc1_ = CommunicationManager.CallGameService("GetCareerSituationStaticData",null,true) as Array;
            if(!_loc1_)
            {
               return null;
            }
            _loc2_ = int(_loc1_.length);
            sCareerSituationStaticData = new Vector.<CareerSituationStaticData>(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               sCareerSituationStaticData[_loc3_] = new CareerSituationStaticData(_loc1_[_loc3_]);
               _loc3_++;
            }
         }
         return sCareerSituationStaticData;
      }
      
      public static function GetStaticData(param1:String) : CareerSituationStaticData
      {
         var _loc4_:Vector.<CareerSituationStaticData> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:CareerSituationStaticData = null;
         if(sGetStaticDataFunc == null)
         {
            _loc4_ = STATIC_DATA;
            if(!_loc4_)
            {
               return null;
            }
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc4_[_loc6_];
               if(_loc7_.uid == param1)
               {
                  return _loc7_;
               }
               _loc6_++;
            }
            return null;
         }
         var _loc2_:CareerSituationStaticData = sCareerMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new CareerSituationStaticData(_loc3_[0]);
            sCareerMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
   }
}

