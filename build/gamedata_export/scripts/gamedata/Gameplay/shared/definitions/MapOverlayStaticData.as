package gamedata.Gameplay.shared.definitions
{
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   
   public class MapOverlayStaticData extends OlympusObject
   {
      
      protected static var sDefaultOverlayMap:MapOverlayStaticData;
      
      protected var mDefaultOverlayMap:Array;
      
      public function MapOverlayStaticData()
      {
         super();
      }
      
      protected static function GetStaticData() : MapOverlayStaticData
      {
         if(!sDefaultOverlayMap)
         {
            sDefaultOverlayMap = new MapOverlayStaticData();
            sDefaultOverlayMap.mDefaultOverlayMap = CommunicationManager.CallGameService("GetDefaultOverlayMap") as Array;
         }
         return sDefaultOverlayMap;
      }
      
      public static function OverlayIsDefault(param1:int) : Boolean
      {
         var _loc2_:* = GetStaticData();
         if(_loc2_.mDefaultOverlayMap == null)
         {
            return false;
         }
         if(param1 in _loc2_.mDefaultOverlayMap && _loc2_.mDefaultOverlayMap[param1] != undefined)
         {
            return true;
         }
         return false;
      }
      
      public static function OverlayOverridesDefault(param1:int) : Array
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc2_:* = new Array();
         var _loc3_:* = GetStaticData();
         if(_loc3_.mDefaultOverlayMap == null)
         {
            return _loc2_;
         }
         for(_loc4_ in _loc3_.mDefaultOverlayMap)
         {
            _loc5_ = _loc3_.mDefaultOverlayMap[_loc4_];
            if(_loc5_ != undefined && _loc5_.indexOf(param1.toString()) != -1)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
   }
}

