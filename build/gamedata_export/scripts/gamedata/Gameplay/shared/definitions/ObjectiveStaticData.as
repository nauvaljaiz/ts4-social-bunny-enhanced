package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import olympus.core.OlympusObject;
   import olympus.localization.LocKey;
   
   public class ObjectiveStaticData extends OlympusObject
   {
      
      public static var sGetStaticDataFunc:Function;
      
      protected static var sObjectiveMap:Object = new Object();
      
      public var uid:String;
      
      public var displayText:LocKey = new LocKey();
      
      public var displayAgeList:Array = [uint];
      
      public var satisfactionPoints:int;
      
      public var showProgress:Boolean;
      
      public var tooltip:LocKey = new LocKey();
      
      public function ObjectiveStaticData(param1:Object = null)
      {
         super(param1);
         FixupArray(this.displayAgeList);
      }
      
      public static function GetObjectiveStaticData(param1:String) : ObjectiveStaticData
      {
         var _loc2_:ObjectiveStaticData = sObjectiveMap[param1];
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:Array = sGetStaticDataFunc([param1]);
         if(_loc3_[0])
         {
            _loc2_ = new ObjectiveStaticData(_loc3_[0]);
            sObjectiveMap[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
   }
}

