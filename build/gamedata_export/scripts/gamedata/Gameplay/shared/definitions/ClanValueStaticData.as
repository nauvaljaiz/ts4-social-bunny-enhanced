package gamedata.Gameplay.shared.definitions
{
   import flash.utils.getDefinitionByName;
   import gamedata.shared.ResourceKey;
   import olympus.core.OlympusObject;
   import olympus.io.CommunicationManager;
   import olympus.localization.LocKey;
   
   public class ClanValueStaticData extends OlympusObject
   {
      
      protected static var sDataMap:Object;
      
      public var clan_value_id:String;
      
      public var name:LocKey = new LocKey();
      
      public var description:LocKey = new LocKey();
      
      public var icon:ResourceKey = new ResourceKey();
      
      public var tooltip:LocKey = new LocKey();
      
      public var discipline_ranked_stat:String;
      
      public function ClanValueStaticData(param1:Object = null)
      {
         super(param1);
      }
      
      public static function get StaticDataMap() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ClanValueStaticData = null;
         if(!sDataMap)
         {
            sDataMap = new Object();
            _loc1_ = CommunicationManager.CallGameService("GetAllClanValues") as Array;
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new ClanValueStaticData(_loc1_[_loc3_]);
               sDataMap[_loc4_.clan_value_id] = _loc4_;
               _loc3_++;
            }
         }
         return sDataMap;
      }
      
      public static function GetStaticData(param1:String) : ClanValueStaticData
      {
         return StaticDataMap[param1];
      }
   }
}

